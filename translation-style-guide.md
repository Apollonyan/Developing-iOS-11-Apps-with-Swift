# 翻译标准／校对规则

## 基本要求

1. 请大家翻译和校对的时候尽量对照原视频，结合上下文，不要望文生义
2. 如保持英文顺序会影响中文理解，为保证行文流畅，应采用理解优先原则，优先按中文断句
3. 当说话的人变更时，请加 `>>` 来区分。如：Question? >> Is it？ >> Yes.
4. 出现 Okay，All Right，Now 等语气词，请结合上下文选择合适的翻译，或省略不翻
5. 学生提问的部分如果听不清楚，字幕也不全（[INAUDIBLE]），但是老师回答时候把问题复述了一遍，字幕可译为 `>> [学生提问]`
6. 出现 [COUGH]，[LAUGH]，[NOISE]，[BLANK_AUDIO]，[INAUDIBLE] 等，请自行把握，可结合上下文选择省略不翻译
7. 卖萌请不要使用字符表情，比如（*3）看起来就像是备注；如果是标注说了三遍，请使用 x3 标记

## 格式要求

1. 不要合并多条**字幕**，两条字幕之间保持一个空行
2. 中英文字幕**开头结尾**均不留空格，以 Unix 样式的 LF (Line Feed 的缩写，即 \n) 换行
3. 省略字幕**开头结尾**不影响表意的标点。如保留问号，但省略如逗号、句号等
4. 除了 `[`，`]`，和 `>>` 以外使用全角中文标点，如果可能，使用中文数字
5. 保证每一条字幕中最多两行，一行英文一行翻译，翻译不会过长
6. 英文和阿拉伯数字同中文之间应当有一个空格
7. 如遇到英文词汇或阿拉伯数字和标点符号相邻的情况，则不需要再留空格

例：就算是最新的 iPad，也不能用 Swift Playgrounds 打包应用。

## 错误修正

1. 修改错别字，明显的笔误，大小写错误（包括原英文字幕中的错误）
2. 如能找到对应的 Swift Evolution 编号，以类似（在 SE-0065 之前）… 注明
3. 如能确定特定的 Swift 语言版本，以类似（在 Swift 4 之前）… 或（对于 Swift 3）… 注明
4. 如果完全错误，尝试以类似 …（误：原因）或（注：补充）说明。如空间不够，可适当调整上下文。参考第三课 1303 和 420

## 翻译术语（Terminology）的要求

#### 术语的基本处理：

1. 尽量和已翻译的内容保持一致
2. 参考 [术语的特殊处理](#术语的特殊处理)
3. 参考 [Apple Developer 网页中文版](https://developer.apple.com/cn/)
4. 参考历年 [iOS 8](https://github.com/X140Yu/Developing_iOS_8_Apps_With_Swift) 和 [iOS 9](https://github.com/SwiftGGTeam/Developing-iOS-9-Apps-with-Swift) 的翻译
5. 参考 [《The Swift Programming Language》中文版](http://gg.swiftguide.cn/) 及其 [术语表](https://github.com/numbbbbb/the-swift-programming-language-in-chinese/issues/62)
6. 参考该术语在其它编程语言中的翻译，可以使用 [微软官方术语搜索](https://www.microsoft.com/Language/zh-cn/Search.aspx) 等搜索引擎
7. 如果以上都没有找到合适的结果，你可以
	1. 在得到任务分配的 issue 下讨论
	2. 直接使用英文原文
	3. 自己决定一个合适的翻译

#### 术语的特殊处理

1. 如果想在同时翻译并保留原文，请根据情况从以下的格式中选用一种
	1. 用逗号隔开。例：这是 Navigator，导航面板
	2. 用括号补充。例：MVC，即 Model（模型）-View（视图）-Controller（控制器）
2. 不翻译通用的名称，如 MVC，iPhone，Xcode，Storyboard 等
3. 不翻译直接引用的代码，包括但不限于
	- Swift 语言关键字：如 true，false 等
	- 类／结构体／元组类型的名称：如 UIView，String 等
	- 项目中的代码：如 var description 等

**后期校对请参考以上标准对术语的使用进行统一**

## 补充说明

> 为何没有完全采用之前的[校对规范](https://github.com/X140Yu/Developing_iOS_8_Apps_With_Swift/blob/master/proofread-rules.md)？

其一是因为确实有些因为 Swift 的更新需要修改的地方。其二是因为即使就像之前规则中说的，*“校对是一个很重要的部分，甚至比翻译还要重要”*，但是如果我们从翻译阶段就能做到统一规范，相信校对也能事半功倍。当然，既然这是新的规范，没经过实践验证，欢迎大家根据实际情况讨论后提出修订意见。
