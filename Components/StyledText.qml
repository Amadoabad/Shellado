import QtQuick
import qs.Settings
import qs.Services

Text {
    id: root

    property bool isMonospace: false

    color: Theme.surfaceText
    font.pixelSize: Appearance.fontSize.normal
    font.family: {
        var requestedFont = isMonospace ? Prefs.monoFontFamily : Prefs.fontFamily;
        var defaultFont = isMonospace ? Prefs.defaultMonoFontFamily : Prefs.defaultFontFamily;
        if (requestedFont === defaultFont) {
            var availableFonts = Qt.fontFamilies();
            if (!availableFonts.includes(requestedFont))
                return isMonospace ? "Monospace" : "DejaVu Sans";

        }
        return requestedFont;
    }
    font.weight: Prefs.fontWeight
    wrapMode: Text.WordWrap
    elide: Text.ElideRight
    verticalAlignment: Text.AlignVCenter
    antialiasing: true

    Behavior on color {
        ColorAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }

    }

    Behavior on opacity {
        NumberAnimation {
            duration: Appearance.anim.durations.normal
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }

    }

}