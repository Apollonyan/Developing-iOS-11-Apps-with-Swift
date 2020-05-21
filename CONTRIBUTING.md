# 任务相关说明

> Swifters of China, unite!

欢迎加入翻译的队伍！去年和前年的现在还没有翻译完，为了避免这样的情况再次发生，希望能有更多的小伙伴们加入。

总之大家先 Watch + Star 这个 repository，有兴趣也可以加 QQ 群 277542197。

## 领取任务

1. 每节新内容发布以后，[issue 区](https://github.com/Apollonyan/Developing-iOS-11-Apps-with-Swift/issues) 会开一个当节的「任务分配」issue。
2. ***请确认不和他人重复之后*** ，到每节的 issue 中评论「翻译」或「校对」。评论的内容包括：
    1. 段数。建议选择 issue 下第一条里公布的，一般会是 300 或 500 段，也可以自定义。
    2. 预计完成时间。我个人的翻译速度是每小时 50 段，请结合个人情况进行估计，建议控制在一个星期以内。海外党请用本地时，并注明时区。

**翻译、校对任务的段数不是指字幕文件中行数，而是指**

    67 <----此处的数字
    00:03:04,860 --> 00:03:06,960
    we talked about the NSNumber format and all that.

## 进行翻译

1. 请认真阅读并遵守 [翻译标准／校对规则](./translation-style-guide.md)。
2. 为了避免其他人也翻译同样的内容，请只翻译分配的段数。如果您不小心翻译了其他部分，请立刻告诉我，避免重复劳动。
3. 如果忙碌或者有困难一定要及时提出来，我也可以把任务转给其他人。这并不会对您有任何影响，觉得难为情可以邮件/私信我。
4. Fork 本项目到您的账户下，然后 Clone 保存到本地。
5. 如果已经 fork 过了，请通过 sync/update from master/fetch origin 等方式完成同步。
6. 翻译过程中请不要 update from master。
7. 翻译 **subtitles** 文件夹下对应 srt 文件的对应段，在英文行下面添加中文翻译。
    - srt 就是普通的文本文件，所以使用的程序只要能够保证保存为同样格式就行，个人偏好是 Visual Studio Code，也可以直接在 GitHub 上编辑。
    - 千万 **不要** 翻译 en/subtitles 文件夹里的，那些是保留原版字幕以备后用。区别方法如下：
        - 要翻译的文件所有的英文都只有一行；
        - 要翻译的文件至少第一句和最后一句都已经翻译过了。
8. 建议每完成一部分就 **commit** 一次，这样我们能对进度有个大概的把握。
9. 翻译或校对的过程中有拿不准的地方，请先尝试按照标准里提到的方法解决，也可以进入该节的 issue 中讨论（如这个词该不该翻译，该翻译成什么等）。

## 提交翻译

1. **全部** 翻译完之后提交 pull request，你会看到它出现在 [这里](https://github.com/Apollonyan/Developing-iOS-11-Apps-with-Swift/pulls)，具体步骤可以参考 [教程](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)。
2. 如果有，请在提交信息中注明我们需要特别注意的地方，和其他任务行之外的改动。
3. 为了加快进度，我们会采用每一集整体校对的形式，所以我们基本会马上 merge 你的 pull request。
4. 如果翻译格式不正确，或是有严重问题等，我们会在 pull request 的 comment 里提出，请修改并 commit。（不需要关闭 pull request，所有的 commit 会自动加入 pull request 里）
5. 在看到主项目出现一个标题为 `集数_开始段-结束段 翻译 @你` 的 commit 之后就算完成了。如果有需要，这个时候就可以安全地删除 fork 和本地文件了。

----

本规则基于 [github.com/SwiftGGTeam/Developing-iOS-9-Apps-with-Swift/issues/3](https://github.com/SwiftGGTeam/Developing-iOS-9-Apps-with-Swift/issues/3) 修订而成。
