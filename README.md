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

### App Configs (from ~/.config)
```bash
cp -r ~/.config/nvim apps/nvim
```

### App Preferences (plists from ~/Library/Preferences)
```bash
mkdir -p apps/vscode/Preferences
cp ~/Library/Preferences/com.microsoft.VSCode.plist apps/vscode/Preferences/
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
- `dotfiles-setup` - Fresh install (Homebrew, packages, configs)

## Safety

`dotfiles-restore` protects against data loss by detecting unsync'd local changes before overwriting.
