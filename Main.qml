// Main.qml
import QtQuick
import QtQuick.Controls

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    visibility: Window.FullScreen
    title: qsTr("Strategy Game")

    // Pozadí
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0f172a" }
            GradientStop { position: 1.0; color: "#020617" }
        }
    }

    // Správce obrazovek
    StackView {
        id: stack
        anchors.fill: parent

        initialItem: mainMenuComponent
    }

    // ====== Definice obrazovek jako Component ======

    Component {
        id: mainMenuComponent
        MainMenu {
            anchors.centerIn: parent

            onNewGameRequested: {
                stack.push(newGameMenuComponent)
            }

            onSettingsRequested: {
                stack.push(settingsMenuComponent)
            }

            onQuitRequested: {
                Qt.quit()
            }
        }
    }

    Component {
        id: newGameMenuComponent
        NewGameMenu {
            anchors.centerIn: parent

            onBackRequested: {
                stack.pop()
            }

            onHumanVsHumanRequested: {
                console.log("Start: Člověk vs Člověk")
                // tady později spustíš herní scénu
            }

            onHumanVsBotRequested: {
                console.log("Start: Člověk vs Bot")
                // tady později spustíš herní scénu
            }
        }
    }

    Component {
        id: settingsMenuComponent
        SettingsMenu {
            anchors.centerIn: parent

            onBackRequested: {
                stack.pop()
            }
        }
    }
}
