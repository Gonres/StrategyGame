import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../style" as Style

Item {
    id: mapContainer
    signal backRequested

    Style.Theme { id: theme }

    property int baseTileSize: 35
    property int minTileSize: 20

    // symetrické boční panely
    property int sidePanelWidth: 300
    property int messageBarHeight: 48

    property var selectedUnit:
        controller.action.selectedUnits.length > 0
            ? controller.action.selectedUnits[0]
            : null

    property bool gameOver: controller.winnerText !== ""
    property string winnerText: controller.winnerText
    property string lastMoveMessage: ""

    Timer {
        interval: 3000
        onTriggered: lastMoveMessage = ""
    }

    Connections {
        target: controller.action
        function onActionMessage(msg) {
            lastMoveMessage = msg
        }
    }

    // =====================================================
    // POZADÍ
    // =====================================================
    Rectangle {
        anchors.fill: parent
        color: theme.mapBackground
        z: 0
    }

    // =====================================================
    // BAREVNÝ RÁM PODLE HRÁČE
    // =====================================================
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "transparent"
        border.width: 4
        border.color: controller.isPlayer1Turn
                      ? theme.unitP1
                      : theme.unitP2
        z: 1
    }

    // =====================================================
    // HLAVNÍ LAYOUT
    // =====================================================
    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8
        z: 5

        // =================================================
        // LEVÝ PANEL
        // =================================================
        Rectangle {
            Layout.preferredWidth: sidePanelWidth
            Layout.fillHeight: true
            radius: 12
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Column {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                MenuButton {
                    text: "Ukončit hru"
                    onClicked: backRequested()
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: theme.panelBorder
                }

                Text {
                    text: controller.isPlayer1Turn
                          ? "Hraje: Hráč 1"
                          : "Hraje: Hráč 2"
                    color: theme.textMuted
                    font.pixelSize: 14
                }

                Item { Layout.fillHeight: true }
            }
        }

        // =================================================
        // STŘED – MAPA
        // =================================================
        Item {
            id: centerArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            property int tileSize: {
                if (!controller.map) return baseTileSize
                let cols = controller.map.columns
                let rows = controller.map.rows

                let reservedH = messageBarHeight
                                + endTurnButton.height
                                + 24

                let availW = width
                let availH = height - reservedH

                let s = Math.min(
                    Math.floor(availW / cols),
                    Math.floor(availH / rows),
                    baseTileSize
                )
                return Math.max(minTileSize, s)
            }

            Column {
                anchors.fill: parent
                spacing: 10

                // =============================================
                // HLÁŠKY – STÁLÉ MÍSTO
                // =============================================
                Rectangle {
                    id: messageBar
                    height: messageBarHeight
                    width: Math.min(parent.width, 720)
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: theme.toastBg
                    opacity: lastMoveMessage.length > 0
                             ? theme.toastOpacity
                             : 0

                    Behavior on opacity {
                        NumberAnimation { duration: 160 }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: lastMoveMessage
                        color: theme.toastText
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // =============================================
                // MAPA
                // =============================================
                Item {
                    id: mapContent
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: controller.map.columns * centerArea.tileSize
                    height: controller.map.rows * centerArea.tileSize

                    Grid {
                        id: mapGrid
                        anchors.fill: parent
                        rows: controller.map.rows
                        columns: controller.map.columns

                        Repeater {
                            model: controller.map.tiles
                            delegate: Rectangle {
                                width: centerArea.tileSize
                                height: centerArea.tileSize
                                color: modelData.color
                                border.width: 1
                                border.color: theme.mapTileBorder
                            }
                        }
                    }

                    // ---------- Reachable highlights ----------
                    Repeater {
                        model: selectedUnit &&
                               (
                                   (controller.action.mode === ActionMode.Move && !selectedUnit.isBuilding) ||
                                   (controller.action.mode === ActionMode.Build && selectedUnit.isBuilding) ||
                                   (controller.action.mode === ActionMode.Train && selectedUnit.isBuilding)
                               )
                               ? controller.action.reachableTiles
                               : []

                        delegate: Item {
                            width: centerArea.tileSize
                            height: centerArea.tileSize
                            x: modelData.x * centerArea.tileSize
                            y: modelData.y * centerArea.tileSize

                            Rectangle {
                                anchors.fill: parent
                                color: theme.reachableTile
                                opacity: 0.45
                                border.width: 2
                                border.color: "#ffffffaa"
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (controller.action.mode === ActionMode.Build) {
                                        controller.isPlayer1Turn
                                            ? controller.unitRepository.addPlayer1Unit(
                                                  controller.action.chosenBuildType,
                                                  Qt.point(modelData.x, modelData.y))
                                            : controller.unitRepository.addPlayer2Unit(
                                                  controller.action.chosenBuildType,
                                                  Qt.point(modelData.x, modelData.y))
                                        controller.action.mode = ActionMode.Move
                                    } else if (controller.action.mode === ActionMode.Train) {
                                        controller.isPlayer1Turn
                                            ? controller.unitRepository.addPlayer1Unit(
                                                  controller.action.chosenTrainType,
                                                  Qt.point(modelData.x, modelData.y))
                                            : controller.unitRepository.addPlayer2Unit(
                                                  controller.action.chosenTrainType,
                                                  Qt.point(modelData.x, modelData.y))
                                        controller.action.mode = ActionMode.Move
                                    }
                                }
                            }
                        }
                    }

                    Repeater {
                        model: controller.unitRepository.player1Units
                        delegate: UnitPiece {
                            unitModel: modelData
                            isPlayer1Unit: true
                            unitColor: theme.unitP1
                            tileSize: centerArea.tileSize
                            mapGridObj: mapGrid
                            gameOver: gameOver
                        }
                    }

                    Repeater {
                        model: controller.unitRepository.player2Units
                        delegate: UnitPiece {
                            unitModel: modelData
                            isPlayer1Unit: false
                            unitColor: theme.unitP2
                            tileSize: centerArea.tileSize
                            mapGridObj: mapGrid
                            gameOver: gameOver
                        }
                    }
                }

                MenuButton {
                    id: endTurnButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Konec kola"
                    enabled: !gameOver
                    onClicked: {
                        controller.action.mode = ActionMode.Move
                        controller.endTurn()
                    }
                }
            }
        }

        // =================================================
        // PRAVÝ PANEL
        // =================================================
        Rectangle {
            Layout.preferredWidth: sidePanelWidth
            Layout.fillHeight: true
            radius: 12
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Item {
                anchors.fill: parent
                anchors.margins: 14

                Text {
                    visible: controller.action.selectedUnits.length === 0
                    anchors.centerIn: parent
                    text: "Vyber jednotku\nna mapě"
                    color: theme.textMuted
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }

                UnitList {
                    visible: controller.action.selectedUnits.length > 0
                    anchors.fill: parent
                }
            }
        }
    }
}
