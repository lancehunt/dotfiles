# dotfiles

Personal macOS dotfiles and configuration management.

## Quick Start

### Fresh Install
```bash
./bin/dotfiles-setup
```

### Daily Usage
```bash
dotfiles-sync      # Save local configs to repo
dotfiles-restore   # Restore from repo (safe, checks for local changes)
```

## Adding New Configs

### Dotfiles (from ~/)
```bash
cp ~/.bashrc dotfiles/.bashrc
```

### App Configs (Easy Way)
```bash
# Add a .plist preference file
dotfiles-add-app ~/Library/Preferences/com.microsoft.VSCode.plist vscode

# Add a config directory
dotfiles-add-app ~/.config/nvim nvim
```

After adding files once, `dotfiles-sync` automatically keeps them in sync.

## Structure

```
dotfiles/     # Shell configs from ~/
apps/         # Application configs
  */Preferences/  # .plist files from ~/Library/Preferences
  */              # Directories from ~/.config
brew/         # Brewfile (managed by brew bundle)
bin/          # Scripts
```

## Commands

- `dotfiles-sync` - Copy local → repo, auto-fix formatting
- `dotfiles-restore` - Copy repo → local (checks for unsync'd changes)
- `dotfiles-add-app` - Add app config to repo (smart detection)
- `dotfiles-setup` - Fresh install (Homebrew, packages, configs)

## Safety

`dotfiles-restore` protects against data loss by detecting unsync'd local changes before overwriting.
