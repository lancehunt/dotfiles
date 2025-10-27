# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository that manages personal development environment configuration. The repository uses a script-based installation approach with Homebrew for package management.

## Repository Structure

```
.
├── bin/               # Scripts and executables
│   ├── setup.sh      # Main installation script
│   └── sync.sh       # Sync script to backup current config
├── brew/             # Homebrew package management
│   └── Brewfile      # Defines all brew packages, casks, VSCode extensions, and Go tools
├── dotfiles/         # Shell and tool configuration files
│   ├── .zshrc        # Zsh configuration
│   ├── .aliases      # Shell aliases and shortcuts
│   ├── .gitconfig    # Git configuration
│   ├── .vimrc        # Vim configuration
│   ├── .aws-profile  # AWS CLI helpers
│   └── .kubectl-profile  # Kubernetes CLI helpers
├── starship/         # Starship prompt configuration
├── iterm2/           # iTerm2 preferences
├── joplin-desktop/   # Joplin note-taking app configuration
├── rectangle/        # Rectangle window manager preferences
└── macos/            # macOS system settings
```

## Common Commands

### Initial Setup
```bash
# Full system setup (installs Homebrew, oh-my-zsh, packages, and copies configs)
./bin/setup.sh
```

### Package Management
```bash
# Install/update all packages from Brewfile
cd brew && brew bundle

# Generate updated Brewfile from current installations
brew bundle dump --force --file=brew/Brewfile

# Cleanup unused packages
brew bundle cleanup --file=brew/Brewfile

# Check for outdated packages
brew outdated
```

### Configuration Management
```bash
# Copy dotfiles to home directory
cp dotfiles/.* ~/.

# Copy application preferences
cp -r iterm2/Preferences/. ~/Library/Preferences/.
cp -r rectangle/Preferences/. ~/Library/Preferences/.

# Copy starship/joplin configs to ~/.config
cp -r starship ~/.config/.
cp -r joplin-desktop ~/.config/.
```

### Pre-commit Hooks
```bash
# Install pre-commit hooks (if not already installed)
pre-commit install

# Run pre-commit checks manually
pre-commit run --all-files
```

## Key Architectural Details

### Brewfile Organization
The `brew/Brewfile` manages four types of installations:
1. **brew** - CLI tools and utilities (git, kubectl, python, go, etc.)
2. **cask** - GUI applications (VSCode, iTerm2, Docker alternatives, etc.)
3. **vscode** - VSCode extensions (automatically synced via brew bundle)
4. **go** - Go-based tools installed via `go install`

### Shell Configuration Loading Order
1. `.zshenv` - Environment variables (currently empty)
2. `.zprofile` - Login shell configuration
3. `.zshrc` - Interactive shell setup, loads:
   - Path configuration
   - History settings
   - Shell replacements (zoxide, exa)
   - Aliases from `.aliases`
   - Tool-specific profiles (`.aws-profile`, `.kubectl-profile`)

### Tool-specific Notes

**zoxide**: Replaces `cd` with smart directory jumping based on frecency
**exa**: Modern `ls` replacement with git integration and icons
**starship**: Cross-shell prompt with git status and language version info
**atuin**: Shell history sync and search tool
**git-secrets**: Prevents committing AWS credentials (registered globally in bin/setup.sh)

### Pre-commit Configuration
The `.pre-commit-config.yaml` enforces:
- No trailing whitespace
- No large files
- Valid JSON/YAML syntax
- No AWS credentials or private keys (via detect-aws-credentials and gitleaks)
- No private keys (SSH keys, certificates, etc.)
- No Python debug statements
- Consistent line endings
- No secrets of 100+ types (API keys, tokens, database credentials via gitleaks)

## Keeping Dotfiles in Sync

To prevent dotfiles from getting out of sync with your actual system configuration:

### Manual Sync (Recommended)
```bash
# Sync everything (Brewfile, dotfiles, app preferences)
dotfiles-sync

# Review changes
cd ~/code/lancehunt/dotfiles && git diff

# Commit and push
dotfiles-commit

# Or do everything in one command
dotfiles-update
```

