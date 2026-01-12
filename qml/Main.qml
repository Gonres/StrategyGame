import QtQuick
import QtQuick.Controls
import "components" as Comp
import "screens" as Screens
import "style" as Style

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    visibility: Window.FullScreen
    title: qsTr("Strategy Game")

    Style.Theme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: theme.bgTop
            }
            GradientStop {
                position: 1
                color: theme.bgBottom
            }
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        focus: true
        initialItem: mainMenuComponent

        pushEnter: Transition {
            NumberAnimation {
                properties: "x"
                from: stack.width
                to: 0
                duration: 220
                easing.type: Easing.InOutQuad
            }
        }

        pushExit: Transition {
            NumberAnimation {
                properties: "x"
                from: 0
                to: -stack.width * 0.25
                duration: 180
                easing.type: Easing.InOutQuad
            }
        }

        popEnter: Transition {
            NumberAnimation {
                properties: "x"
                from: -stack.width * 0.25
                to: 0
                duration: 220
                easing.type: Easing.InOutQuad
            }
        }

        popExit: Transition {
            NumberAnimation {
                properties: "x"
                from: 0
                to: stack.width
                duration: 180
                easing.type: Easing.InOutQuad
            }
        }
    }

    Component {
        id: mainMenuComponent
        Screens.MainMenu {
            onNewGameRequested: stack.push(newGameMenuComponent)
            onSettingsRequested: stack.push(settingsMenuComponent)
        }
    }

    Component {
        id: newGameMenuComponent
        Screens.NewGameMenu {
            onBackRequested: stack.pop()
            onHumanVsHumanRequested: {
                controller.startGame()
                stack.push(gameScreenComponent)
            }
            onHumanVsBotRequested: console.log("Start: Human vs Bot")
        }
    }

    Component {
        id: settingsMenuComponent
        Screens.SettingsMenu {
            onBackRequested: stack.pop()
        }
    }

    Component {
        id: gameScreenComponent
        Comp.GameMap {
            onBackRequested: {
                stack.pop()
                controller.stopGame()
            }
        }
    }
}
