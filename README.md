# G & A — ふたりの記録

`Desktop/個人作成/M/` のサイトをリデザインした静的サイト（参照専用）。
上品なミンチョ体 × アイボリー & ゴールドの記念日サイトデザイン。

## ページ構成

```
m-cla/
├── index.html           # トップ（ヒーロー + 年別ギャラリー）
├── letter.html          # レターページ（彩乃へ）※ゲスト用サイトには含めない
├── memory/              # 年別思い出ページ（結婚前 2017-18〜2026）+ 写真
├── days.html            # Days 一覧（結婚後）
├── days/                # 年別 Days ページ + 写真
├── baseball.html        # 観戦記録
├── map.html             # 訪問都道府県マップ
├── build-guest.sh       # ゲスト用サイト（m-guest）を生成するスクリプト
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

## ゲスト用サイト（m-guest）

結婚式にお越しいただく方には、**レターを外した版**を別サイトで公開しています。

| | URL | Letter |
|---|---|---|
| 本体（ふたり用） | https://gen1219.github.io/m-cla/ | あり |
| ゲスト用 | https://gen1219.github.io/m-guest/ | なし |

ゲスト用サイトは本体から自動生成します。本体を更新したら次を実行してください。

```bash
./build-guest.sh                                   # ../m-guest/ を作り直す
cd ../m-guest && git add -A && git commit -m "更新" && git push
```

`../m-guest/` の中身はスクリプトが毎回作り直すので、直接編集しないでください
（`.git` と `.github` は残ります）。

## Photo ページ

ナビの「Photo」は結婚式の写真アップロードページ（Cloudflare Workers）への外部リンクです。

- https://wedding-photos.gensen4631.workers.dev
- リポジトリ: https://github.com/GeN1219/wedding-photos
- URL を変える場合は、全 HTML の `wedding-photos.gensen4631.workers.dev` を置換してから
  `./build-guest.sh` を実行

## 席次表の QR コード

**QR コードはゲスト用サイトの URL にしてください。**

```
https://gen1219.github.io/m-guest/
```

式後の「ありがとうサイト」も同じ URL に切り替わるので、印刷した QR はそのまま使えます。
本体（m-cla）の URL はレターを含むので、ゲストには配らないでください。

## 式後の「ありがとうサイト」への切り替え

**ありがとうサイトは m-guest リポジトリの `thanks` ブランチにあります**（m-cla ではありません）。

```bash
# 式後：ゲスト用サイト → ありがとうサイト
gh workflow run deploy.yml --repo GeN1219/m-guest --ref thanks

# ゲスト用サイトに戻す
gh workflow run deploy.yml --repo GeN1219/m-guest --ref main
```

反映は十数秒。切り替え後、`memory/` など元のページの URL には 404.html が
「公開を終了しました」と案内し、Thank You ページへ誘導します。

結婚式の写真は `thanks` ブランチの index.html 末尾にある CONFIG
（heroPhoto / photos / shareUrl）に追加してから、そのブランチを push してください
（push するだけで公開も切り替わります）。詳しくは m-guest の thanks ブランチの README。

> m-cla にも古い `thanks` ブランチが残っていますが、**こちらはもう使いません**。
> 公開するのは m-guest 側です。