### Automated Daily Sync (Optional)
To enable automatic daily sync at 6 PM:
```bash
# Install the launchd agent
cp ~/code/lancehunt/dotfiles/com.lancehunt.dotfiles-sync.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.lancehunt.dotfiles-sync.plist

# Check status
launchctl list | grep dotfiles-sync

# View sync logs
tail -f ~/code/lancehunt/dotfiles/sync.log
```

To disable:
```bash
launchctl unload ~/Library/LaunchAgents/com.lancehunt.dotfiles-sync.plist
```

### How Sync Works (Convention-Based)
The `sync.sh` script uses the repository structure to determine what to sync:

1. **Dotfiles** (`dotfiles/` directory)
   - Any file in `dotfiles/` is synced from `~/`
   - Example: `dotfiles/.zshrc` syncs from `~/.zshrc`

2. **Config directories** (repo root)
   - Any directory at repo root (except special dirs) syncs from `~/.config/`
   - Example: `starship/` syncs from `~/.config/starship/`
   - Special dirs excluded: `.git`, `brew`, `dotfiles`, `iterm2`, `rectangle`, `macos`

3. **Application preferences** (`*/Preferences/` directories)
   - Any `.plist` file in a `Preferences/` subdirectory syncs from `~/Library/Preferences/`
   - Example: `iterm2/Preferences/com.googlecode.iterm2.plist` syncs from `~/Library/Preferences/com.googlecode.iterm2.plist`

**To add a new file to sync:**
1. Copy it once to the appropriate location in the repo
2. Run `dotfiles-sync` - it will keep it in sync automatically
3. No need to edit the sync script!

**Currently synced:**
- Brewfile (all installed packages)
- Shell: .zshrc, .aliases, .zprofile, .zshenv, .vimrc
- Git: .gitconfig, .global_gitattributes
- Profiles: .aws-profile, .kubectl-profile
- Configs: starship, joplin-desktop
- Apps: iTerm2, Rectangle

## Modifying This Repository

### Adding a New Brew Package
1. Install the package: `brew install <package>`
2. Update the Brewfile: `brew bundle dump --force --file=brew/Brewfile`
3. Commit the updated Brewfile

### Adding a New Dotfile
```bash
# Example: Add .bashrc to sync
cp ~/.bashrc ~/code/lancehunt/dotfiles/dotfiles/.bashrc
cd ~/code/lancehunt/dotfiles
git add dotfiles/.bashrc
git commit -m "Add .bashrc to dotfiles"

# From now on, dotfiles-sync will keep it in sync automatically!
```

### Adding a New Config Directory
```bash
# Example: Add neovim config to sync
cp -r ~/.config/nvim ~/code/lancehunt/dotfiles/nvim
cd ~/code/lancehunt/dotfiles
git add nvim
git commit -m "Add neovim config"
```

### Adding a New App Preference
```bash
# Example: Add VS Code preferences
mkdir -p ~/code/lancehunt/dotfiles/vscode/Preferences
cp ~/Library/Preferences/com.microsoft.VSCode.plist ~/code/lancehunt/dotfiles/vscode/Preferences/
cd ~/code/lancehunt/dotfiles
git add vscode
git commit -m "Add VS Code preferences"
```

### Testing Changes
Since this repository directly modifies system configuration:
1. Test changes in a non-production environment when possible
2. Backup existing configurations before running `bin/setup.sh`
3. Review `bin/setup.sh` before execution to understand what will be modified
4. Run `pre-commit run --all-files` before committing

## Important Files Not to Modify Directly

- **Brewfile.lock.json** - Auto-generated by `brew bundle`, tracks exact versions
- **Application Preferences in ~/Library/Preferences/** - Export from apps, don't hand-edit

## Dependencies

The setup assumes:
- macOS (Darwin-based system)
- Internet connection for downloading Homebrew and packages
- Admin/sudo access for Homebrew installation
- Git (for cloning oh-my-zsh and vim plugins)
