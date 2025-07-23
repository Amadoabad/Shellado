pragma Singleton
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import qs.Settings

Singleton {
    id: manager

    property string cpuUsageStr: ""
    property string cpuTempStr: ""
    property string memoryUsageStr: ""
    property string memoryUsagePerStr: ""
    property real cpuUsage: 0
    property real cpuTemp: 0
    property real memoryUsage: 0
    property real memoryUsagePer: 0

    Timer {
        id: updateTimer
        interval: 2000 // 2 seconds
        running: true
        repeat: true
        onTriggered: {
            // console.log("Sysinfo: Timer triggered, starting process.");
            zigstatProcess.running = true;
        }
    }

    Process {
        id: zigstatProcess
        running: false // Will be started by the timer
        command: [Quickshell.shellRoot + "/scripts/get_sysinfo.sh"]
        // console.log("Sysinfo: get_sysinfo.sh process started.");
        onExited: (exitCode, status) => {
            // console.log(`Sysinfo: get_sysinfo.sh process exited with code: ${exitCode}, status: ${status}`);
        }
        stdout: SplitParser {
            splitMarker: "\n"
            property var outputLines: []
            onRead: function (line) {
                // console.log("Sysinfo: Raw line read: " + line);
                outputLines.push(line);
                if (outputLines.length === 3) {
                    // CPU Usage
                    const cpuLine = outputLines[0];
                    cpuUsage = parseFloat(cpuLine);
                    cpuUsageStr = cpuUsage.toFixed(0) + "%";
                    // console.log("Sysinfo: Parsed CPU Usage: " + cpuUsageStr);

                    // Memory Usage
                    const memLine = outputLines[1];
                    const memParts = memLine.split(" ");
                    if (memParts.length === 2) {
                        const usedMem = parseInt(memParts[0]);
                        const totalMem = parseInt(memParts[1]);
                        memoryUsage = usedMem / 1024; // Convert MB to GB
                        memoryUsagePer = (usedMem / totalMem) * 100;
                        memoryUsageStr = memoryUsage.toFixed(1) + "G";
                        memoryUsagePerStr = memoryUsagePer.toFixed(0) + "%";
                        // console.log(`Sysinfo: Parsed Memory Usage: ${memoryUsageStr} (${memoryUsagePerStr})`);
                    }

                    // CPU Temperature
                    const tempLine = outputLines[2];
                    cpuTemp = parseFloat(tempLine);
                    cpuTempStr = cpuTemp.toFixed(0) + "°C";
                    // console.log("Sysinfo: Parsed CPU Temp: " + cpuTempStr);

                    outputLines = []; // Reset for next batch
                }
            }
        }
    }
}