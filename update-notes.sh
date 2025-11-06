#!/bin/bash

# === 参数 ===
if [ -z "$1" ]; then
  COMMIT_MSG="Update notes"
else
  COMMIT_MSG="$1"
fi

# === 切换到脚本所在目录（避免 VSCode 工作目录不同）===
cd "$(dirname "$0")"

# === 路径 ===
TYP_FILE="notes/main.typ"
OUT_DIR="static/notes"
OUT_PDF="${OUT_DIR}/notes.pdf"

mkdir -p "$OUT_DIR"

# === Typst 编译（PDF） ===
echo "📄 编译 Typst PDF..."
typst compile "$TYP_FILE" "$OUT_PDF"

if [ $? -ne 0 ]; then
    echo "❌ Typst 编译失败"
    exit 1
fi

# === 记录 push 时间 ===
PUSH_LOG=".last_push_time"

# === 获取当前时间（秒）===
NOW=$(date +%s)

# === 获取上次 push 时间 ===
if [ -f "$PUSH_LOG" ]; then
    LAST_PUSH=$(cat "$PUSH_LOG")
else
    LAST_PUSH=0
fi

# 冷却时间：600 秒 = 10 分钟
COOL_DOWN=600

# === Git: add & commit ===
git add "$TYP_FILE" "$OUT_PDF"

git commit -m "$COMMIT_MSG"
if [ $? -ne 0 ]; then
    echo "ℹ️ 没变化，不需要 commit/push。"
    exit 0
fi

# === 判断是否需要 push ===
SINCE_PUSH=$(( NOW - LAST_PUSH ))

if [ "$SINCE_PUSH" -lt "$COOL_DOWN" ]; then
    echo "⏳ 最近 $((SINCE_PUSH/60)) 分钟内 push 过（冷却时间 10 分钟）"
    echo "✅ 本地 commit 完成，但暂时不 push。"
    exit 0
fi

# === Push ===
echo "🚀 正在 push 到 GitHub..."
git push

if [ $? -eq 0 ]; then
    echo "$NOW" > "$PUSH_LOG"
    echo "✅ Push 完成！并更新 push 时间记录。"
else
    echo "❌ Push 失败，请检查网络或权限。"
fi
