
# 目前方案

本地编译notes/main.typ的pdf搬运至static，并提交bib，typ，pdf的修改至github，触发github部署服务器设置（static->public）

## 安装
安装Tpyst CLI实现本地编译pdf

winget install --id Typst.Typst

默认路径保存即可（加环境变量path没用，还是报错，不知何故）

## 待实现

自动追踪 main.typ，自动保存后（10分钟一次）就渲染pdf上传至github

## 目前手动上传脚本

./update-notes.sh

## 文件存储问题

每天上传一次平均3MB PDF,333天后就会触顶1GB服务器上限，git变得臃肿，git应该只追踪文本文件typ，现行方案每次上传pdf都会保存副本，占用空间。

Git LFS 将PDF和typ分开，LFS专门存储PDF

# 最优方案

还是应该渲染为html，存储问题就可以一举告破，但是现在渲染html失败。而且目前typst对html的支持尚不够强大https://typst.app/docs/reference/html/

[(GPT 记录)](https://chatgpt.com/share/691578fa-05a0-8006-a32c-b99c6dc476c7)


似乎和现在用的typst模板没有对html的设置有关系。

## typst模板


期望模板：数学友好，定义定理环境ok，引用格式 作者年份 等可自定义

当前模板 clean-math-paper:0.2.4，
定义定理（标题）未实现，引用格式 作者年份未实现。

## 为什么不用RMarkdown/Quarto

Typst数学支持更友好。

## 仓库大小

git count-objects -vH 
查看占用空间