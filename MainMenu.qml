// MainMenu.qml
import QtQuick
import QtQuick.Controls

Item {
    id: menuRoot
    width: 320
    height: column.implicitHeight

    // signály pro Main.qml
    signal newGameRequested()
    signal settingsRequested()
    signal quitRequested()

    Column {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 14

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Strategy Game"
            color: "white"
            font.pixelSize: 40
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Hlavní menu"
            color: "#9ca3af"
            font.pixelSize: 16
        }

        Rectangle { width: 1; height: 18; color: "transparent" }

        MenuButton {
            text: "Nová hra"
            onClicked: menuRoot.newGameRequested()
        }

        MenuButton {
            text: "Nastavení"
            onClicked: menuRoot.settingsRequested()
        }

        MenuButton {
            text: "Ukončit hru"
            onClicked: menuRoot.quitRequested()
        }
    }
}
