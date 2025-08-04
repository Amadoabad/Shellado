import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.Settings
import qs.Components

PanelWithOverlay {
    id: clipboardHistory

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    function showAt() {
        clipboardPanelRect.showAt();
    }

    function hidePanel() {
        clipboardPanelRect.hidePanel();
    }

    function toggle() {
        if (clipboardHistory.visible) {
            hidePanel();
        } else {
            showAt();
        }
    }

    Rectangle {
        id: clipboardPanelRect
        implicitWidth: 500
        implicitHeight: 640
        color: "transparent"
        visible: parent.visible
        property bool shouldBeVisible: false
        anchors.centerIn: parent

        function showAt() {
            clipboardHistory.visible = true;
            shouldBeVisible = true;
            searchField.forceActiveFocus();
            root.refreshClipboard();
        }

        function hidePanel() {
            shouldBeVisible = false;
            searchField.text = "";
        }

        Rectangle {
            id: root
            width: 500
            height: 640
            x: (parent.width - width) / 2
            color: Theme.surface
            radius: 20
            border.color: Qt.rgba(Theme.outline.r, Theme.outline.g, Theme.outline.b, 0.5)
            border.width: 1

            property int totalCount: 0
            property bool showClearConfirmation: false
            property var clipboardEntries: []
            property int selectedIndex: 0

            property int targetY: (parent.height - height) / 2
            y: clipboardPanelRect.shouldBeVisible ? targetY : -height
            Behavior on y {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
            scale: clipboardPanelRect.shouldBeVisible ? 1 : 0
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutCubic
                }
            }
            onScaleChanged: {
                if (scale === 0 && !clipboardPanelRect.shouldBeVisible) {
                    clipboardHistory.visible = false;
                }
            }

            ListModel { id: clipboardModel }
            ListModel { id: filteredClipboardModel }

            function updateFilteredModel() {
                filteredClipboardModel.clear();
                for (let i = 0; i < clipboardModel.count; i++) {
                    const entry = clipboardModel.get(i).entry;
                    if (searchField.text.trim().length === 0) {
                        filteredClipboardModel.append({ "entry": entry });
                    } else {
                        const content = getEntryPreview(entry).toLowerCase();
                        if (content.includes(searchField.text.toLowerCase()))
                            filteredClipboardModel.append({ "entry": entry });
                    }
                }
                root.totalCount = filteredClipboardModel.count;
                root.selectedIndex = 0;
            }

            function refreshClipboard() {
                clipboardProcess.running = true;
            }

            function selectNext() {
                if (filteredClipboardModel.count > 0)
                    root.selectedIndex = Math.min(root.selectedIndex + 1, filteredClipboardModel.count - 1);
            }

            function selectPrev() {
                if (filteredClipboardModel.count > 0)
                    root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
            }

            function activateSelected() {
                if (filteredClipboardModel.count === 0) return;
                var entry = filteredClipboardModel.get(root.selectedIndex).entry;
                copyEntry(entry);
            }

            function copyEntry(entry) {
                const entryId = entry.split('\t')[0];
                copyProcess.command = ["sh", "-c", `cliphist decode ${entryId} | wl-copy`];
                copyProcess.running = true;
                hidePanel();
            }

            function deleteEntry(entry) {
                deleteProcess.command = ["sh", "-c", `echo '${entry.replace(/'/g, "'\\''")}' | cliphist delete`];
                deleteProcess.running = true;
            }

            function clearAll() {
                clearProcess.running = true;
            }

            function getEntryPreview(entry) {
                let content = entry.replace(/^\s*\d+\s+/, "");
                if (content.includes("image/") || content.includes("binary data") || /\.(png|jpg|jpeg|gif|bmp|webp)/i.test(content)) {
                    const dimensionMatch = content.match(/(\d+)x(\d+)/);
                    if (dimensionMatch) return `Image ${dimensionMatch[1]}×${dimensionMatch[2]}`;
                    const typeMatch = content.match(/\b(png|jpg|jpeg|gif|bmp|webp)\b/i);
                    if (typeMatch) return `Image (${typeMatch[1].toUpperCase()})`;
                    return "Image";
                }
                if (content.length > 100) return content.substring(0, 100) + "...";
                return content;
            }

            function getEntryType(entry) {
                if (entry.includes("image/") || entry.includes("binary data") || /\.(png|jpg|jpeg|gif|bmp|webp)/i.test(entry) || /\b(png|jpg|jpeg|gif|bmp|webp)\b/i.test(entry)) return "image";
                if (entry.length > 200) return "long_text";
                return "text";
            }

            ColumnLayout {
                id: headerSection
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 32
                spacing: 18

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40

                    Text {
                        id: titleText
                        text: "Clipboard History" + (root.totalCount > 0 ? ` (${root.totalCount})` : "")
                        font.pixelSize: 20
                        font.bold: true
                        color: Theme.textPrimary
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item { Layout.fillWidth: true }

                    IconButton {
                        icon: "edit_note"
                        onClicked: { root.showClearConfirmation = true; }
                        visible: root.totalCount > 0
                        Layout.alignment: Qt.AlignVCenter
                    }

                    IconButton {
                        icon: "close"
                        onClicked: { hidePanel(); }
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                Rectangle {
                    id: searchBar
                    color: Theme.surfaceVariant
                    radius: 22
                    height: 48
                    Layout.fillWidth: true
                    border.color: searchField.activeFocus ? Theme.accentPrimary : Theme.outline
                    border.width: searchField.activeFocus ? 2 : 1

                    RowLayout {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10
                        Text {
                            text: "search"
                            font.family: "Material Symbols Outlined"
                            font.pixelSize: Theme.fontSizeHeader
                            color: searchField.activeFocus ? Theme.accentPrimary : Theme.textSecondary
                            verticalAlignment: Text.AlignVCenter
                            Layout.alignment: Qt.AlignVCenter
                        }
                        TextField {
                            id: searchField
                            placeholderText: "Search clipboard..."
                            color: Theme.textPrimary
                            placeholderTextColor: Theme.textSecondary
                            background: null
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeBody
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            onTextChanged: root.updateFilteredModel()
                            selectedTextColor: Theme.onAccent
                            selectionColor: Theme.accentPrimary
                            padding: 0
                            verticalAlignment: TextInput.AlignVCenter
                            leftPadding: 0
                            rightPadding: 0
                            topPadding: 0
                            bottomPadding: 0
                            font.bold: true
                            Component.onCompleted: contentItem.cursorColor = Theme.textPrimary
                            onActiveFocusChanged: contentItem.cursorColor = Theme.textPrimary

                            Keys.onDownPressed: root.selectNext()
                            Keys.onUpPressed: root.selectPrev()
                            Keys.onEnterPressed: root.activateSelected()
                            Keys.onReturnPressed: root.activateSelected()
                            Keys.onEscapePressed: hidePanel()
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 120
                        }
                    }
                    Behavior on border.width {
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }
            }

            Rectangle {
                anchors.top: headerSection.bottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 32
                anchors.topMargin: 18
                color: Theme.surface
                radius: 20
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                property int innerPadding: 16

                ScrollView {
                    anchors.fill: parent
                    clip: true
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    ListView {
                        id: clipboardList
                        model: filteredClipboardModel
                        currentIndex: root.selectedIndex
                        spacing: 8

                        delegate: Rectangle {
                            property string entryType: root.getEntryType(model.entry || '')
                            property string entryPreview: root.getEntryPreview(model.entry || '')
                            property int entryIndex: index + 1
                            property bool isSelected: index === root.selectedIndex

                            width: clipboardList.width - 16
                            height: Math.max(60, contentColumn.implicitHeight + 16)
                            radius: 8
                            color: entryArea.containsMouse || isSelected ? Theme.surfaceVariant : Theme.surface
                            border.color: isSelected ? Theme.accentPrimary : Theme.outline
                            border.width: isSelected ? 2 : 1

                            Row {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 16

                                Rectangle {
                                    width: 24
                                    height: 24
                                    radius: 12
                                    color: Theme.accentPrimary
                                    anchors.verticalCenter: parent.verticalCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: entryIndex.toString()
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: Theme.onAccent
                                    }
                                }

                                Row {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - 80
                                    spacing: 12

                                    Rectangle {
                                        property string entryId: model.entry ? model.entry.split('\t')[0] : ""
                                        property string tempImagePath: "/tmp/clipboard_preview_" + entryId + ".png"
                                        width: entryType === "image" ? 48 : 0
                                        height: entryType === "image" ? 36 : 0
                                        radius: 4
                                        color: Theme.surfaceVariant
                                        border.color: Theme.outline
                                        border.width: 1
                                        visible: entryType === "image"
                                        clip: true

                                        Image {
                                            id: imagePreview
                                            anchors.fill: parent
                                            anchors.margins: 1
                                            fillMode: Image.PreserveAspectCrop
                                            asynchronous: true
                                            cache: false
                                            source: parent.entryType === "image" && parent.entryId ? "file://" + parent.tempImagePath : ""
                                            Component.onCompleted: {
                                                if (parent.entryType === "image" && parent.entryId) {
                                                    imageDecodeProcess.entryId = parent.entryId;
                                                    imageDecodeProcess.tempPath = parent.tempImagePath;
                                                    imageDecodeProcess.imagePreview = imagePreview;
                                                    imageDecodeProcess.command = ["sh", "-c", `cliphist decode ${parent.entryId} > "${parent.tempImagePath}" 2>/dev/null`];
                                                    imageDecodeProcess.running = true;
                                                }
                                            }
                                        }
                                    }

                                    Column {
                                        id: contentColumn
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - (entryType === "image" ? 60 : 0)
                                        spacing: 4

                                        Text {
                                            text: {
                                                switch (entryType) {
                                                case "image": return "Image • " + entryPreview;
                                                case "long_text": return "Long Text";
                                                default: return "Text";
                                                }
                                            }
                                            font.pixelSize: 12
                                            color: Theme.accentPrimary
                                            font.bold: true
                                            width: parent.width
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: entryPreview
                                            font.pixelSize: 14
                                            color: Theme.textPrimary
                                            width: parent.width
                                            wrapMode: Text.WordWrap
                                            maximumLineCount: entryType === "long_text" ? 3 : 1
                                            elide: Text.ElideRight
                                            visible: true
                                        }
                                    }
                                }

                                IconButton {
                                    anchors.verticalCenter: parent.verticalCenter
                                    icon: "delete"
                                    onClicked: { root.deleteEntry(model.entry); }
                                }
                            }

                            MouseArea {
                                id: entryArea
                                anchors.fill: parent
                                anchors.rightMargin: 40
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.copyEntry(model.entry)
                            }
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 16
                        visible: root.totalCount === 0

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "content_paste_off"
                            font.family: "Material Icons"
                            font.pixelSize: 48
                            color: Theme.textDisabled
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "No clipboard history"
                            font.pixelSize: 16
                            color: Theme.textSecondary
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Copy something to see it here"
                            font.pixelSize: 14
                            color: Theme.textDisabled
                        }
                    }
                }
            }

            Corners {
                id: launcherCornerRight
                position: "bottomleft"
                size: 1.1
                fillColor: Theme.surface
                anchors.top: root.top
                offsetX: 416
                offsetY: 0
            }

            Corners {
                id: launcherCornerLeft
                position: "bottomright"
                size: 1.1
                fillColor: Theme.surface
                anchors.top: root.top
                offsetX: -416
                offsetY: 0
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.4)
                visible: root.showClearConfirmation
                z: 999
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.showClearConfirmation = false
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 350
                height: 200
                radius: 12
                color: Theme.backgroundSecondary
                border.color: Theme.outline
                border.width: 1
                visible: root.showClearConfirmation
                z: 1000

                Column {
                    anchors.centerIn: parent
                    spacing: 16
                    width: parent.width - 40

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "warning"
                        font.family: "Material Icons"
                        font.pixelSize: 32
                        color: Theme.error
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Clear All Clipboard History?"
                        font.pixelSize: 16
                        font.bold: true
                        color: Theme.textPrimary
                        horizontalAlignment: Text.AlignHCenter
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "This action cannot be undone. All clipboard entries will be permanently deleted."
                        font.pixelSize: 14
                        color: Theme.textSecondary
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 12
                        Button {
                            text: "Cancel"
                            onClicked: { root.showClearConfirmation = false; }
                        }
                        Button {
                            text: "Clear All"
                            onClicked: {
                                root.showClearConfirmation = false;
                                root.clearAll();
                            }
                        }
                    }
                }
            }
        }
    }

    Process { id: cleanupProcess; running: false }
    Process {
        id: imageDecodeProcess
        property string entryId: ""
        property string tempPath: ""
        property var imagePreview: null
        running: false
        onExited: (exitCode) => {
            if (exitCode === 0 && imagePreview && tempPath)
                Qt.callLater(function() {
                    imagePreview.source = "";
                    imagePreview.source = "file://" + tempPath;
                });
        }
    }
    Process {
        id: clipboardProcess
        command: ["cliphist", "list"]
        running: false
        onStarted: {
            root.clipboardEntries = [];
            clipboardModel.clear();
        }
        onExited: (exitCode) => {
            if (exitCode === 0) root.updateFilteredModel();
        }
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: (line) => {
                if (line.trim()) {
                    root.clipboardEntries.push(line);
                    clipboardModel.append({ "entry": line });
                }
            }
        }
    }
    Process { id: copyProcess; running: false }
    Process {
        id: deleteProcess
        running: false
        onExited: (exitCode) => { if (exitCode === 0) root.refreshClipboard(); }
    }
    Process {
        id: clearProcess
        command: ["cliphist", "wipe"]
        running: false
        onExited: (exitCode) => {
            if (exitCode === 0) {
                root.clipboardEntries = [];
                clipboardModel.clear();
                root.updateFilteredModel();
            }
        }
    }

    IpcHandler {
        target: "clipboard"
        function open() {
            showAt();
            return "CLIPBOARD_OPEN_SUCCESS";
        }
        function close() {
            hidePanel();
            return "CLIPBOARD_CLOSE_SUCCESS";
        }
        function toggle() {
            clipboardHistory.toggle();
            return "CLIPBOARD_TOGGLE_SUCCESS";
        }
    }
}