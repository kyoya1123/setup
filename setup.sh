mv .zshrc ~
mv ssh .ssh
mv .ssh ~
chmod 0600 ~/.ssh/id_rsa

echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

echo "Install Latest Xcode"
xcodes install --latest
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

#dockのアニメーションのスピード
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock

mv Preferences/*.plist ~/Library/Preferences
mv Preferences/.GlobalPreferences.plist ~/Library/Preferences

rm -d -r ~/Library/Developer/Xcode/UserData
mv Preferences/UserData ~/Library/Developer/Xcode
