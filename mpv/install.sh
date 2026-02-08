#!/usr/bin/env bash
# mpv-play installation script
# Sets up mpv daemon, menu bar integration, and file associations

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Installing mpv-play setup..."
echo

# 0. Check and install dependencies
echo -e "${YELLOW}→${NC} Checking dependencies..."

if ! command -v brew >/dev/null 2>&1; then
  echo -e "${RED}✗${NC} Homebrew not found. Please install from https://brew.sh"
  exit 1
fi

DEPS_TO_INSTALL=()
CASK_DEPS_TO_INSTALL=()

# Check CLI tools
for dep in mpv socat duti; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    DEPS_TO_INSTALL+=("$dep")
  fi
done

# Check SwiftBar
if ! [ -d "/Applications/SwiftBar.app" ]; then
  CASK_DEPS_TO_INSTALL+=("swiftbar")
fi

# Install missing dependencies
if [ ${#DEPS_TO_INSTALL[@]} -gt 0 ]; then
  echo -e "${YELLOW}→${NC} Installing: ${DEPS_TO_INSTALL[*]}"
  brew install "${DEPS_TO_INSTALL[@]}"
fi

if [ ${#CASK_DEPS_TO_INSTALL[@]} -gt 0 ]; then
  echo -e "${YELLOW}→${NC} Installing: ${CASK_DEPS_TO_INSTALL[*]}"
  brew install --cask "${CASK_DEPS_TO_INSTALL[@]}"
fi

if [ ${#DEPS_TO_INSTALL[@]} -eq 0 ] && [ ${#CASK_DEPS_TO_INSTALL[@]} -eq 0 ]; then
  echo -e "${GREEN}✓${NC} All dependencies already installed"
fi
echo

# 1. Create symlinks for scripts in ~/.local/bin
echo -e "${YELLOW}→${NC} Creating symlinks in ~/.local/bin..."
mkdir -p ~/.local/bin
ln -sf "$SCRIPT_DIR/scripts/mpv-play" ~/.local/bin/mpv-play
ln -sf "$SCRIPT_DIR/scripts/mpv-stop" ~/.local/bin/mpv-stop
ln -sf "$SCRIPT_DIR/scripts/mpv-daemon" ~/.local/bin/mpv-daemon
chmod +x "$SCRIPT_DIR/scripts/"*

# 2. Create symlink for SwiftBar plugin
if [ -d ~/.config/swiftbar/plugins ]; then
  echo -e "${YELLOW}→${NC} Creating SwiftBar plugin symlink..."
  ln -sf "$SCRIPT_DIR/swiftbar/mpv.10s.sh" ~/.config/swiftbar/plugins/mpv.10s.sh
  chmod +x "$SCRIPT_DIR/swiftbar/mpv.10s.sh"
else
  echo -e "${YELLOW}⚠${NC}  SwiftBar plugins directory not found, skipping..."
fi

# 3. Build and install mpv-play.app
echo -e "${YELLOW}→${NC} Building mpv-play.app..."
rm -rf /tmp/mpv-play-build.app /Applications/mpv-play.app

osacompile -o /tmp/mpv-play-build.app "$SCRIPT_DIR/mpv-play.applescript"

# Update Info.plist with proper bundle ID and settings
/usr/libexec/PlistBuddy -c "Add :CFBundleIdentifier string com.local.mpv-play" /tmp/mpv-play-build.app/Contents/Info.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier com.local.mpv-play" /tmp/mpv-play-build.app/Contents/Info.plist

/usr/libexec/PlistBuddy -c "Set :CFBundleName mpv-play" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :LSUIElement bool true" /tmp/mpv-play-build.app/Contents/Info.plist 2>/dev/null || \
  /usr/libexec/PlistBuddy -c "Set :LSUIElement true" /tmp/mpv-play-build.app/Contents/Info.plist

# Add audio file type associations
/usr/libexec/PlistBuddy -c "Delete :CFBundleDocumentTypes" /tmp/mpv-play-build.app/Contents/Info.plist 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes array" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0 dict" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeName string 'Audio File'" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Viewer" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Default" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:0 string public.audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:1 string public.mp3" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:2 string public.mpeg-4-audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:3 string com.apple.m4a-audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:4 string org.xiph.flac" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:5 string org.xiph.ogg-audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:6 string com.microsoft.waveform-audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:7 string public.aiff-audio" /tmp/mpv-play-build.app/Contents/Info.plist
/usr/libexec/PlistBuddy -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:8 string public.aifc-audio" /tmp/mpv-play-build.app/Contents/Info.plist

# Move to Applications
mv /tmp/mpv-play-build.app /Applications/mpv-play.app

# Register with Launch Services
echo -e "${YELLOW}→${NC} Registering with Launch Services..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f /Applications/mpv-play.app

# 4. Configure file associations with duti (if installed)
if command -v duti >/dev/null 2>&1; then
  echo -e "${YELLOW}→${NC} Configuring file associations with duti..."
  duti "$SCRIPT_DIR/mpv-play.duti"

  # Create symlink in duti config dir if it exists
  if [ -d ~/.config/duti ]; then
    mkdir -p ~/.config/duti
    ln -sf "$SCRIPT_DIR/mpv-play.duti" ~/.config/duti/com.local.mpv-play.duti
  fi
else
  echo -e "${YELLOW}⚠${NC}  duti not installed. Install with: brew install duti"
  echo -e "    Then run: duti $SCRIPT_DIR/mpv-play.duti"
fi

echo
echo -e "${GREEN}✓${NC} Installation complete!"
echo
echo "Usage:"
echo "  • Open any audio file - it will play in mpv daemon"
echo "  • Menu bar shows: ♫ ▶︎ filename.ext"
echo "  • Click 'Stop' to stop playback"
echo "  • Menu bar hides when nothing is playing"
echo
echo "Commands:"
echo "  mpv-play [file...]    - Play audio file(s)"
echo "  mpv-stop              - Stop playback"
echo "  mpv-daemon            - Start mpv daemon"
