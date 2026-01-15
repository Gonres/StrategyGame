import QtQuick
import QtQuick.Controls
import "../style" as Style

Item {
    id: root

    Style.Theme {
        id: theme
    }

    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height

    property var selectedUnit: controller.action.selectedUnits.length
                               > 0 ? controller.action.selectedUnits[0] : null

    ListView {
        id: unitList

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: destroyBar.top

        clip: true
        spacing: 10
        model: controller.action.selectedUnits

        delegate: Rectangle {
            width: unitList.width
            height: contentCol.implicitHeight + 24

            radius: 16
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Column {
                id: contentCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    color: theme.textPrimary
                    font.pixelSize: 15
                    font.bold: true
                    elide: Text.ElideRight
                }

                Column {
                    spacing: 6

                    Text {
                        text: "📍 Pozice: (" + modelData.position.x + ", "
                              + modelData.position.y + ")"
                        color: theme.textSecondary
                        font.pixelSize: 12
                    }

                    Text {
                        text: "👤 Hráč: " + (modelData.ownerId + 1)
                        color: theme.textSecondary
                        font.pixelSize: 12
                    }

                    Text {
                        text: "💚 Životy: " + modelData.health + " / " + modelData.maxHealth
                        color: theme.statHealth
                        font.pixelSize: 13
                    }
                }

                // Staty jen pro jednotky
                Column {
                    visible: !modelData.isBuilding
                    spacing: 6

                    Row {
                        visible: modelData.unitType !== UnitType.Priest
                        spacing: 12
                        Text {
                            text: "🗡️ Útok: " + modelData.attackDamage
                            color: theme.statAttack
                            font.pixelSize: 12
                        }
                        Text {
                            text: "🎯 Dostřel: " + modelData.attackRange
                            color: theme.statRange
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        visible: modelData.unitType === UnitType.Priest
                        spacing: 12
                        Text {
                            text: "💚 Heal: +200"
                            color: theme.statHealth
                            font.pixelSize: 12
                        }
                        Text {
                            text: "📏 Dosah: " + modelData.attackRange
                            color: theme.statRange
                            font.pixelSize: 12
                        }
                    }

                    Row {
                        spacing: 12
                        Text {
                            text: "👣 Pohyb: " + modelData.movementPoints
                                  + " / " + modelData.movementRange
                            color: theme.statMove
                            font.pixelSize: 12
                        }
                        Text {
                            text: "⚡ Akce v tahu: "
                                  + (modelData.hasAttacked ? "už použitá" : "dostupná")
                            color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                            font.pixelSize: 12
                        }
                    }

                    Text {
                        visible: modelData.unitType === UnitType.Priest
                                 && !modelData.hasAttacked
                                 && controller.action.selectedUnits.length > 0
                                 && controller.action.selectedUnits[0] === modelData
                                 && controller.action.mode === ActionMode.Heal

                        text: "💡 Klikni na spojence v dosahu"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                    }

                    Button {
                        visible: modelData.unitType !== UnitType.Priest
                        text: "🗡️ Útok"
                        height: 46
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && !modelData.hasAttacked
                                 && controller.action.selectedUnits.length > 0
                                 && controller.action.selectedUnits[0] === modelData

                        checked: controller.action.mode === ActionMode.Attack
                        onClicked: {
                            if (controller.action.mode === ActionMode.Attack) {
                                controller.action.mode = ActionMode.Move
                            } else {
                                controller.action.mode = ActionMode.Attack
                            }
                        }
                    }

                    Button {
                        visible: modelData.unitType === UnitType.Priest

                        text: modelData.hasAttacked ? "⛔ Heal už použitý" : "💚 Heal spojence (+15 HP)"

                        height: 46
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && !modelData.hasAttacked
                                 && controller.action.selectedUnits.length > 0
                                 && controller.action.selectedUnits[0] === modelData
                        checked: controller.action.mode === ActionMode.Heal
                        onClicked: {
                            if (controller.action.mode === ActionMode.Heal) {
                                controller.action.mode = ActionMode.Move
                            } else {
                                controller.action.mode = ActionMode.Heal
                            }
                        }
                    }

                    Button {
                        text: "🛌 Odpočinout (+10% HP)"
                        height: 46
                        anchors.left: parent.left
                        anchors.right: parent.right

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && !modelData.hasAttacked
                                 && modelData.health < modelData.maxHealth
                                 && controller.action.selectedUnits.length > 0
                                 && controller.action.selectedUnits[0] === modelData

                        onClicked: {
                            controller.restUnit(modelData)
                            controller.action.mode = ActionMode.Move
                        }
                    }
                }

                Column {
                    visible: modelData.unitType === UnitType.Stronghold
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text {
                        text: "🏗️ Stavění"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 10

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Barracks
                        }

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Stables
                        }

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Bank
                        }

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Church
                        }

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.SiegeWorkshop
                        }
                    }
                }

                Column {
                    visible: modelData.unitType === UnitType.Barracks
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text {
                        text: "🎯 Trénink"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Column {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 10

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Warrior
                        }

                        BuyUnitButton {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            unitType: UnitType.Archer
                        }
                    }
                }

                Column {
                    visible: modelData.unitType === UnitType.Stables
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text {
                        text: "🎯 Trénink"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        font.bold: true
                    }

                    BuyUnitButton {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        unitType: UnitType.Cavalry
                    }
                }

                Column {
                    visible: modelData.unitType === UnitType.Church
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text {
                        text: "🎯 Trénink"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        font.bold: true
                    }

                    BuyUnitButton {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        unitType: UnitType.Priest
                    }
                }

                Column {
                    visible: modelData.unitType === UnitType.SiegeWorkshop
                    spacing: 10
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Text {
                        text: "🎯 Trénink"
                        color: theme.textSecondary
                        font.pixelSize: 12
                        font.bold: true
                    }

                    BuyUnitButton {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        unitType: UnitType.Ram
                    }
                }
            }
        }
    }

    Rectangle {
        id: destroyBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        height: (selectedUnit !== null) ? 62 : 0
        visible: selectedUnit !== null
        color: "transparent"

        Item {
            anchors.fill: parent
            anchors.margins: 8

            Button {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                height: 46

                text: selectedUnit
                      && selectedUnit.isBuilding ? "🗑️ Zničit budovu" : "🗑️ Zničit jednotku"

                enabled: selectedUnit !== null
                         && selectedUnit.ownerId === controller.currentPlayerId

                onClicked: {
                    if (!selectedUnit)
                        return
                    controller.action.destroyUnit(selectedUnit)
                    controller.action.mode = ActionMode.Move
                    controller.action.clearSelection()
                }
            }
        }
    }
}
