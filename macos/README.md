# macOS Settings

Export and apply macOS system settings across machines.

## Quick Start

### Export Current Settings
```bash
macos-export
```

This captures your current settings to `macos/settings/` including:
- Dock (size, position, auto-hide, etc.)
- Finder (hidden files, extensions, view mode, etc.)
- Keyboard (repeat rate, delay, function keys)
- Trackpad (speed, gestures, tap-to-click)
- Screenshots (format, location, thumbnail)
- System UI (dark mode, accent color, menu bar)

### Apply Settings on New Machine
```bash
macos-apply
```

Applies all saved settings from `macos/settings/` to your system.

## What Gets Captured

### Dock Settings
- Dock size and magnification
- Position (bottom/left/right)
- Auto-hide behavior
- Show recents in Dock
- Minimize effects

### Finder Preferences
- Show hidden files
- Show file extensions
- Default view style (icon/list/column/gallery)
- Show path bar and status bar
- Sidebar items

### Keyboard & Trackpad
- Key repeat rate and initial delay
- Function key behavior
- Trackpad speed and acceleration
- Tap to click, gestures
- Natural scrolling direction

### Screenshots
- Default format (png/jpg)
- Save location
- Show floating thumbnail
- Include date in filename

### System UI
- Dark mode preference
- Accent color
- Highlight color
- Menu bar appearance

## Workflow

### Initial Setup
1. Configure macOS settings exactly how you like them
2. Run `macos-export` to capture current settings
3. Commit: `git add macos/settings && git commit -m "Add macOS settings"`
4. Push to your dotfiles repo

### On New Machine
1. Clone dotfiles repo
2. Run `macos-apply` to restore settings
3. Log out/in or restart Dock/Finder for changes to take effect

### Updating Settings
When you change macOS settings:
1. Run `macos-export` to capture new settings
2. Review changes: `git diff macos/settings`
3. Commit and push if desired

## Files Structure

```
macos/
├── README.md                      # This file
└── settings/                      # Exported settings
    ├── CURRENT_SETTINGS.md        # Human-readable summary
    ├── dock.plist                 # Dock settings
    ├── finder.plist               # Finder settings
    ├── keyboard.plist             # Keyboard/NSGlobalDomain settings
    ├── trackpad.plist             # Trackpad settings
    ├── trackpad-bluetooth.plist   # Bluetooth trackpad settings
    ├── screenshots.plist          # Screenshot settings
    └── menubar.plist              # Menu bar settings
```

## Commands

Located in `bin/`:
- `macos-export` - Export current macOS settings to files
- `macos-apply` - Apply saved settings to system

## Important Notes

⚠️ **Settings Require Restart**: Many macOS settings require logging out/in or restarting applications:
```bash
# Restart Dock, Finder, and SystemUIServer
killall Dock Finder SystemUIServer
```

⚠️ **System Preferences**: Some settings may require System Preferences to be closed during import.

⚠️ **Permissions**: Some settings may require Full Disk Access or other permissions.

## Verification

After applying settings, review what was applied:
```bash
cat macos/settings/CURRENT_SETTINGS.md
```

## Troubleshooting

**Settings didn't apply**:
- Try logging out and back in
- Restart Dock/Finder: `killall Dock Finder`
- Check permissions in System Preferences

**Export created .txt files instead of .plist**:
- This is normal for some domains
- Apply script handles both formats

**Want to reset to defaults**:
- Delete specific plist: `rm macos/settings/dock.plist`
- Re-export: `macos-export`
