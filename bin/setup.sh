#!/usr/bin/env zsh
# Initial setup script for dotfiles repository

echo "🚀 Setting up development environment..."

# Navigate to repo root (parent of bin/)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Install Homebrew
echo "\n📦 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update -y

# Install oh-my-zsh
echo "\n🐚 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install packages from Brewfile
echo "\n📥 Installing packages from Brewfile..."
brew bundle --file=brew/Brewfile

# Copy dotfiles to home directory
echo "\n📄 Installing dotfiles..."
cp dotfiles/.* ~/ 2>/dev/null || true

# Install application configs
echo "\n⚙️  Installing application configs..."
if [[ -d "apps" ]]; then
    for app_dir in apps/*/; do
        [[ ! -d "$app_dir" ]] && continue

        app_name="${app_dir#apps/}"
        app_name="${app_name%/}"

        # Check if this app has a Preferences subdirectory (for plists)
        if [[ -d "$app_dir/Preferences" ]]; then
            # Copy .plist files to ~/Library/Preferences/
            echo "   - $app_name preferences"
            cp -r "$app_dir/Preferences/." ~/Library/Preferences/ 2>/dev/null || true
        else
            # Copy to ~/.config/
            echo "   - $app_name config"
            mkdir -p ~/.config
            cp -r "$app_dir" ~/.config/ 2>/dev/null || true
        fi
    done
fi

# Install Vim plugin manager
echo "\n🔌 Installing Vundle for Vim..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 2>/dev/null || true

# Setup git-secrets
echo "\n🔐 Configuring git-secrets..."
git secrets --register-aws --global

echo "\n✅ Setup complete! Restart your terminal to apply changes."
