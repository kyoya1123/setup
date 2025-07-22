# Dotfiles
mv Dotfiles/.[^\.]* ~

# ssh
chmod 0600 ~/.ssh/id_rsa

# brew
echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

source ~/.zshrc

# brew bundle
echo "Install Homebrew Packages"
brew tap homebrew/bundle
brew bundle

source ~/.zshrc

echo "Install npm packages"
npm install -g @anthropic-ai/claude-code @aws-amplify/cli @google/gemini-cli @luminati-io/luminati-proxy apollo corepack eas-cli firebase-tools graphql npm textlint yarn

# System and apps preference
defaults import .GlobalPreferences Preferences/.GlobalPreferences.plist

dir_path="Preferences/*"
for dir in $dir_path;
do
    file_name=$(basename $dir)
    eval "defaults import ${file_name//.plist/} $dir"
done

#Snippet, Color Theme, etc
cd ~/Library/Developer/Xcode/UserData
git init
git remote add origin git@github.com:kyoya1123/XcodeUserData.git
git pull origin main
