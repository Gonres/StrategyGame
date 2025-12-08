import QtQuick
import QtQuick.Controls
import "../style" as Style

Rectangle {
    id: root
    property alias text: label.text
    signal clicked()

    Style.Theme {
        id: theme
    }

    width: 260
    height: 48
    radius: 12

    color: mouseArea.pressed
           ? theme.primaryDark
           : (mouseArea.containsMouse ? theme.primary : "#111827")

    border.color: theme.primaryBorder
    border.width: 1
    opacity: enabled ? 1.0 : 0.45

    Text {
        id: label
        anchors.centerIn: parent
        text: "Button"
        color: theme.textPrimary
        font.pixelSize: 18
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
