# How to Use
- GitHubにアクセスできるSSH鍵（または同等の認証手段）を事前に用意
- terminal.appにフルディスクアクセスを許可（Preferencesのimportで必要）
- `$ chmod +x setup.sh`
- `$ ./setup.sh`

## 注意
- `setup.sh` は既存のdotfiles（`~/.zshrc` など）を**上書き**します（バックアップは取りません）
- Xcode UserData同期は `origin/main` に強制同期します（ローカル変更は破棄）
- Homebrew（特に一部cask）のインストールで管理者権限が必要なため、実行中に `sudo` パスワードを求められることがあります（原則1回）


# How to Update
- `brew bundle dump`
- `npm list -g`
- Preferences更新: `scripts/export-preferences.sh`
- Xcode Userdataをcommit & push
