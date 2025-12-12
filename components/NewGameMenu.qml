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

    signal backRequested
    signal humanVsHumanRequested
    signal humanVsBotRequested

    Column {
        anchors.centerIn: parent
        spacing: 16

        Text {
            text: "Nová hra"
            font.pixelSize: 32
            color: theme.textPrimary
            horizontalAlignment: Text.AlignHCenter
            width: 400
        }

        // Člověk proti člověku
        MenuButton {
            text: "Člověk proti člověku"
            onClicked: {
                controller.startGame()
                newGameRoot.humanVsHumanRequested()
            }
        }

        // Člověk vs Bot
        MenuButton {
            text: "Člověk vs Bot"
            onClicked: newGameRoot.humanVsBotRequested()
        }

        // Zpět
        MenuButton {
            text: "Zpět"
            onClicked: newGameRoot.backRequested()
        }
    }
}
