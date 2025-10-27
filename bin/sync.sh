#!/usr/bin/env zsh
# Sync dotfiles and Brewfile to repository
#
# This script automatically syncs files based on the repository structure:
# - Files in dotfiles/ are synced from ~/
# - Directories in apps/ with Preferences/ subdirs sync plists from ~/Library/Preferences/
# - Directories in apps/ without Preferences/ sync from ~/.config/
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
# Sync application configs from apps/
# ============================================================================

echo "\n⚙️  Syncing application configs..."
synced=0
skipped=0

if [[ -d "apps" ]]; then
    for app_dir in apps/*/; do
        [[ ! -d "$app_dir" ]] && continue

        app_name="${app_dir#apps/}"
        app_name="${app_name%/}"

        # Check if this app has a Preferences subdirectory (for plists)
        if [[ -d "$app_dir/Preferences" ]]; then
            # Sync .plist files from ~/Library/Preferences/
            for dest_file in "$app_dir/Preferences/"*.plist; do
                [[ ! -f "$dest_file" ]] && continue

                filename="${dest_file##*/}"
                src_file="$HOME/Library/Preferences/$filename"

                if [[ -f "$src_file" ]]; then
                    mkdir -p "$(dirname "$dest_file")"
                    cp "$src_file" "$dest_file" 2>/dev/null && ((synced++)) || ((skipped++))
                else
                    ((skipped++))
                fi
            done
        else
            # No Preferences subdir, sync from ~/.config/
            src_dir="$HOME/.config/$app_name"

            if [[ -d "$src_dir" ]]; then
                mkdir -p "$app_dir"
                cp -r "$src_dir/." "$app_dir/" 2>/dev/null && ((synced++)) || ((skipped++))
            else
                ((skipped++))
            fi
        fi
    done
fi

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
