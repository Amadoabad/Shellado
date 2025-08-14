
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import qs.Components
import Quickshell

Rectangle {
    id: terminalButton
    width: textItem.paintedWidth + 10
    height: textItem.paintedHeight + 10
    color: "transparent"

    Text {
        id: textItem
        text: "terminal"
        font.family: "Material Symbols Outlined"
        font.pixelSize: Theme.fontSizeHeader
        color: Theme.textPrimary
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached(["sh", "-c", "kitty"]);
        }
    }
}
