import QtQuick
import QtQuick.Controls
import "../style" as Style

Item {
    id: settingsRoot

    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    Style.Theme {
        id: theme
    }

    signal backRequested()

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
            text: "Zatím tady nic není"
            color: theme.textSecondary
            font.pixelSize: 16
        }

        Rectangle {
            width: 1
            height: 18
            color: "transparent"
        }

        MenuButton {
            text: "Zpět"
            onClicked: settingsRoot.backRequested()
        }
    }
}
