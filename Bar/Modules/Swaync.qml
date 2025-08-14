import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.Components

Item {
    id: root
    width: 24
    height: 24

    DankIcon {
        anchors.centerIn: parent
        name: "notifications"
        size: 16
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Quickshell.execute("swaync-client -t")
        }
    }
}
