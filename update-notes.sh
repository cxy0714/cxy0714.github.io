# #!/bin/bash

# # === 参数 ===
# if [ -z "$1" ]; then
#   COMMIT_MSG="Update notes"
# else
#   COMMIT_MSG="$1"
# fi

# # === 路径 ===
# TYP_FILE="notes/main.typ"
# TINYMIST_HTML="notes/main.html"
# OUT_DIR="static/notes"
# OUT_FILE="${OUT_DIR}/index.html"

# # === Windows 下的 typst 路径（Git Bash 风格路径） ===
# TYPST_WIN_PATH="/c/Users/thinkbook-cxy/AppData/Local/Microsoft/WinGet/Packages/Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe/typst-x86_64-pc-windows-msvc/typst.exe"

# # === 检查 Typst ===
# if [ -f "$TYPST_WIN_PATH" ]; then
#     TYPST_CMD="$TYPST_WIN_PATH"
# elif command -v typst &> /dev/null; then
#     TYPST_CMD="typst"
# else
#     echo "❌ typst 未安装，请先安装 Typst CLI（需 >= 0.13 才有较完善的 HTML 实验特性）。"
#     exit 1
# fi

# mkdir -p "$OUT_DIR"

# echo "------------------------------------------------------"
# echo "📄 更新 Typst 笔记中..."
# echo "------------------------------------------------------"

# # === 使用 Tinymist 输出的 HTML（如果存在） ===
# if [ -f "$TINYMIST_HTML" ]; then
#     echo "✅ 检测到 VSCode Tinymist 导出的 HTML: $TINYMIST_HTML"
#     cp "$TINYMIST_HTML" "$OUT_FILE"
#     echo "✅ 已复制到: $OUT_FILE"

# # === 否则用 typst CLI 自动编译为 HTML（实验性，需要开启 features html） ===
# else
#     echo "ℹ️ 未发现 Tinymist HTML，尝试使用 typst CLI 编译为 HTML（实验性）..."

#     # 使用环境变量 + 命令行开关开启 HTML 导出
#     TYPST_FEATURES=html \
#     "$TYPST_CMD" compile "$TYP_FILE" --format html --features html "$OUT_FILE"
#     EXIT_CODE=$?

#     if [ $EXIT_CODE -ne 0 ]; then
#         echo "❌ Typst 编译为 HTML 失败（exit code: $EXIT_CODE）。"
#         echo "   - 请检查 Typst 版本是否支持 HTML 导出（需开启 html feature）"
#         echo "   - 或在 VSCode 用 Tinymist 手动导出 notes/main.html 后再运行本脚本。"
#         exit 1
#     fi

#     echo "✅ Typst CLI 编译完成: $OUT_FILE"
# fi

# # === Git 操作 ===
# echo "📦 执行 git add/commit/push"

# git add "$TYP_FILE" "$OUT_FILE"

# git commit -m "$COMMIT_MSG"
# if [ $? -ne 0 ]; then
#     echo "ℹ️ 没有变化，无需 push。"
#     exit 0
# fi

# git push
# if [ $? -eq 0 ]; then
#     echo "✅ Push 完成！GitHub Pages 将自动部署。"
# else
#     echo "❌ Push 失败，请检查网络或权限。"
# fi


#!/bin/bash

# === 参数 ===
if [ -z "$1" ]; then
  COMMIT_MSG="Update notes"
else
  COMMIT_MSG="$1"
fi

# === 路径 ===
TYP_FILE="notes/main.typ"
OUT_DIR="static/notes"
OUT_FILE="${OUT_DIR}/notes.pdf"

# === Windows 下 Typst 可执行文件 ===
TYPST_WIN_PATH="/c/Users/thinkbook-cxy/AppData/Local/Microsoft/WinGet/Packages/Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe/typst-x86_64-pc-windows-msvc/typst.exe"

# === 检查 Typst ===
if [ -f "$TYPST_WIN_PATH" ]; then
    TYPST_CMD="$TYPST_WIN_PATH"
elif command -v typst &> /dev/null; then
    TYPST_CMD="typst"
else
    echo "❌ typst 未安装，请先安装 Typst CLI。"
    exit 1
fi

mkdir -p "$OUT_DIR"

echo "------------------------------------------------------"
echo "📄 编译 Typst PDF 中..."
echo "------------------------------------------------------"

# === 编译 PDF ===
$TYPST_CMD compile "$TYP_FILE" "$OUT_FILE"
EXITCODE=$?

if [ $EXITCODE -ne 0 ]; then
    echo "❌ Typst PDF 编译失败 (exit $EXITCODE)"
    exit 1
fi

echo "✅ PDF 已输出到: $OUT_FILE"

# === Git 操作 ===
echo "📦 执行 git add/commit/push"

git add "$TYP_FILE" "$OUT_FILE"

git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "ℹ️ 没有变化，无需 push。"
    exit 0
fi

git push
if [ $? -eq 0 ]; then
    echo "✅ Push 完成！GitHub Pages 将自动部署。"
else
    echo "❌ Push 失败，请检查网络或权限。"
fi
