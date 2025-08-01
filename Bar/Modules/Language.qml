import QtQuick
import QtQuick.Layouts
import "../../Settings/Theme.qml" as MyTheme
import "../../Services/Niri.qml" as Niri

Item {
    id: languageIndicator

    property string language: ""

    Row {
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: languageText
            text: languageIndicator.language
            font.pixelSize: 12
            color: "#FFFFFF" // Default to white
        }
    }

    Component.onCompleted: {
        console.log("Language.qml - Component.onCompleted");
        console.log("Language.qml - Niri.language (onCompleted): " + Niri.language);
        console.log("Language.qml - MyTheme.textPrimary (onCompleted): " + MyTheme.textPrimary);
    }

    Connections {
        target: Niri
        function onLanguageChanged() {
            if (Niri.language !== undefined && Niri.language !== null) {
                languageIndicator.language = Niri.language;
                console.log("Language.qml - Niri.language updated: " + Niri.language);
            }
        }
    }

    Connections {
        target: MyTheme
        function onTextPrimaryChanged() {
            if (MyTheme.textPrimary !== undefined && MyTheme.textPrimary !== null) {
                languageText.color = MyTheme.textPrimary;
                console.log("Language.qml - MyTheme.textPrimary updated: " + MyTheme.textPrimary);
            }
        }
    }
}
