import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    Component.onCompleted: {
        checkAndStartSwaync();
    }

    property Process checkProcess: Process {
        onExited: (exitCode) => {
            if (exitCode !== 0) {
                // swaync is not running, start it
                console.log("Starting swaync daemon...");
                Quickshell.execDetached(["swaync"]);
            } else {
                console.log("swaync is already running");
            }
        }
    }

    function checkAndStartSwaync() {
        // First check if swaync is running
        checkProcess.command = ["pgrep", "swaync"];
        checkProcess.running = true;
    }
}
