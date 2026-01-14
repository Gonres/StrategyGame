import QtQuick
import QtQuick.Controls
import "../style" as Style
import "../components"

Item {
    id: menuRoot

    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    Style.Theme { id: theme }

    signal startRequested(int playerCount, int startGold)
    signal backRequested

    // 0 = výběr hráčů, 1 = výběr rozpočtu
    property int step: 0
    property int selectedPlayerCount: 2

    Column {
        id: column
        spacing: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        // ===== HLAVIČKA (STEJNÁ JAKO MAIN MENU) =====
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Strategy Game"
            color: theme.textPrimary
            font.pixelSize: 40
            font.bold: true
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: step === 0
                  ? "Kolik vás bude hrát"
                  : "Vyberte rozpočet na hru"
            color: theme.textSecondary
            font.pixelSize: 16
        }

        Rectangle {
            width: 1
            height: 18
            color: "transparent"
        }

        // =================================================
        // STEP 0 – VÝBĚR POČTU HRÁČŮ
        // =================================================
        Column {
            visible: step === 0
            spacing: 14
            anchors.horizontalCenter: parent.horizontalCenter

            MenuButton {
                text: "1 vs 1"
                onClicked: {
                    selectedPlayerCount = 2
                    step = 1
                }
            }

            MenuButton {
                text: "1 vs 1 vs 1"
                onClicked: {
                    selectedPlayerCount = 3
                    step = 1
                }
            }

            MenuButton {
                text: "1 vs 1 vs 1 vs 1"
                onClicked: {
                    selectedPlayerCount = 4
                    step = 1
                }
            }

            MenuButton {
                text: "Zpět"
                onClicked: menuRoot.backRequested()
            }
        }

        // =================================================
        // STEP 1 – VÝBĚR ROZPOČTU
        // =================================================
        Column {
            visible: step === 1
            spacing: 14
            anchors.horizontalCenter: parent.horizontalCenter

            MenuButton {
                text: "300 gold"
                onClicked: menuRoot.startRequested(selectedPlayerCount, 300)
            }

            MenuButton {
                text: "500 gold"
                onClicked: menuRoot.startRequested(selectedPlayerCount, 500)
            }

            MenuButton {
                text: "1000 gold"
                onClicked: menuRoot.startRequested(selectedPlayerCount, 1000)
            }

            MenuButton {
                text: "Zpět"
                onClicked: step = 0
            }
        }
    }
}
