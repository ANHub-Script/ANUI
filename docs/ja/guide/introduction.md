# はじめに

ANUI（Advanced Roblox UI Library）は、Roblox のスクリプトエグゼキュータ向けのモダンで多機能な UI ライブラリです。ウィンドウ、タブ、トグル、スライダー、ドロップダウンなどを備えた洗練されたモバイル対応メニューを、わずか数行の Lua で構築できます。

## ANUI とは？

ANUI は、あらゆる Roblox 体験の上にフローティングのウィンドウを描画します。ウィンドウはドラッグでき、サイズも変更できます。メニューは宣言的に記述するだけ —— ウィンドウを作り、タブを追加し、そこにエレメントを置く —— レイアウト、テーマ、入力、アニメーション、永続化は ANUI が面倒を見ます。

`loadstring` 1 行で HTTP 経由で読み込まれるため、インストールもバンドルも不要です。1 行貼り付ければ、メニューがすぐ動きます。

## 何が作れるか

- タブとサイドバーのセクションで整理された機能 Hub やチートメニュー
- [設定と Flag](/ja/features/config-and-flags) でセッションをまたいで状態が残る設定パネル
- 組み込みの[キーシステム](/ja/features/key-system)を使ったキー認証付きスクリプト
- プロフィール、バッジ、通知、ダイアログを備えたリッチなダッシュボード

## 主な機能

- 15 以上の[エレメント](/ja/elements/) —— button、toggle、slider、dropdown、colorpicker、keybind、input、コードブロックなど
- [26 種の組み込みテーマ](/ja/features/themes)と、独自のカスタムパレット
- 任意のエレメントの状態をディスクに保存する[設定と Flag](/ja/features/config-and-flags)
- Luarmor、Platoboost、PandaDevelopment プロバイダーに対応した[キーシステム](/ja/features/key-system)
- [通知](/ja/features/notifications)と[ダイアログとポップアップ](/ja/features/dialogs-and-popups)
- 多言語メニュー向けの[ローカライズ](/ja/features/localization)
- 管理されたループのためのドリフトのない[スケジューラー](/ja/features/scheduler)
- [モバイル対応のスケーリングとアクリルブラー](/ja/guide/window-configuration)

## 動作要件

ANUI は Roblox のスクリプトエグゼキュータ内で動作します。エグゼキュータは次に対応している必要があります。

- `loadstring` と `game:HttpGet` —— ライブラリの読み込みに必須
- `readfile`、`writefile`、`isfile`、`makefolder` —— 設定やキーの保存にのみ必要

::: info ウィンドウは 1 つだけ
同時に存在できるウィンドウは 1 つだけです。`ANUI:CreateWindow` を 2 回目に呼ぶと警告が出て `nil` が返ります。
:::

## クレジット

- **Footagesus 制作の WindUI** をベースにしています
- アイコンは [Lucide](https://lucide.dev)
- Dawid-Scripts に感謝します

## リンク

- GitHub: [github.com/ANHub-Script/ANUI](https://github.com/ANHub-Script/ANUI)
- Discord: [discord.gg/bUkCZvmrpH](https://discord.gg/qN47S3mKZA)
- YouTube: [@ANHubRoblox](https://www.youtube.com/@ANHubRoblox)

---

次へ: [インストール](/ja/guide/installation)
