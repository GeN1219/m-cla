# G & A — ふたりの記録

`Desktop/個人作成/M/` のサイトをリデザインした静的サイト（参照専用）。
上品なミンチョ体 × アイボリー & ゴールドの記念日サイトデザイン。

## ページ構成

```
m-cla/
├── index.html           # トップ（ヒーロー + 年別ギャラリー）
├── letter.html          # レターページ（彩乃へ）
├── memory/              # 年別思い出ページ（2017-18〜2025）+ 写真
├── pic/                 # トップページ用写真
├── assets/
│   ├── css/style.css    # 共通デザインシステム
│   └── js/site.js       # 共通JS（ナビ/日数カウンター/ライトボックス等）
├── manifest.json        # PWAマニフェスト
├── sw.js                # Service Worker（Network First / 相対パス対応）
├── offline.html         # オフラインフォールバック
└── icon-192.svg / icon-512.svg  # PWAアイコン（G&Aモノグラム）
```

## 主な機能

- **日数カウンター** — 2017.11.15 からの経過日数を全ページのヘッダー/フッターに自動表示
- **年別ギャラリー** — トップから各年の思い出タイムラインへ。前後の年ナビ付き
- **ライトボックス** — 思い出ページの写真をタップで拡大。矢印キーで前後移動
- **スクロール演出** — セクションがふわっと浮かび上がる（reduced-motion 対応）
- **PWA** — ホーム画面追加・オフラインキャッシュ対応

## ローカル確認

```bash
cd m-cla
python3 -m http.server 8000
# → http://localhost:8000
```

## デプロイ

GitHub Pages で配信。
Service Worker は相対パスでキャッシュするため、サブパス配信（`https://<user>.github.io/<repo>/`）でも動作します。

## 式後の「ありがとうサイト」への切り替え

`thanks` ブランチに式後公開用のサイト（Thank You ページ）が用意してあります。
URL は変わらないため、席次表などに印刷した QR コードはそのまま使えます。

```bash
# 現行サイト → ありがとうサイト に切り替え（反映まで1〜2分）
gh api -X PUT repos/GeN1219/m-cla/pages -f "source[branch]=thanks" -f "source[path]=/"

# 元に戻す場合
gh api -X PUT repos/GeN1219/m-cla/pages -f "source[branch]=main" -f "source[path]=/"
```

GitHub の画面から行う場合は Settings → Pages → Branch を `thanks` に変更。

切り替え後、旧サイトの下層URL（memory/ など）へのアクセスには
404.html が「公開を終了しました」の案内を表示します。
結婚式の写真は `thanks` ブランチの index.html 冒頭にある CONFIG
（heroPhoto / photos / shareUrl）に追加すると反映されます。
