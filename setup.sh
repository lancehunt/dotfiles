#! /usr/bin/env zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update -y

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd brew
brew bundle

cp dotfiles/.* ~/.
cp -r wezterm ~/.config/.
cp -r starship ~/.config/.
cp -r joplin-desktop ~/.config/.

cp iterm2/Preferences/. ~/Library/Preferences/.
cp rectangle/Preferences/. ~/Library/Preferences/.


