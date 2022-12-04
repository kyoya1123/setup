# zsh
mv .zshrc ~

# ssh
mv ssh .ssh
mv .ssh ~
chmod 0600 ~/.ssh/id_rsa

# brew
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew bundle
echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

# Install Xcode, change Command Line Tool
echo "Install Latest Xcode"
xcodes install --latest
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Animation Speed of Dock
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock

# System and apps preference
mv Preferences/*.plist ~/Library/Preferences
mv Preferences/.GlobalPreferences.plist ~/Library/Preferences

#Snippet, Color Theme, etc
rm -d -r ~/Library/Developer/Xcode/UserData
mv Preferences/UserData ~/Library/Developer/Xcode
