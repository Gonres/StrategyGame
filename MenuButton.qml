// MenuButton.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    property alias text: label.text
    signal clicked()

    width: 260
    height: 48
    radius: 12

    color: mouseArea.pressed
           ? "#1d4ed8"
           : (mouseArea.containsMouse ? "#2563eb" : "#111827")

    border.color: "#38bdf8"
    border.width: 1

    opacity: enabled ? 1.0 : 0.45

    Text {
        id: label
        anchors.centerIn: parent
        text: "Button"
        color: "white"
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
