import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt5Compat.GraphicalEffects
import qs.Bar.Modules
import qs.Settings
import qs.Services
import qs.Components
import qs.Widgets
import qs.Widgets.Sidebar
import qs.Widgets.Sidebar.Panel
import qs.Helpers
import QtQuick.Controls
import qs.Widgets.Notification

Scope {
    id: rootScope
    property var shell

    Item {
        id: barRootItem
        anchors.fill: parent

        Variants {
            model: Quickshell.screens

            Item {
                property var modelData

                PanelWindow {
                    id: panel
                    screen: modelData
                    color: "transparent"
                    implicitHeight: barBackground.height
                    anchors.top: true
                    margins.top: 3
                    anchors.left: true
                    anchors.right: true
                    margins.left: 50
                    margins.right: 50

                    visible: true

                    Rectangle {
                        id: barBackground
                        width: parent.width
                        height: 15
                        color: Qt.rgba(Theme.backgroundPrimary.r, Theme.backgroundPrimary.g, Theme.backgroundPrimary.b, 0.5)
                        anchors.top: parent.top
                        anchors.left: parent.left
                        radius: 7
                        border.color: Theme.accentPrimary
                        border.width: Settings.settings.showBarBorder ? 1 : 0


                    }

                    Row {
                        id: leftWidgetsRow
                        anchors.verticalCenter: barBackground.verticalCenter
                        anchors.left: barBackground.left
                        anchors.leftMargin: 18
                        spacing: 12

                        SystemInfo {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Media {
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    ActiveWindow {
                        screen: modelData
                    }

                    Workspace {
                        id: workspace
                        screen: modelData
                        anchors.horizontalCenter: barBackground.horizontalCenter
                        anchors.verticalCenter: barBackground.verticalCenter
                    }

                    Row {
                        id: rightWidgetsRow
                        anchors.verticalCenter: barBackground.verticalCenter
                        anchors.right: barBackground.right
                        anchors.rightMargin: 18
                        spacing: 12

                        NotificationIcon {
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Volume {
                            id: widgetsVolume
                            shell: rootScope.shell
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        SystemTray {
                            id: systemTrayModule
                            shell: rootScope.shell
                            anchors.verticalCenter: parent.verticalCenter
                            bar: panel
                            trayMenu: externalTrayMenu
                        }

                        CustomTrayMenu {
                            id: externalTrayMenu
                        }

                        ClockWidget {
                            screen: modelData
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        PanelPopup {
                            id: sidebarPopup
                        }

                        Button {
                            barBackground: barBackground
                            anchors.verticalCenter: parent.verticalCenter
                            screen: modelData
                            sidebarPopup: sidebarPopup
                        }
                    }

                    Background {}
                    Overview {}
                }

                PanelWindow {
                    id: topLeftPanel
                    anchors.top: true
                    anchors.left: true

                    color: "transparent"
                    screen: modelData
                    margins.top: 0
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Top
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"
                    implicitHeight: 24

                    Corners {
                        id: topLeftCorner
                        position: "bottomleft"
                        size: 1.3
                        fillColor: "#000"
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                PanelWindow {
                    id: topRightPanel
                    anchors.top: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData
                    margins.top: 0
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Top
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: topRightCorner
                        position: "bottomright"
                        size: 1.3
                        fillColor: "#000"
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                

                

                PanelWindow {
                    id: bottomLeftPanel
                    anchors.bottom: true
                    anchors.left: true
                    color: "transparent"
                    screen: modelData
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Top
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomLeftCorner
                        position: "topleft"
                        size: 1.3
                        fillColor: "#000"
                        offsetX: -39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }

                PanelWindow {
                    id: bottomRightPanel
                    anchors.bottom: true
                    anchors.right: true
                    color: "transparent"
                    screen: modelData
                    WlrLayershell.exclusionMode: ExclusionMode.Ignore
                    visible: true
                    WlrLayershell.layer: WlrLayer.Top
                    aboveWindows: false
                    WlrLayershell.namespace: "swww-daemon"

                    implicitHeight: 24

                    Corners {
                        id: bottomRightCorner
                        position: "topright"
                        size: 1.3
                        fillColor: "#000"
                        offsetX: 39
                        offsetY: 0
                        anchors.top: parent.top
                    }
                }
            }
        }
    }

    // This alias exposes the visual bar's visibility to the outside world
    property alias visible: barRootItem.visible
}
