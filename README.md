# Ly-sec Quickshell Desktop Environment

Ly-sec is a modular desktop environment configuration for [Quickshell](https://quickshell.org/) running on [Niri](https://github.com/YaLTeR/niri), a Wayland compositor. It provides a beautiful, modern, and highly customizable user experience with advanced widgets, notification management, clipboard history, and more.

## Features
- Modular QML-based panels and widgets (Bar, Applauncher, Clipboard, Notifications, etc.)
- Notification system with history and popups
- Clipboard manager with searchable history
- Wallpaper manager with theme extraction (Wallust integration)
- System info, media controls, volume, brightness, and more
- Sidebar with quick access panels
- Highly themeable (JSON/QML)

## Getting Started

### Prerequisites
- **Linux** (Any distro with Wayland support works)
- **Niri** (Wayland compositor)
- **Quickshell** (see [Quickshell install guide](https://quickshell.org/docs/v0.1.0/guide))
- **Node.js** (for some helpers)
- **wallust** (for wallpaper-based theming)
- **cliphist** (for clipboard history)
- **Pipewire** (for audio)

### Installation Steps

#### 1. Install Niri
Follow the [Niri install instructions](https://github.com/YaLTeR/niri#installation) for your distro.

#### 2. Install Quickshell
See the [Quickshell documentation](https://quickshell.org/docs/v0.1.0/guide) for installation and setup. You may need to build from source or use a package if available.

#### 3. Clone Ly-sec
```bash
git clone https://github.com/Amadoabad/Shellado.git ~/.config/quickshell/Ly-sec
```

#### 4. Install dependencies
```bash
# Install wallust (for wallpaper theming)
cargo install wallust

# Install cliphist (for clipboard history)
cargo install cliphist

# Install Node.js (if not already installed)
sudo apt install nodejs npm  # or use your distro's package manager
```

#### 5. Configure Quickshell to use Ly-sec
Edit your Quickshell config to point to the Ly-sec workspace:
```ini
[quickshell]
configDir=~/.config/quickshell/Ly-sec
```
Or set the environment variable:
```bash
export QUICKSHELL_CONFIG=~/.config/quickshell/Ly-sec
```

#### 6. Start Niri and Quickshell
Start Niri (usually via your display manager or from TTY):
```bash
niri
```
Then start Quickshell:
```bash
quickshell
```

## Usage
- **Bar**: Top panel with system info, media, tray, clock, and more
- **Applauncher**: Application launcher (modular, fuzzy search)
- **Clipboard**: Clipboard history manager (search, copy)
- **Notifications**: Popup and history for desktop notifications
- **WallpaperManager**: Change wallpapers, auto-theme with Wallust
- **Sidebar**: Quick access to panels (Bluetooth, Wifi, Weather, etc.)

## Customization
- Edit `Settings/Settings.json` and `Settings/Theme.json` for appearance and behavior
- Add/remove widgets in `Bar/Modules/`
- Modify QML files for advanced customization

## Contributing
Pull requests and issues are welcome! See the source code for modular structure and add your own widgets or services.

## Links
- [Quickshell Documentation](https://quickshell.org/docs/v0.1.0/guide)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Wallust](https://github.com/xyene/wallust)
- [cliphist](https://github.com/sentriz/cliphist)
- Inspiration ~~and code yanked~~ from [Ly-sec](https://github.com/Ly-sec/nixos)
