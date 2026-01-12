import QtQuick
import QtQuick.Controls
import "../style" as Style

Rectangle {
    id: root

    property alias text: label.text

    // aby šlo použít i jako "výběrové" tlačítko v NewGameMenu
    property bool checkable: false
    property bool checked: false

    signal clicked

    Style.Theme { id: theme }

    width: 260
    height: 48
    radius: 12

    // barva podle stavu
    color: checked
           ? theme.primaryDark
           : (mouseArea.pressed
              ? theme.primaryDark
              : (mouseArea.containsMouse ? theme.primary : "#111827"))

    border.color: checked ? theme.primaryBorder : theme.primaryBorder
    border.width: checked ? 2 : 1
    opacity: enabled ? 1.0 : 0.45

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

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
