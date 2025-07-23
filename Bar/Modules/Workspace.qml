import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import qs.Settings
import qs.Services

Item {
    id: root
    required property ShellScreen screen
    property bool isDestroying: false
    property bool hovered: false

    signal workspaceChanged(int workspaceId, color accentColor)

    property ListModel localWorkspaces: ListModel {}
    property real masterProgress: 0.0
    property bool effectsActive: false
    property color effectColor: Theme.accentPrimary

    property int horizontalPadding: 5
    property int spacingBetweenPills: 2

    width: {
        let total = 0;
        for (let i = 0; i < localWorkspaces.count; i++) {
            const ws = localWorkspaces.get(i);
            total += 20; // Approximate width for a single digit
        }
        total += Math.max(localWorkspaces.count - 1, 0) * spacingBetweenPills;
        total += horizontalPadding * 2;
        return total;
    }

    height: 10

    Component.onCompleted: {
        localWorkspaces.clear();
        for (let i = 0; i < WorkspaceManager.workspaces.count; i++) {
            const ws = WorkspaceManager.workspaces.get(i);
            if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                localWorkspaces.append(ws);
            }
        }
        workspaceRepeater.model = localWorkspaces;
        updateWorkspaceFocus();
    }

    Connections {
        target: WorkspaceManager
        function onWorkspacesChanged() {
            localWorkspaces.clear();
            for (let i = 0; i < WorkspaceManager.workspaces.count; i++) {
                const ws = WorkspaceManager.workspaces.get(i);
                if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                    localWorkspaces.append(ws);
                }
            }

            workspaceRepeater.model = localWorkspaces;
            updateWorkspaceFocus();
        }
    }

    function triggerUnifiedWave() {
        effectColor = Theme.accentPrimary;
        masterAnimation.restart();
    }

    SequentialAnimation {
        id: masterAnimation
        PropertyAction {
            target: root
            property: "effectsActive"
            value: true
        }
        NumberAnimation {
            target: root
            property: "masterProgress"
            from: 0.0
            to: 1.0
            duration: 1000
            easing.type: Easing.OutQuint
        }
        PropertyAction {
            target: root
            property: "effectsActive"
            value: false
        }
        PropertyAction {
            target: root
            property: "masterProgress"
            value: 0.0
        }
    }

    function updateWorkspaceFocus() {
        for (let i = 0; i < localWorkspaces.count; i++) {
            const ws = localWorkspaces.get(i);
            if (ws.isFocused === true) {
                root.triggerUnifiedWave();
                root.workspaceChanged(ws.id, Theme.accentPrimary);
                break;
            }
        }
    }

    

    Row {
        id: pillRow
        spacing: spacingBetweenPills
        anchors.verticalCenter: parent.verticalCenter
        width: root.width - horizontalPadding * 2
        x: horizontalPadding
        Repeater {
            id: workspaceRepeater
            model: localWorkspaces
            Item {
                id: workspacePillContainer
                height: 8
                width: 20

                MouseArea {
                    id: pillMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        WorkspaceManager.switchToWorkspace(model.idx);
                    }
                    hoverEnabled: true
                }

                Text {
                    id: workspaceNumber
                    text: model.index + 1 // Use model.index for order-based numbering
                    anchors.centerIn: parent
                    color: model.isFocused ? Theme.accentPrimary : Theme.textPrimary
                    font.pixelSize: model.isFocused ? 18 : 12
                    font.bold: model.isFocused
                    opacity: model.isFocused ? 1 : 0.7
                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutBack
                    }
                }
                Behavior on height {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutBack
                    }
                }
                
            }
        }
    }

    Component.onDestruction: {
        root.isDestroying = true;
    }
}
