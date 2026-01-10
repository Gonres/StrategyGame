import QtQuick
import QtQuick.Controls
import StrategyGame 1.0
import "../style" as Style

ListView {
    id: unitList

    Style.Theme {
        id: theme
    }

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

            Column {
                visible: !modelData.isBuilding
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
                    text: "⟷ Pohyb: " + modelData.movementPoints + " / " + modelData.movementRange
                    color: theme.statMove
                    font.pixelSize: 12
                }

                Text {
                    text: "🗡 Útok v tahu: " + (modelData.hasAttacked ? "už použit" : "dostupný")
                    color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                    font.pixelSize: 12
                }
            }

            Row {
                visible: modelData.unitType === UnitType.Stronghold
                Button {
                    highlighted: controller.action.mode === ActionMode.Build
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Kasárny")
                    width: 25
                    onPressed: {
                        controller.action.mode = ActionMode.Build
                        controller.action.chosenBuildType = UnitType.Barracks
                    }
                }
                // Dalsi budouci budovy
                // Button {
                //     highlighted: controller.action.mode === ActionMode.Build
                //     hoverEnabled: true
                //     ToolTip.visible: hovered
                //     ToolTip.text: qsTr("Stáje")
                //     width: 25
                //     onPressed: {
                //         controller.action.mode = ActionMode.Build
                //         controller.action.chosenBuildType = UnitType.Stables
                //     }
                // }
            }

            Row {
                visible: modelData.unitType === UnitType.Barracks
                Button {
                    highlighted: controller.action.mode === ActionMode.Build
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Válečník")
                    width: 25
                    onPressed: controller.isPlayer1Turn ? controller.unitRepository.addPlayer1Unit(
                                                              UnitType.Warrior,
                                                              Qt.point(
                                                                  modelData.position.x,
                                                                  modelData.position.y + 1)) : controller.unitRepository.addPlayer2Unit(
                                                              UnitType.Warrior,
                                                              Qt.point(
                                                                  modelData.position.x,
                                                                  modelData.position.y - 1))
                }
            }
        }
    }
}
