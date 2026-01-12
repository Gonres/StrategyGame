import QtQuick
import QtQuick.Controls
import "../style" as Style
import "../components"

Item {
    id: menuRoot

    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    Style.Theme {
        id: theme
    }

    signal newGameRequested
    signal settingsRequested

    Column {
        id: column
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Strategy Game"
            color: theme.textPrimary
            font.pixelSize: 40
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Hlavní menu"
            color: theme.textSecondary
            font.pixelSize: 16
        }

        Rectangle {
            width: 1
            height: 18
            color: "transparent"
        }

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
            onClicked: Qt.quit()
        }
    }
}
