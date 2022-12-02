mv .zsh_profile ~
mv ssh .ssh
mv .ssh ~

echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

touch ~/.zprofile
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

echo "Install Latest Xcode"
xcodes install --latest

#dockのアニメーションのスピード
defaults write com.apple.dock "autohide-time-modifier" -float "0" && killall Dock
