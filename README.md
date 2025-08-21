# Shellado Quickshell Desktop Environment

Shellado is a modular desktop environment configuration for [Quickshell](https://quickshell.org/) running on [Niri](https://github.com/YaLTeR/niri), a Wayland compositor. It provides a beautiful, modern, and highly customizable user experience with advanced widgets, notification management, clipboard history, and more.

## Features

### Core Components
*   **Top Bar**: A sleek and informative bar at the top of the screen with the following modules:
    *   **App Launcher**: Quickly search and launch your applications.
    *   **Workspace Indicator**: Switch between workspaces.
    *   **System Tray**: Access your system tray icons.
    *   **Media Controls**: Control media playback.
    *   **Volume & Brightness**: Adjust system volume and screen brightness.
    *   **Battery Indicator**: Monitor your battery status.
    *   **Clock & Calendar**: View the current time and date, and a calendar.
    *   **Swaync Integration**: Manage your notifications with Swaync.
*   **Sidebar**: A right-hand sidebar for quick access to various panels:
    *   **Quick Settings**: Toggle Bluetooth, Wi-Fi, and other system settings.
    *   **System Monitor**: View CPU, memory, and other system resource usage.
    *   **Weather**: Get the latest weather forecast.
    *   **Music Player**: Control your music playback.
    *   **Wallpaper Selection**: Change your desktop wallpaper.
*   **Wallpaper Manager**:
    *   Powered by **Wallust**, it automatically extracts colors from your wallpaper to create a consistent theme.
    *   Supports random wallpapers and slideshows.
*   **Clipboard Manager**:
    *   Keeps a history of your copied items.
    *   Searchable, so you can easily find what you're looking for.
*   **Theming**:
    *   Easily customize the look and feel with JSON-based themes.
    *   Fine-tune your settings through the settings modal.

### Other Widgets
*   **Lock Screen**: A secure and beautiful lock screen.
*   **Overview**: A full-screen overview of your workspaces and windows.
*   **Background**: Manages the desktop background.

## Getting Started

### Prerequisites
*   **Linux** (Any distro with Wayland support)
*   **Niri** (Wayland compositor)
*   **Quickshell**
*   **Node.js**
*   **wallust**
*   **cliphist**
*   **Pipewire**

### Installation Steps

1.  **Install Niri**: Follow the [Niri install instructions](https://github.com/YaLTeR/niri#installation) for your distro.
2.  **Install Quickshell**: See the [Quickshell documentation](https://quickshell.org/docs/v0.1.0/guide) for installation and setup.
3.  **Clone Shellado**:
    ```bash
    git clone https://github.com/Amadoabad/Shellado.git ~/.config/quickshell/Shellado
    ```
4.  **Install dependencies**:
    ```bash
    # Install wallust (for wallpaper theming)
    cargo install wallust

    # Install cliphist (for clipboard history)
    cargo install cliphist

    # Install Node.js (if not already installed)
    sudo apt install nodejs npm  # or use your distro's package manager
    ```
5.  **Configure Quickshell to use Shellado**:
    Edit your Quickshell config to point to the Shellado workspace:
    ```ini
    [quickshell]
    configDir=~/.config/quickshell/Shellado
    ```
    Or set the environment variable:
    ```bash
    export QUICKSHELL_CONFIG=~/.config/quickshell/Shellado
    ```
6.  **Start Niri and Quickshell**:
    Start Niri (usually via your display manager or from TTY):
    ```bash
    niri
    ```
    Then start Quickshell:
    ```bash
    quickshell
    ```

## Customization

*   Edit `Settings/Settings.json` and `Settings/Theme.json` for appearance and behavior.
*   Add/remove widgets in `Bar/Modules/`.
*   Modify QML files for advanced customization.

## Contributing

Pull requests and issues are welcome! See the source code for modular structure and add your own widgets or services.

## Links

*   [Quickshell Documentation](https://quickshell.org/docs/v0.1.0/guide)
*   [Niri Documentation](https://github.com/YaLTeR/niri)
*   [Wallust](https://github.com/xyene/wallust)
*   [cliphist](https://github.com/sentriz/cliphist)
*   Inspiration ~~and code yanked~~ from [Ly-sec](https://github.com/Ly-sec/Noctalia)

