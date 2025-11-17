#!/bin/bash

# === 参数 ===
if [ -z "$1" ]; then
  COMMIT_MSG="Update notes"
else
  COMMIT_MSG="$1"
fi

# === 路径 ===
TYP_FILE="notes/main.typ"
BIB_FILE="notes/Master.bib"  # 新增 Bib 文件路径
OUT_DIR="static/notes"
OUT_FILE="${OUT_DIR}/notes.pdf"


# === Windows 下 Typst 可执行文件（更稳健版本）===
TYPST_WIN_PATH="$(cygpath "${APPDATA}/../Local/Microsoft/WinGet/Packages/Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe/typst-x86_64-pc-windows-msvc/typst.exe")"


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

# === 避免 10 分钟内重复 push ===
TIMESTAMP_FILE=".last_push_time"

if [ -f "$TIMESTAMP_FILE" ]; then
    LAST_PUSH=$(cat "$TIMESTAMP_FILE")
else
    LAST_PUSH=0
fi

NOW=$(date +%s)
DIFF=$(( NOW - LAST_PUSH ))

if [ $DIFF -lt 600 ]; then
    echo "⏳ 上次 push 距离现在仅 $DIFF 秒 (<600 秒)，跳过 push。"
    git add "$TYP_FILE" "$BIB_FILE" "$OUT_FILE" "notes/media"  # 添加 Bib 文件和 notes/media
    git commit -m "$COMMIT_MSG" >/dev/null 2>&1
    exit 0
fi


# === Git 操作 ===
echo "📦 执行 git add/commit/push"

# 添加所有相关文件，包括 Bib 文件
git add "$TYP_FILE" "$BIB_FILE" "$OUT_FILE" "notes/media"

git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "ℹ️ 没有变化，无需 push。"
    exit 0
fi

git push
if [ $? -eq 0 ]; then
    echo "$NOW" > "$TIMESTAMP_FILE"
    echo "✅ Push 完成！GitHub Pages 将自动部署。"
else
    echo "❌ Push 失败，请检查网络或权限。"
fi