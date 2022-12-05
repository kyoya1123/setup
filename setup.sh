# zsh
mv .zshrc ~

# ssh
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

# System and apps preference
defaults import .GlobalPreferences Preferences/.GlobalPreferences.plist

dir_path="Preferences/*"
for dir in $dir_path;
do
    file_name=$(basename $dir)
    eval "defaults import ${file_name//.plist/} $dir"
done

#Snippet, Color Theme, etc
rm -d -r ~/Library/Developer/Xcode/UserData
mv UserData ~/Library/Developer/Xcode
