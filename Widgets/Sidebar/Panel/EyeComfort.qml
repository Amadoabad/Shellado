

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import qs.Settings
import qs.Components

Rectangle {
    id: eyeComfortButton
    width: 36
    height: 36
    radius: 18
    border.color: Theme.accentPrimary
    border.width: 1

    // State management: 0 for Off, 1 for On, 2 for Auto
    property int eyeComfortState: 0

    // --- PROCESS DEFINITIONS ---

    // State 0: Off
    Process {
        id: offProcess
        command: ["killall", "wlsunset"]
    }

    // State 1: On (Forced Night Mode)
    Process {
        id: onProcess
        command: ["bash", "-c", "killall wlsunset; wlsunset -t 3700 -T 3701"]
    }

    // State 2: Auto (Dynamic/Default)
    Process {
        id: autoProcess
        command: ["bash", "-c", "killall wlsunset; wlsunset -l 30.0 -L 31.2 -t 3700 -T 6500"]
    }

    // --- INITIAL STATE DETECTION ---

    Process {
        id: checkWlsunsetProcess
        command: ["pgrep", "-a", "wlsunset"]
        stdout: StdioCollector { id: pgrepOut }

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                var result = pgrepOut.text;
                if (result.includes("-T 3701")) {
                    eyeComfortState = 1; // On
                } else if (result.includes("-l 30.0")) {
                    eyeComfortState = 2; // Auto
                } else {
                    eyeComfortState = 0; // Off
                }
            } else {
                eyeComfortState = 0; // Off
            }
        }
    }

    Component.onCompleted: {
        checkWlsunsetProcess.running = true;
    }

    // --- UI AND BEHAVIOR ---

    // The background color changes to reflect the current state and hover
    color: {
        if (eyeComfortState === 0) { // Off
            return eyeComfortArea.containsMouse ? Theme.accentPrimary : "transparent";
        } else if (eyeComfortState === 1) { // On
            return Theme.accentPrimary;
        } else { // Auto
            return Qt.darker(Theme.accentPrimary, 1.3);
        }
    }

    // The icon changes to reflect the current state
    Text {
        anchors.centerIn: parent
        font.family: "Material Symbols Outlined"
        font.pixelSize: 22
        text: {
            if (eyeComfortState === 0) return "wb_sunny";        // Off icon
            if (eyeComfortState === 1) return "brightness_4";    // On (Night) icon
            return "brightness_auto";    // Auto icon
        }
        // Text color inverts when the background is filled or on hover
        color: {
            if (eyeComfortState === 0) {
                 return eyeComfortArea.containsMouse ? Theme.onAccent : Theme.accentPrimary;
            }
            return Theme.onAccent;
        }
    }

    MouseArea {
        id: eyeComfortArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            // Cycle through states: 0 (Off) -> 1 (On) -> 2 (Auto) -> 0
            eyeComfortState = (eyeComfortState + 1) % 3;

            // Execute the corresponding process
            if (eyeComfortState === 0) {
                offProcess.running = true;
            } else if (eyeComfortState === 1) {
                onProcess.running = true;
            } else { // eyeComfortState === 2
                autoProcess.running = true;
            }
        }
    }

    StyledTooltip {
        text: {
            if (eyeComfortState === 0) return "Eye Comfort: Off";
            if (eyeComfortState === 1) return "Eye Comfort: On";
            return "Eye Comfort: Auto";
        }
        targetItem: eyeComfortArea
        tooltipVisible: eyeComfortArea.containsMouse
    }
}

