import QtQuick
import Quickshell.Services.UPower
import QtQuick.Layouts
import qs.Settings
import qs.Components

Item {
    id: batteryWidget

    property var battery: UPower.displayDevice
    property bool isReady: battery && battery.ready && battery.isLaptopBattery && battery.isPresent
    property real percent: isReady ? (battery.percentage * 100) : 0
    property bool charging: isReady ? battery.state === UPowerDeviceState.Charging : false
    property bool show: isReady && percent > 0

    visible: isReady && battery.isLaptopBattery
    // Manually calculate width based on visible children
    width: icon.width + (percentageText.visible ? percentageText.width + 6 : 0)
    height: icon.height

    function batteryIcon() {
        if (!show) return "";
        if (charging) {
            if (percent >= 95) return "battery_charging_full";
            if (percent >= 80) return "battery_charging_80";
            if (percent >= 60) return "battery_charging_60";
            if (percent >= 50) return "battery_charging_50";
            if (percent >= 30) return "battery_charging_30";
            return "battery_charging_20";
        }
        if (percent >= 95) return "battery_full";
        if (percent >= 80) return "battery_80";
        if (percent >= 60) return "battery_60";
        if (percent >= 50) return "battery_50";
        if (percent >= 30) return "battery_30";
        if (percent >= 20) return "battery_20";
        return "battery_alert";
    }

    Text {
        id: icon
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        text: batteryIcon()
        font.family: "Material Symbols Outlined"
        font.pixelSize: 16
        color: charging ? Theme.accentPrimary : Theme.textPrimary

        Behavior on color { ColorAnimation { duration: 300 } }
    }

    Text {
        id: percentageText
        anchors.left: icon.right
        anchors.leftMargin: 6 // Manual spacing
        anchors.verticalCenter: parent.verticalCenter
        text: Math.round(percent) + "%"
        font.pixelSize: Theme.fontSizeSmall
        font.family: Theme.fontFamily
        color: Theme.textPrimary
        
        // This will now work correctly with manual anchoring
        visible: !charging
    }

    property bool containsMouse: false

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: batteryWidget.containsMouse = true
        onExited: batteryWidget.containsMouse = false
        cursorShape: Qt.PointingHandCursor
    }

    StyledTooltip {
        id: batteryTooltip
        text: {
            let lines = [];
            if (batteryWidget.isReady) {
                lines.push(batteryWidget.charging ? "Charging" : "Discharging");
                lines.push(Math.round(batteryWidget.percent) + "%");
                if (batteryWidget.battery.timeToEmpty > 0)
                    lines.push("Time left: " + Math.floor(batteryWidget.battery.timeToEmpty / 60) + " min");
                if (batteryWidget.battery.timeToFull > 0)
                    lines.push("Time to full: " + Math.floor(batteryWidget.battery.timeToFull / 60) + " min");
            }
            return lines.join("\n");
        }
        tooltipVisible: batteryWidget.containsMouse
        targetItem: batteryWidget
        delay: 200
    }
}