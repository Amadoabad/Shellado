pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.Services

Singleton {

    property string shellName: "quickshell/Shellado"
    property string settingsDir: Quickshell.env("HOME") + "/.config/" + shellName + "/Settings/"
    property string settingsFile: settingsDir + "Settings.json"
    property var settings: settingAdapter

    Item {
        Component.onCompleted: {
            // ensure settings dir
            Quickshell.execDetached(["mkdir", "-p", settingsDir]);
        }
    }

    FileView {
        id: settingFileView
        path: settingsFile
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        Component.onCompleted: function() {
            reload()
        }
        onLoaded: function() {
            WallpaperManager.setCurrentWallpaper(settings.currentWallpaper, true);
        }
        onLoadFailed: function(error) {
            settingAdapter = {}
            writeAdapter()
        }
        JsonAdapter {
            id: settingAdapter
            property string weatherCity: "Cairo"
            property string profileImage: Quickshell.env("HOME") + "/.face"
            property bool useFahrenheit: false
            property string wallpaperFolder: "/home/amado/amado/theming/bg/slideshow"
            property string currentWallpaper: ""
            property string videoPath: "~/Videos/"
            property bool showActiveWindowIcon: false
            property bool showSystemInfoInBar: true
            property bool showMediaInBar: true
            property bool useSWWW: true
            property bool randomWallpaper: true
            property bool useWallpaperTheme: true
            property int wallpaperInterval: 900
            property string wallpaperResize: "crop"
            property int transitionFps: 60
            property string transitionType: "simple"
            property real transitionDuration: 2.5
            property string visualizerType: "radial"
            property bool reverseDayMonth: false
            property bool use12HourClock: false
            property bool dimPanels: true
            property bool showBarBorder: false
        }
    }

    Connections {
        target: settingAdapter
        function onRandomWallpaperChanged() { WallpaperManager.toggleRandomWallpaper() }
        function onWallpaperIntervalChanged() { WallpaperManager.restartRandomWallpaperTimer() }
        function onWallpaperFolderChanged() { WallpaperManager.loadWallpapers() }
        function onWeatherCityChanged() { settingFileView.writeAdapter() }
    }
}