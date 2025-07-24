import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Components

IpcHandler {
    target: "globalIPC"

    signal toggleLauncherRequested()
    signal toggleLockRequested()
    signal toggleClipboardRequested()

    // Toggle Applauncher visibility
    function toggleLauncher(): void {
        console.log("[IPC] toggleLauncher called, emitting signal");
        toggleLauncherRequested();
    }

    // Toggle LockScreen
    function toggleLock(): void {
        console.log("[IPC] toggleLock called, emitting signal");
        toggleLockRequested();
    }

    function toggleClipboard(): void {
        console.log("[IPC] toggleClipboard called, emitting signal");
        toggleClipboardRequested();
    }

    
}
