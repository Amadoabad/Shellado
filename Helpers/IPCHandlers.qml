import Quickshell
import Quickshell.Io

IpcHandler {
    property var shellRoot
    

    target: "globalIPC"

    // Toggle Applauncher visibility
    function toggleLauncher(): void {
        if (!shellRoot.appLauncherPanel) {
            console.warn("AppLauncherIpcHandler: appLauncherPanel not set!");
            return;
        }
        if (shellRoot.appLauncherPanel.visible) {
            shellRoot.appLauncherPanel.hidePanel();
        } else {
            console.log("[IPC] Applauncher show() called");
            shellRoot.appLauncherPanel.showAt();
        }
    }

    // Toggle LockScreen
    function toggleLock(): void {
        if (!shellRoot.lockScreen) {
            console.warn("LockScreenIpcHandler: lockScreen not set!");
            return;
        }
        console.log("[IPC] LockScreen show() called");
        shellRoot.lockScreen.locked = true;
    }

    function toggleClipboard(): void {
        if (!shellRoot.clipboard) {
            console.warn("ClipboardIpcHandler: clipboard not set!");
            return;
        }
        shellRoot.clipboard.toggle();
    }

    
}
