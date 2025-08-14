import QtQuick
import Quickshell
import qs.Components

IconButton {
    id: root
    icon: "notifications" // Using a generic notification icon
    iconPixelSize: 18
    onClicked: {
        Quickshell.execDetached(["swaync-client", "-t"])
    }
}
