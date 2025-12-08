// NewGameMenu.qml
import QtQuick
import QtQuick.Controls

Item {
    id: newGameRoot
    width: 320
    height: column.implicitHeight

    signal backRequested()
    signal humanVsHumanRequested()
    signal humanVsBotRequested()

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 14

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nová hra"
            color: "white"
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Vyber režim"
            color: "#9ca3af"
            font.pixelSize: 16
        }

        Rectangle { width: 1; height: 18; color: "transparent" }

        MenuButton {
            text: "Člověk vs Člověk"
            onClicked: newGameRoot.humanVsHumanRequested()
        }

        MenuButton {
            text: "Člověk vs Bot"
            onClicked: newGameRoot.humanVsBotRequested()
        }

        MenuButton {
            text: "Zpět"
            onClicked: newGameRoot.backRequested()
        }
    }
}
