import QtQuick
import QtQuick.Controls
import "../style" as Style

Item {
    id: newGameRoot

    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    Style.Theme {
        id: theme
    }

    signal backRequested()
    signal humanVsHumanRequested()
    signal humanVsBotRequested()

    Column {
        id: column
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nová hra"
            color: theme.textPrimary
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Vyber režim"
            color: theme.textSecondary
            font.pixelSize: 16
        }

        Rectangle {
            width: 1
            height: 18
            color: "transparent"
        }

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
