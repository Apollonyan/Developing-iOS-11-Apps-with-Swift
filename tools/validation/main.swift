//
//  Created by Apollo Zhu on 11/29/17.
//  This work is licensed under a
//  Creative Commons Attribution-NonCommercial-ShareAlike 3.0 United States License.
//

import Foundation

guard let file = CommandLine.arguments.first(where: { $0.hasSuffix(".srt") }) else { fatalError("参数未指定 srt 字幕文件") }
guard let contents = try? String(contentsOfFile: file) else { fatalError("无法读取 \(file)") }
var lines = contents.components(separatedBy: "\n")
for i in lines.indices {
    let line = lines[i]
    if line.utf8.count > 100 { print("第 \(i + 1) 行过长: \(line)") }
    lines[i] = line.trimmingCharacters(in: CharacterSet(charactersIn: "，。").union(.whitespacesAndNewlines))
}
try! lines.joined(separator: "\n").write(toFile: file, atomically: true, encoding: .utf8)
print("已保存至 \(file)")
