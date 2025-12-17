# Preferences（macOS設定）について

このディレクトリは「`defaults` で反映できる範囲の設定」を、Git管理しやすい形（XML plist）で保存します。

## 反映（新しいMac側）

`setup.sh` が `defaults import` で取り込み、最後に `Dock/Finder/SystemUIServer` を再起動して反映します。

## 取得/更新（今のMac側）

基本方針は「`~/Library/Preferences` の該当ドメインを `defaults export` で書き出す」です。

- 推奨: `scripts/export-preferences.sh` を実行して `Preferences/*.plist` を更新
- その後、差分を確認してcommit

## 注意点（ここがハマりどころ）

- **すべての設定が `defaults` で取れるわけではありません**
  - 例: 一部のシステム設定、ログイン項目、Touch ID、Apple ID、セキュリティ/プライバシー系など
- **端末固有（ByHost）**の設定があります
  - 例: `~/Library/Preferences/ByHost/` 配下（ホストUUIDが付くplist）
  - 端末を跨いでの再現性が低いので、無理に混ぜない方が安全です
- **アプリ固有の設定**は `~/Library/Application Support/` / `~/Library/Containers/` / `~/Library/Group Containers/` / `~/.config/` などに散らばります
  - Raycast, VS Code, iTerm2 などは「アプリ内のExport機能」や専用フォルダのバックアップの方が確実です

