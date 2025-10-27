#!/usr/bin/env zsh
# Sync dotfiles and Brewfile to repository
#
# This script automatically syncs files based on the repository structure:
# - Files in dotfiles/ are synced from ~/
# - Directories at repo root are synced from ~/.config/
# - Files in */Preferences/ are synced from ~/Library/Preferences/
#
# To add a new file to sync: just copy it to the appropriate location once,
# and this script will keep it in sync from then on.

echo "🔄 Syncing dotfiles repository..."

# Navigate to repo root (parent of bin/)
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Update Brewfile
echo "\n📦 Updating Brewfile..."
brew bundle dump --file=brew/Brewfile --force

# ============================================================================
# Sync dotfiles from home directory
# ============================================================================

echo "\n📄 Syncing dotfiles..."
synced=0
skipped=0

if [[ -d "dotfiles" ]]; then
    for dest_file in dotfiles/.*; do
        # Skip . and ..
        [[ "$dest_file" == "dotfiles/." || "$dest_file" == "dotfiles/.." ]] && continue

        # Get filename (e.g., .zshrc)
        filename="${dest_file#dotfiles/}"
        src_file="$HOME/$filename"

        if [[ -e "$src_file" ]]; then
            cp "$src_file" "$dest_file" 2>/dev/null && ((synced++)) || ((skipped++))
        else
            ((skipped++))
        fi
    done
fi

echo "   Synced: $synced | Skipped: $skipped"

# ============================================================================
# Sync config directories from ~/.config
# ============================================================================

echo "\n⚙️  Syncing config directories..."
synced=0
skipped=0

# Find directories at repo root that should come from ~/.config
# (exclude special dirs like .git, brew, dotfiles, iterm2, rectangle, macos)
for dest_dir in */; do
    dest_dir="${dest_dir%/}"

    # Skip special directories
    case "$dest_dir" in
        .git|brew|dotfiles|iterm2|rectangle|macos) continue ;;
    esac

    src_dir="$HOME/.config/$dest_dir"

    if [[ -d "$src_dir" ]]; then
        cp -r "$src_dir/." "$dest_dir/" 2>/dev/null && ((synced++)) || ((skipped++))
    else
        ((skipped++))
    fi
done

echo "   Synced: $synced | Skipped: $skipped"

# ============================================================================
# Sync application preferences from ~/Library/Preferences
# ============================================================================

echo "\n🎨 Syncing application preferences..."
synced=0
skipped=0

# Find .plist files in */Preferences/ directories
for dest_file in */Preferences/*.plist; do
    [[ ! -f "$dest_file" ]] && continue

    # Extract just the filename (e.g., com.googlecode.iterm2.plist)
    filename="${dest_file##*/}"
    src_file="$HOME/Library/Preferences/$filename"

    if [[ -f "$src_file" ]]; then
        mkdir -p "$(dirname "$dest_file")"
        cp "$src_file" "$dest_file" 2>/dev/null && ((synced++)) || ((skipped++))
    else
        ((skipped++))
    fi
done

echo "   Synced: $synced | Skipped: $skipped"

# ============================================================================
# Summary
# ============================================================================

echo ""
if [[ -n $(git status --porcelain) ]]; then
    echo "✨ Changes detected:"
    git status --short
    echo "\n💡 Next steps:"
    echo "   - Review: git diff"
    echo "   - Commit: git add . && git commit -m \"Update dotfiles\""
    echo "   - Or use: dotfiles-commit"
else
    echo "✅ Everything is already in sync!"
fi
