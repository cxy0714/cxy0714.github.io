# 安装
安装Tpyst CLI实现本地编译pdf

winget install --id Typst.Typst

默认路径保存即可（加环境变量path没用，还是报错，不知何故）

# 待实现
自动追踪 main.typ，自动保存后（10分钟一次）就渲染pdf上传至github

# 目前手动上传脚本

update-notes.sh

本地编译notes/main.typ的pdf搬运至static，并提交bib，typ，pdf的修改至github，触发github部署服务器设置（static->public）

./update-notes.sh