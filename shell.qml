import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtCore
import qs.Bar
import qs.Bar.Modules
import qs.Widgets
import qs.Settings
import qs.Helpers

Scope {
    id: root

    property alias appLauncherPanel: appLauncherPanel

    function updateVolume(vol) {
        volume = vol;
        if (defaultAudioSink && defaultAudioSink.audio) {
            defaultAudioSink.audio.volume = vol / 100;
        }
    }

    Component.onCompleted: {
        Quickshell.shell = root;
    }

    Bar {
        id: bar
        shell: root
    }

    Applauncher {
        id: appLauncherPanel
        visible: false
    }

    ClipboardHistory {
        id: clipboard
        visible: false
    }

    LockScreen {
        id: lockScreen
    }

    property var defaultAudioSink: Pipewire.defaultAudioSink
    property int volume: defaultAudioSink && defaultAudioSink.audio && defaultAudioSink.audio.volume ? Math.round(defaultAudioSink.audio.volume * 100) : 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    IPCHandlers {
        id: ipcHandlers
    }

    Connections {
        target: ipcHandlers
        function onToggleLauncherRequested() {
            if (appLauncherPanel.visible) {
                appLauncherPanel.hidePanel();
            } else {
                appLauncherPanel.showAt();
            }
        }
        function onToggleLockRequested() { lockScreen.locked = !lockScreen.locked }
        function onToggleClipboardRequested() { clipboard.toggle() }
    }

    Connections {
        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }

        function onReloadFailed() {
            Quickshell.inhibitReloadPopup();
        }

        target: Quickshell


    }
        Timer {
            id: reloadTimer
            interval: 500
            repeat: false
            onTriggered: 
                Quickshell.reload();
            }
        
        Connections {
            target: Quickshell
            function onScreensChanged() {
                reloadTimer.restart();
            }
        }
}
