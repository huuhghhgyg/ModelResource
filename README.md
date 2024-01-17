# ModelResource
![GitHub last commit](https://img.shields.io/github/last-commit/huuhghhgyg/ModelResource) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/huuhghhgyg/ModelResource/static.yml) ![GitHub contributors](https://img.shields.io/github/contributors/huuhghhgyg/ModelResource)

建模资源库，适用于MicroCity Web的模型和脚本导入。
- 可用模型列表请查看 [\models](./models)
- 可用脚本列表请查看 [\libs](./libs)

## 首次上传模型步骤指引
上传模型到本Repository(代码仓库)应当遵循如下步骤：

**第一步：Fork本仓库。** 页面右上角有一个 `Fork` 按钮。Fork的含义是将本仓库复制一份存到你的账户中，以便进行修改。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/fork.png)

Fork完毕后在你的Repository中应该能找到Fork后得到的仓库，大致如下图所示。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/forked_repository.png)

**第二步：上传模型文件。** 找到并进入你的账户中Fork得到的仓库，进入`models/`文件夹。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/upload_files.png)

右上角有 `Add file` 按钮，点击 `Upload files` 转到上传文件的页面。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/commit_changes.png)

将要上传的文件拖入或者通过 `choose your files` 链接选择文件进行上传。选择文件后注意观察上传进度条。文件上传完毕后在文本框中填写上传的模型文件的具体信息，然后点击 `Commit Changes` 按钮上传更改。

Commit信息表单中第一个文本框为标题，通常填写新增了什么模型；第二个文本框为描述，你可以自由决定是否填写。

> ⚠请认真填写Commit信息，如模型内容。否则仓库维护者将难以弄清修改意图，后续的Pull Request可能被拒绝。

至此，你已经成功将模型上传，并将其放置在你所Fork的仓库中的 `models/` 文件夹下。但是，你需要将你的更改同步到源仓库中才能使之生效。

**第三步：创建Pull Request请求。** Pull Request的含义是向主仓库申请代码合并。所以，需要合并的内容就是刚才新上传的模型文件。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/sync_and_contribute.png)

在你的仓库文件列表顶部应该可以看到这些按钮。现在，我们暂时只看右侧的`Contribute`部分。点击Contribute后可以创建Pull Request(代码合并请求)。

如果您只做了一个更改，方便起见Pull Request中的标题和描述可以仿照Commit填写，否则建议总结做出的更改。

提交Pull Request后，只需要等待仓库管理者对你的Pull Request进行审核。只要有动态（无论是Pull Request被同意或拒绝），Github将会发邮件进行通知。

## 后续上传模型指引
此部分只适用于已经成功进行过模型上传的情况。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/sync_and_contribute.png)

再次上传模型之前，先点击右侧的`Sync fork`按钮检查你的Fork仓库是否已经同步了主仓库的最新更改。

![](https://huuhghhgyg.github.io/ModelResource/doc/images/synced.png)

如果已经同步了最新更改将会是上图显示的情况，否则，建议进行同步，以防出现代码合并冲突的情况。

同步后上传模型的步骤同 [首次上传模型步骤指引](#首次上传模型步骤指引) 的第二步和第三步，进行模型上传和Pull Request。

## 使用模型
示例
```
https://huuhghhgyg.github.io/ModelResource/models/2axle.glb
```