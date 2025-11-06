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
