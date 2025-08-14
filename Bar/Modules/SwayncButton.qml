import QtQuick
import Quickshell
import qs.Components

IconButton {
    id: root
    icon: "notifications" // Using a generic notification icon
    onClicked: {
        Quickshell.execDetached(["swaync-client", "-t"])
    }
}
