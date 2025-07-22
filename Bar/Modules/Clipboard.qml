import QtQuick
import QtQuick.Layouts
import qs.Components

Item {
    id: clipboard
    width: 30
    height: 30

    IconButton {
        anchors.centerIn: parent
        icon: "content_paste"
        onClicked: {
            Quickshell.ipcCall("clipboard", "toggle");
        }
    }
}