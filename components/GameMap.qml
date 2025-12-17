import QtQuick
import QtQuick.Controls
import StrategyGame 1.0
import "../style" as Style

Item {
    id: mapContainer
    signal backRequested

    property int tileSize: 35
    property string actionMode: "move" // "move" | "attack"
    property var selectedUnit: (controller.action.selectedUnits.length
                                > 0 ? controller.action.selectedUnits[0] : null)
    property bool hasMovePoints: (selectedUnit !== null
                                  && selectedUnit.movementPoints > 0)

    property bool gameOver: controller.winnerText !== ""
    property string winnerText: controller.winnerText
    property string lastMoveMessage: ""

    Timer {
        id: messageTimer
        interval: 3000
        onTriggered: controller.action.lastMoveMessage = ""
    }

    Connections {
        target: controller.action
        function onActionMessage(msg) {
            mapContainer.lastMoveMessage = msg
            messageTimer.restart()
        }
    }

    Style.Theme {
        id: theme
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: theme.mapBackground
    }

    // reaguj na změny jednotek -> výhra
    Connections {
        target: controller.unitRepository
        function onPlayer1UnitsChanged() {
            controller.checkVictory()
        }
        function onPlayer2UnitsChanged() {
            controller.checkVictory()
        }
    }

    MenuButton {
        id: backButton
        text: "Menu / Zpět"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        z: 80
        enabled: !gameOver
        onClicked: mapContainer.backRequested()
    }

    Grid {
        id: mapGrid
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rows: controller.map ? controller.map.rows : 0
        columns: controller.map ? controller.map.columns : 0
        rowSpacing: 0
        columnSpacing: 0

        Repeater {
            model: controller.map ? controller.map.tiles : []
            delegate: Rectangle {
                width: mapContainer.tileSize
                height: mapContainer.tileSize
                color: modelData.color
                border.width: 1
                border.color: theme.mapTileBorder
            }
        }

        // FUTURE HIGHLIGHTING
        // Repeater {
        //     model: (mapContainer.selectedUnit && mapContainer.actionMode === "move") ? controller.action.reachableTiles() : []
        //     delegate: Rectangle {
        //         width: mapContainer.tileSize
        //         height: mapContainer.tileSize
        //         color: theme.reachableTile
        //         opacity: 0.4
        //         x: modelData.x * mapContainer.tileSize
        //         y: modelData.y * mapContainer.tileSize
        //         z: 10
        //     }
        // }
    }

    // info panel jednotek
    Rectangle {
        id: unitInfoPanel
        width: 280
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 16
        radius: 10
        color: theme.panelBg
        border.width: 1
        border.color: theme.panelBorder
        z: 70
        visible: controller.action.selectedUnits.length > 0

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Row {
                spacing: 8

                Button {
                    text: "Pohyb 🥾"
                    width: 124
                    height: 40
                    checkable: true
                    checked: actionMode === "move"
                    enabled: !gameOver
                    onClicked: actionMode = "move"

                    background: Rectangle {
                        radius: 8
                        color: parent.checked ? theme.buttonActive : theme.buttonBg
                        border.width: 1
                        border.color: parent.checked ? theme.buttonActiveBorder : theme.buttonBorder
                    }
                    contentItem: Text {
                        text: parent.text
                        color: theme.buttonText
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    text: "Útok 🗡"
                    width: 124
                    height: 40
                    checkable: true
                    checked: actionMode === "attack"
                    enabled: !gameOver
                             && (selectedUnit !== null ? !selectedUnit.hasAttacked : false)
                    onClicked: actionMode = "attack"

                    background: Rectangle {
                        radius: 8
                        color: parent.checked ? theme.buttonDanger : theme.buttonBg
                        border.width: 1
                        border.color: parent.checked ? theme.buttonDangerBorder : theme.buttonBorder
                    }
                    contentItem: Text {
                        text: parent.text
                        color: theme.buttonText
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            ListView {
                id: unitList
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height
                clip: true
                spacing: 10
                model: controller.action.selectedUnits

                delegate: Rectangle {
                    width: unitList.width
                    height: 110
                    color: theme.cardBg
                    radius: 8
                    border.width: 1
                    border.color: theme.cardBorder

                    Column {
                        anchors.centerIn: parent
                        width: parent.width - 18
                        spacing: 5

                        Text {
                            text: modelData.unitTypeName
                            color: theme.textPrimary
                            font.bold: true
                            font.pixelSize: 16
                        }

                        Text {
                            text: "❤ Životy: " + modelData.health + " / " + modelData.maxHealth
                            color: theme.statHealth
                            font.pixelSize: 13
                        }

                        Row {
                            spacing: 12
                            Text {
                                text: "⚔ Útok: " + modelData.attackDamage
                                color: theme.statAttack
                                font.pixelSize: 12
                            }
                            Text {
                                text: "➶ Dosah: " + modelData.attackRange
                                color: theme.statRange
                                font.pixelSize: 12
                            }
                        }

                        Text {
                            text: "⟷ Pohyb: " + modelData.movementPoints + " / "
                                  + modelData.movementRange
                            color: theme.statMove
                            font.pixelSize: 12
                        }

                        Text {
                            text: "🗡 Útok v tahu: "
                                  + (modelData.hasAttacked ? "už použit" : "dostupný")
                            color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }

    Column {
        id: bottomHud
        anchors.top: mapGrid.bottom
        anchors.horizontalCenter: mapGrid.horizontalCenter
        anchors.topMargin: 40
        spacing: 10
        z: 80

        Text {
            text: controller.isPlayer1Turn ? "Hraje hráč 1" : "Hraje hráč 2"
            font.pixelSize: 26
            color: theme.textPrimary
            anchors.horizontalCenter: parent.horizontalCenter
        }

        MenuButton {
            id: endTurnButton
            text: "Ukončit tah"
            enabled: !gameOver
            onClicked: {
                actionMode = "move"
                controller.endTurn()
            }
        }
    }

    // Attack flash přes mapu.
    Rectangle {
        id: mapHitFlash
        anchors.fill: mapGrid
        z: 60
        color: theme.flashAttack
        opacity: 0
        visible: opacity > 0
    }
    SequentialAnimation {
        id: mapHitFlashAnim
        PropertyAnimation {
            target: mapHitFlash
            property: "opacity"
            to: 0.45
            duration: 70
        }
        PropertyAnimation {
            target: mapHitFlash
            property: "opacity"
            to: 0.00
            duration: 220
        }
    }

    // hláška z controlleru
    Rectangle {
        id: toast
        anchors.horizontalCenter: mapGrid.horizontalCenter
        anchors.bottom: mapGrid.top
        anchors.bottomMargin: 16
        radius: 8
        color: theme.toastBg
        opacity: mapContainer.lastMoveMessage.length > 0 ? theme.toastOpacity : 0
        visible: opacity > 0
        z: 90
        width: Math.min(mapGrid.width, 700)
        height: msg.implicitHeight + 16

        Behavior on opacity {
            NumberAnimation { duration: 160 }
        }

        Text {
            id: msg
            anchors.centerIn: parent
            width: parent.width - 24
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            text: mapContainer.lastMoveMessage
            color: theme.toastText
            font.pixelSize: 14
        }
    }

    // GAME OVER overlay
    Rectangle {
        anchors.fill: parent
        z: 200
        visible: gameOver
        color: theme.gameOverOverlay

        Column {
            anchors.centerIn: parent
            spacing: 14

            Text {
                text: winnerText
                color: theme.textPrimary
                font.pixelSize: 34
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "Hra skončila."
                color: theme.textMuted
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            MenuButton {
                text: "Zpět do menu"
                onClicked: mapContainer.backRequested()
            }
        }
    }

    // PLAYER 1 UNITS
    Repeater {
        model: controller.unitRepository.player1Units

        delegate: UnitPiece {
            unitModel: modelData
            isPlayer1Unit: true
            unitColor: theme.unitP1
            tileSize: mapContainer.tileSize
            mapGridObj: mapGrid
            actionMode: mapContainer.actionMode
            gameOver: mapContainer.gameOver

            onAttackSuccess: {
                mapHitFlashAnim.restart()
                controller.checkVictory()
                mapContainer.actionMode = "move"
            }
        }
    }

    // PLAYER 2 UNITS
    Repeater {
        model: controller.unitRepository.player2Units

        delegate: UnitPiece {
            unitModel: modelData
            isPlayer1Unit: false
            unitColor: theme.unitP2
            tileSize: mapContainer.tileSize
            mapGridObj: mapGrid
            actionMode: mapContainer.actionMode
            gameOver: mapContainer.gameOver

            onAttackSuccess: {
                mapHitFlashAnim.restart()
                controller.checkVictory()
                mapContainer.actionMode = "move"
            }
        }
    }
}
