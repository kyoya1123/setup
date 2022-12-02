mv .zsh_profile ~
mv ssh .ssh
mv .ssh ~
mv .zprofile ~

echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

echo "Install Latest Xcode"
xcodes install --latest

#dockのアニメーションのスピード
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock
