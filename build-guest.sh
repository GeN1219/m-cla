#!/usr/bin/env bash
# ----------------------------------------------------------
# ゲスト用サイト（m-guest）をこのサイトから生成する
#
#   ./build-guest.sh
#
# ・このリポジトリの内容を ../m-guest/ にコピー
# ・letter.html（妻へのレター）とナビのレターリンクを取り除く
# ・../m-guest/.git と .github（公開設定）はそのまま残す
#
# 生成後に反映するには:
#   cd ../m-guest && git add -A && git commit -m "更新" && git push
# ----------------------------------------------------------
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${1:-$(cd "$SRC/.." && pwd)/m-guest}"

mkdir -p "$DEST"

echo "▸ コピー中: $SRC → $DEST"
rsync -a --delete \
    --exclude '.git/' \
    --exclude '.github/' \
    --exclude '.claude/' \
    --exclude '.gitignore' \
    --exclude '.DS_Store' \
    --exclude '_inbox/' \
    --exclude 'README.md' \
    --exclude 'build-guest.sh' \
    --exclude 'letter.html' \
    --exclude 'invite.html' \
    --exclude '_hagaki.html' \
    "$SRC/" "$DEST/"

echo "▸ レターへのリンクを除去中"
# ナビ（PC・ドロワー）と Service Worker のキャッシュ一覧から letter.html の行を削除
find "$DEST" -name '*.html' -type f -print0 | xargs -0 perl -i -ne 'print unless m{letter\.html}'
perl -i -ne 'print unless m{letter\.html}' "$DEST/sw.js"

# 念のため、letter.html が残っていないか確認（README はこのあと書き出すので対象外）
if grep -rqs 'letter\.html' "$DEST" --exclude-dir=.git --exclude-dir=.github --exclude='README.md'; then
    echo "✗ letter.html への参照が残っています" >&2
    grep -rns 'letter\.html' "$DEST" --exclude-dir=.git --exclude-dir=.github --exclude='README.md' >&2
    exit 1
fi
if [ -e "$DEST/letter.html" ]; then
    echo "✗ letter.html がコピーされています" >&2
    exit 1
fi

cat > "$DEST/README.md" <<'MD'
# G & A — ゲスト用サイト

結婚式にお越しいただく方にご覧いただくサイトです。
公開先: https://gen1219.github.io/m-guest/

## ⚠ このリポジトリは直接編集しません

本体サイト [`m-cla`](https://github.com/GeN1219/m-cla) から自動生成しています。
本体を更新したあと、m-cla で次を実行すると、このリポジトリの中身が作り直されます。

```bash
./build-guest.sh
cd ../m-guest && git add -A && git commit -m "更新" && git push
```

本体との違いは **letter.html（妻へのレター）を含まない** ことだけです。
MD

echo "✓ 完了: $DEST"
echo "  ページ数: $(find "$DEST" -name '*.html' | wc -l | tr -d ' ')"
