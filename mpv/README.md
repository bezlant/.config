# mpv-play: Background Audio Player with Menu Bar Integration

A macOS setup for playing audio files in a background mpv daemon with SwiftBar menu bar integration.

## Features

- 🎵 **Background playback** - mpv runs as a daemon, no window stealing focus
- 📊 **Menu bar integration** - Shows currently playing track in menu bar (via SwiftBar)
- 🔇 **Auto-hide** - Menu bar item hides when nothing is playing
- 🎯 **Default handler** - Opens audio files from Finder, neovim `gx`, etc.
- ⏹️ **Stop button** - Completely stops playback (not just pause)

## Directory Structure

```
~/.config/mpv/
├── README.md                 # This file
├── install.sh                # Installation script for new computers
├── mpv.conf                  # mpv configuration
├── mpv-play.applescript      # Source for mpv-play.app
├── mpv-play.duti             # File association configuration
├── scripts/
│   ├── mpv-daemon            # Starts mpv daemon
│   ├── mpv-play              # Plays audio files in daemon
│   └── mpv-stop              # Stops playback completely
└── swiftbar/
    └── mpv.10s.sh            # SwiftBar menu bar plugin
```

## Installation on New Computer

### Prerequisites

- **Homebrew** - Install from [brew.sh](https://brew.sh)
- **Your dotfiles** - Clone and ensure `~/.config/mpv/` is synced

### Setup

Run the installation script (it will auto-install dependencies):

```bash
~/.config/mpv/install.sh
```

This will:
- Install dependencies (mpv, socat, duti, SwiftBar) if missing
- Create symlinks in `~/.local/bin/` for all scripts
- Build and install `mpv-play.app` to `/Applications/`
- Register file associations with duti
- Create SwiftBar plugin symlink

### Manual Steps

1. **Configure SwiftBar**:
   - Open SwiftBar preferences
   - Set plugin directory to `~/.config/swiftbar/plugins`
   - Refresh plugins

2. **Verify file associations**:
   ```bash
   duti -x mp3
   # Should show: mpv-play, /Applications/mpv-play.app, com.local.mpv-play
   ```

## Usage

### Playing Audio Files

Any of these methods will play audio in the background daemon:

- **Neovim**: Use `gx` on a file path
- **Finder**: Double-click an audio file
- **Terminal**: `open song.mp3` or `mpv-play song.mp3`

### Menu Bar

When audio is playing:
```
♫ ▶︎ filename.mp3
---
Play / Pause | ...
Stop | ...
```

When nothing is playing:
- Menu bar item is hidden

### Commands

```bash
# Play file(s)
mpv-play song.mp3
mpv-play *.mp3

# Toggle play/pause
mpv-play

# Stop playback completely
mpv-stop

# Start daemon manually (auto-starts when needed)
mpv-daemon
```

## How It Works

1. **mpv-daemon** - Runs mpv in idle mode with IPC socket at `~/.mpv-audio.sock`
2. **mpv-play** - Sends commands to daemon via socket (no-video, audio-only)
3. **mpv-play.app** - macOS app bundle that wraps `mpv-play` to handle file associations
4. **SwiftBar plugin** - Queries daemon every 10s for current track, shows in menu bar
5. **duti** - Registers `mpv-play.app` as default handler for audio files

## File Associations

Supported formats (see `mpv-play.duti`):
- MP3 (`.mp3`)
- M4A/AAC (`.m4a`, `.aac`)
- FLAC (`.flac`)
- OGG (`.ogg`)
- WAV (`.wav`)
- AIFF (`.aiff`, `.aifc`)
- All other audio formats via `public.audio` UTI

## Troubleshooting

### Menu bar not showing track
```bash
# Check if daemon is running
pgrep -lf mpv

# Check if socket exists
ls -la ~/.mpv-audio.sock

# Test socket communication
printf '{ "command": ["get_property", "path"] }\n' | socat - UNIX-CONNECT:~/.mpv-audio.sock
```

### File associations not working
```bash
# Re-register app
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/mpv-play.app

# Reapply duti config
duti ~/.config/mpv/mpv-play.duti

# Check current handler
duti -x mp3
```

### Stop button not working
```bash
# Test stop command directly
~/.local/bin/mpv-stop

# Check if playlist cleared
printf '{ "command": ["get_property", "playlist"] }\n' | socat - UNIX-CONNECT:~/.mpv-audio.sock
```

## Customization

### Change menu bar update interval

Edit `swiftbar/mpv.10s.sh` filename:
- `mpv.5s.sh` - Update every 5 seconds
- `mpv.30s.sh` - Update every 30 seconds

### Change daemon timeout

Edit `scripts/mpv-daemon`, line 14:
```bash
--idle-exit=600    # Exit after 600 seconds (10 minutes) of idle
```

### Add video support

Edit `scripts/mpv-daemon`, remove:
```bash
--no-video         # Remove this line to show video
```

## Git Integration

All files in `~/.config/mpv/` are git-tracked except:
- Socket file (`~/.mpv-audio.sock`) - created at runtime
- Temp files

Symlinks in other locations (like `~/.local/bin/`) are not tracked - they're created by `install.sh`.

## Uninstallation

```bash
# Remove symlinks
rm ~/.local/bin/mpv-{play,stop,daemon}
rm ~/.config/swiftbar/plugins/mpv.10s.sh
rm ~/.config/duti/com.local.mpv-play.duti

# Remove app
rm -rf /Applications/mpv-play.app

# Kill daemon
pkill -f "mpv.*mpv-audio.sock"
rm ~/.mpv-audio.sock
```
