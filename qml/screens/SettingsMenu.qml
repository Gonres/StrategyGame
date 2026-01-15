import QtQuick
import QtQuick.Controls
import "../style" as Style
import "../components"

Item {
    id: settingsRoot

    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    Style.Theme { id: theme }

    signal backRequested
    signal rulesRequested
    signal unitsRequested
    signal techTreeRequested

    Column {
        id: column
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nastavení"
            color: theme.textPrimary
            font.pixelSize: 32
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Nápověda a informace o hře"
            color: theme.textSecondary
            font.pixelSize: 16
        }

        Rectangle { width: 1; height: 10; color: "transparent" }

        MenuButton {
            text: "Jak se hra hraje"
            onClicked: settingsRoot.rulesRequested()
        }

        MenuButton {
            text: "Vývojový strom"
            onClicked: settingsRoot.techTreeRequested()
        }


        MenuButton {
            text: "Zpět"
            onClicked: settingsRoot.backRequested()
        }
    }
}
