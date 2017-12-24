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
    case lecture = "Video"
    case friday = "Friday Session"
    // Raw Type: application/pdf
    case slides = "Slides"
    case demo = "Demo Code"
    case reading = "Reading"
    case project = "Programming Project"
    
    static let all: [ResourceType] = [.lecture, .friday, .slides, .demo, .reading, .project]
    
    var description: String {
        switch self {
        case .lecture: return "课程视频 / Lecture Videos"
        case .friday:  return "周五课程 / Friday Sessions"
        case .slides:  return "课程讲义 / Slides"
        case .demo:    return "示例代码 / Demo Code"
        case .reading: return "阅读作业 / Readings"
        case .project: return "编程作业 / Programming Projects"
        }
    }
}

struct Resource: CustomStringConvertible {
    let index: Int
    let title: String
    let type: ResourceType
    let url: String
    let summary: String?
    
    init?(title: String, rawType: String, url: String, summary: String?) {
        self.url = url
        
        if rawType.contains("video") {
            type = title.hasPrefix("Friday") ? .friday : .lecture
        } else if let resType = ResourceType.all.first(where: { title.contains($0.rawValue) }) {
            type = resType
        } else {
            fatalError("Unknown Raw Type \(rawType)")
        }
        
        var parts: [String]
        switch type {
        case .lecture:
            // 4. Views -> index: 4, title: Views
            parts = title.components(separatedBy: ". ")
        case .reading:
            // Reading 1: Intro to Swift -> index: 1, title: Intro to Swift
            parts = title.components(separatedBy: ": ")
            parts[0] = parts[0].components(separatedBy: " ")[1]
        case .project, .friday:
            // Programming Project 2: Calculator Brain -> index: 2, title: Calculator Brain
            // Friday Session 3: Instruments
            parts = title.components(separatedBy: ": ")
            parts[0] = parts[0].components(separatedBy: " ")[2]
        default:
            // Lecture 6 Slides -> index: 6, title: Lecture 6 Slides
            // Lecture 9 Demo Code: Smashtag -> index: 9, title: Lecture 9 Demo Code: Smashtag
            parts = [title.components(separatedBy: " ")[1], title]
        }
        guard parts.count > 1, let index = Int(parts[0]) else { return nil }
        self.index = index
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
    var totalSkipped = 0
    var total = 0
    
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
            total += 1
            if let res = Resource(title: title!, rawType: type!, url: url!, summary: summary) {
                resources.append(res)
            } else {
                totalSkipped += 1
                debugPrint("Skipped \(title ?? "Titleless")")
            }
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
        
        var out = "[返回主页](../../README.md) / [Back to Main Page](../../en/README.md)\n\n"
        for (index, type) in ResourceType.all.enumerated() {
            guard !sorted[index].isEmpty else {
                continue
                // fatalError("Missing Resources of Type \(type)")
            }
            out += "# \(type)\n\n"
                + "\(sorted[index].reduce("") { "\($0)\($1)\n" })\n"
        }
        
        out += "<details><summary>已收录 \(total-totalSkipped)/\(total) Entries</summary><script type=\"text/javascript\"> window.onload = function () { document.getElementsByClassName(\"project-name\")[0].innerHTML = \"下载列表 / Course Materials\"; } </script></details>\n"
        
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
            print("Written to \(url.path)")
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
