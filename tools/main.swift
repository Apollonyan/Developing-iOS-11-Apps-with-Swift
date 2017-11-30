//
//  Created by Apollo Zhu on 3/12/17.
//  This work is licensed under a
//  Creative Commons Attribution-NonCommercial-ShareAlike 3.0 United States License.
//

import Foundation
import AppKit

/// itunes.apple.com/course/id<#iTunesUCourseID#>
let iTunesUCourseID = 1309275316

enum ResourceType: String, CustomStringConvertible {
    // Raw Type: video/x-m4v, video/mp4
    case video = "Video"
    // Raw Type: application/pdf
    case slides = "Slides"
    case demoCode = "Demo Code"
    case readingAssignment = "Reading"
    case programmingProject = "Programming Project"

    static let all: [ResourceType] = [.video, .slides, .demoCode, .readingAssignment, .programmingProject]

    var description: String {
        switch self {
        case .slides, .demoCode:
            return rawValue
        default:
            return "\(rawValue)s"
        }
    }
}

struct Resource: CustomStringConvertible {
    let index: Int
    let title: String
    let type: ResourceType
    let url: String
    let summary: String?

    init(title: String, rawType: String, url: String, summary: String?) {
        self.url = url

        if rawType.contains("video") {
            type = .video
        } else if let resType = ResourceType.all.first(where: { title.contains($0.rawValue) }) {
            type = resType
        } else {
            fatalError("Unknown Raw Type \(rawType)")
        }

        var parts: [String]
        if type == .video {
            // 4. Views -> index: 4, title: Views
            parts = title.components(separatedBy: ". ")
        } else if type == .readingAssignment {
            // Reading 1: Intro to Swift -> index: 1, title: Intro to Swift
            parts = title.components(separatedBy: ": ")
            parts[0] = parts[0].components(separatedBy: " ")[1]
        } else if type == .programmingProject {
            // Programming Project 2: Calculator Brain -> index: 2, title: Calculator Brain
            parts = title.components(separatedBy: ": ")
            parts[0] = parts[0].components(separatedBy: " ")[2]
        } else {
            // Lecture 6 Slides -> index: 6, title: Lecture 6 Slides
            // Lecture 9 Demo Code: Smashtag -> index: 9, title: Lecture 9 Demo Code: Smashtag
            parts = [title.components(separatedBy: " ")[1], title]
        }
        self.index = Int(parts[0])!
        self.title = parts[1]

        self.summary = summary == title ? nil : summary?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var description: String {
        guard let summary = summary else { return "\(index). [\(title)](\(url))" }
        return "\(index). <details><summary><a href=\"\(url)\">\(title)</a></summary>\(summary)</details>"
    }
}

/* Example XML
 <entry>
 <author>
 <name>Paul Hegarty</name>
 </author>
 <title type="html">
 <![CDATA[ <#Title#> ]]>
 </title>
 <id>1/COETAIHAJLZIQXJI/MAEC2FBSEERRMTUH</id>
 <updated>2017-03-10T18:19:21PST</updated>
 <published>2017-03-10T17:36:29PST</published>
 <summary type="html">
 <![CDATA[ Lecture 9 Demo Code: Smashtag ]]>
 </summary>
 <link rel="enclosure" type="<#Raw Type#>" href="<#URL#>" length="63449"/>
 </entry>
 */
class ParsingDelegate: NSObject, XMLParserDelegate {
    var resources = [Resource]()

    var title: String?
    var isParsingTitle = false
    var type: String?
    var url: String?
    var summary: String?
    var isParsingSummary = false

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "title":
            isParsingTitle = true
        case "summary":
            isParsingSummary = true
        case "link":
            type = attributeDict["type"]
            url = attributeDict["href"]
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        if let cData = String(data: CDATABlock, encoding: .utf8) {
            if isParsingTitle {
                title = cData
            } else if isParsingSummary {
                summary = cData
            } else {
                debugPrint("Ignored CDATA[ \(CDATABlock) ]")
            }
        } else {
            fatalError("Unable to parse CDATA[ \(CDATABlock) ]")
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "title":
            isParsingTitle = false
        case "summary":
            isParsingSummary = false
        case "entry":
            resources.append(Resource(title: title!, rawType: type!, url: url!, summary: summary))
            title = nil
            isParsingTitle = false
            type = nil
            url = nil
            summary = nil
            isParsingSummary = false
        default:
            break
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        let sorted = ResourceType.all.map { [resources] type in
            resources.filter { $0.type == type } .sorted { $0.index < $1.index }
        }

        var out = "[返回主页](../README.md) / [Back to Main Page](../en/README.md)\n"
        for (index, type) in ResourceType.all.enumerated() {
            guard !sorted[index].isEmpty else {
                continue
                // fatalError("Missing Resources of Type \(type)")
            }
            out += "\n# \(type)\n\n"
                + "\(sorted[index].reduce("") { "\($0)\($1)\n" })"
        }

        let cwd = CommandLine.arguments.first { $0.contains(#file) } ?? FileManager.default.currentDirectoryPath
        let url = URL(fileURLWithPath: cwd).deletingLastPathComponent().appendingPathComponent("download.md")
        do {
            try out.write(to: url, atomically: true, encoding: .utf8)
            #if swift(>=4)
                let workspace = NSWorkspace.shared
            #else
                let workspace = NSWorkspace.shared()
            #endif
            workspace.activateFileViewerSelecting([url])
        } catch {
            print(out)
        }
    }
}

let url = URL(string: "https://itunesu.itunes.apple.com/WebObjects/LZDirectory.woa/ra/directory/courses/\(iTunesUCourseID)/feed")!
let parser = XMLParser(contentsOf: url)!
let delegate = ParsingDelegate()
parser.delegate = delegate
parser.parse()
