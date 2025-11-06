#!/bin/bash

# === 参数 ===
if [ -z "$1" ]; then
  COMMIT_MSG="Update notes"
else
  COMMIT_MSG="$1"
fi

# === 路径 ===
TYP_FILE="notes/main.typ"
TINYMIST_HTML="notes/main.html"
OUT_DIR="static/notes"
OUT_FILE="${OUT_DIR}/index.html"

# === Windows 下的 typst 路径 ===
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
echo "📄 更新 Typst 笔记中..."
echo "------------------------------------------------------"

# === 使用 Tinymist 输出的 HTML（如果存在） ===
if [ -f "$TINYMIST_HTML" ]; then
    echo "✅ 检测到 VSCode Tinymist 导出的 HTML: $TINYMIST_HTML"
    cp "$TINYMIST_HTML" "$OUT_FILE"
    echo "✅ 已复制到: $OUT_FILE"

# === 否则用 typst CLI 自动编译 ===
else
    echo "ℹ️ 未发现 Tinymist HTML，使用 typst CLI 编译..."
    
    # 方法1：先编译为 PDF，然后如果有工具可以转换为 HTML
    # "$TYPST_CMD" compile "$TYP_FILE" "${OUT_DIR}/notes.pdf"
    # echo "✅ 已编译为 PDF: ${OUT_DIR}/notes.pdf"
    
    # 方法2：创建一个简单的 HTML 占位符
    cat > "$OUT_FILE" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Notes</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .notice { background: #f0f0f0; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="notice">
        <h1>📝 Notes</h1>
        <p>Typst 文档需要手动编译或使用 Tinymist 导出 HTML。</p>
        <p>当前时间: <span id="datetime"></span></p>
        <p>源文件: <code>notes/main.typ</code></p>
    </div>
    <script>
        document.getElementById('datetime').textContent = new Date().toLocaleString();
    </script>
</body>
</html>
EOF
    echo "✅ 已创建 HTML 占位符: $OUT_FILE"
fi

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