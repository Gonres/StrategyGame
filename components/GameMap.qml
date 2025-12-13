import QtQuick
import QtQuick.Controls
import StrategyGame 1.0

Item {
    id: mapContainer

    signal backRequested

    // velikost jednoho políčka
    property int tileSize: 35

    Rectangle {
        anchors.fill: parent
        color: "#222222"
    }

    MenuButton {
        id: backButton
        text: "Menu / Zpět"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        z: 10

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
                border.color: "#111111"
            }
        }
    }

    Column {
        anchors.top: mapGrid.bottom
        anchors.horizontalCenter: mapGrid.horizontalCenter
        anchors.topMargin: 100
        spacing: 16

        Text {
            text: controller.isPlayer1Turn ? "Hraje hráč 1" : "Hraje hráč 2"
            font.pixelSize: 32
            color: theme.textPrimary
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MenuButton {
            id: endTurnButton
            text: "Ukončit tah"
            onClicked: controller.endTurn()
        }
    }

    property int middleRow: controller.map ? Math.floor(
                                                 controller.map.rows / 2) : 0
    property int lastColumn: controller.map ? controller.map.columns - 1 : 0

    Repeater {
        model: controller.player1Units
        delegate: Rectangle {
            id: p1Unit
            width: mapContainer.tileSize
            height: mapContainer.tileSize
            radius: 6
            color: "red"
            border.width: 3
            border.color: modelData.unitSelected ? "darkGreen" : "white"
            visible: true

            x: mapGrid.x + (modelData ? modelData.position.x * mapContainer.tileSize : 0)
            y: mapGrid.y + (modelData ? modelData.position.y * mapContainer.tileSize : 0)
            z: 5

            Behavior on x {
                NumberAnimation {
                    duration: 200
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (controller.isPlayer1Turn) {
                        controller.clearSelection()
                        controller.addToSelection(modelData)
                    }
                }
            }
        }
    }

    Repeater {
        model: controller.player2Units
        delegate: Rectangle {
            id: p2Unit
            width: mapContainer.tileSize
            height: mapContainer.tileSize
            radius: 6
            color: "blue"
            border.width: 3
            border.color: modelData.unitSelected ? "darkGreen" : "white"
            visible: true

            x: mapGrid.x + (modelData ? modelData.position.x * mapContainer.tileSize : 0)
            y: mapGrid.y + (modelData ? modelData.position.y * mapContainer.tileSize : 0)
            z: 5

            Behavior on x {
                NumberAnimation {
                    duration: 200
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (!controller.isPlayer1Turn) {
                        controller.clearSelection()
                        controller.addToSelection(modelData)
                    }
                }
            }
        }
    }

    SelectionArea {
        id: selectionHandler
        anchors.fill: mapGrid
        onSelectionCompleted: (x, y, width, height) => {
                                  if (width < 2 && height < 2) {
                                      return
                                  }
                                  controller.clearSelection()
                                  var startCol = Math.floor(
                                      x / mapContainer.tileSize)
                                  var startRow = Math.floor(
                                      y / mapContainer.tileSize)
                                  var endCol = Math.floor(
                                      (x + width) / mapContainer.tileSize)
                                  var endRow = Math.floor(
                                      (y + height) / mapContainer.tileSize)

                                  var selectIfInArea = function (unitList) {
                                      for (var i = 0; i < unitList.length; i++) {
                                          var unit = unitList[i]
                                          if (unit.position.x >= startCol
                                                  && unit.position.x <= endCol
                                                  && unit.position.y >= startRow
                                                  && unit.position.y <= endRow) {
                                              controller.addToSelection(unit)
                                          }
                                      }
                                  }
                                  if (controller.isPlayer1Turn) {
                                      selectIfInArea(controller.player1Units)
                                  } else {
                                      selectIfInArea(controller.player2Units)
                                  }
                              }
        onRightChanged: (x, y) => {
                            var col = Math.floor(x / mapContainer.tileSize)
                            var row = Math.floor(y / mapContainer.tileSize)
                            console.log("Moved to grid:", col, row)
                            controller.moveSelectedUnits(col, row)
                        }
    }

    Rectangle {
        id: unitInfoPanel
        width: 260
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 16
        radius: 8
        color: "#333333"
        border.width: 1
        border.color: "#777777"
        z: 20
        visible: controller.selectedUnits.length > 0

        ListView {
            id: unitList
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            clip: true
            spacing: 8
            model: controller.selectedUnits
            delegate: Rectangle {
                width: unitList.width
                height: 85
                color: "#444444"
                radius: 4
                border.width: 1
                border.color: "#555"

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.color = "#505050"
                    onExited: parent.color = "#444444"
                }

                Column {
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 4

                    Text {
                        text: modelData.unitTypeName
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                    }

                    Text {
                        text: "❤ Životy: " + modelData.health + " / " + modelData.maxHealth
                        color: "#FFAAAA"
                        font.pixelSize: 14
                    }

                    Row {
                        spacing: 15
                        Text {
                            text: "⚔ Útok: " + modelData.attackDamage
                            color: "#AAAAFF"
                            font.pixelSize: 12
                        }
                        Text {
                            text: "➶ Dosah útoku: " + modelData.attackRange
                            color: "#AAFFAA"
                            font.pixelSize: 12
                        }
                    }

                    Text {
                        text: "⟷ Pohyb: " + modelData.movementRange
                        color: "#FFFF00"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
