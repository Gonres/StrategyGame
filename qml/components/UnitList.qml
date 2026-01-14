import QtQuick
import QtQuick.Controls
import "../style" as Style

ListView {
    id: unitList

    Style.Theme { id: theme }

    anchors.left: parent.left
    anchors.right: parent.right
    height: parent.height
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

            // Header
            Row {
                spacing: 10
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: modelData.displayName
                    color: theme.textPrimary
                    font.pixelSize: 15
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width - 10
                }
            }

            // Základní info (pro všechny)
            Column {
                spacing: 6

                Text {
                    text: "📍 Pozice: (" + modelData.position.x + ", " + modelData.position.y + ")"
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
                    spacing: 12
                    Text {
                        text: "🗡️ Útok: " + modelData.attack
                        color: theme.statAttack
                        font.pixelSize: 12
                    }
                    Text {
                        text: "🛡️ Obrana: " + modelData.defense
                        color: theme.statDefense
                        font.pixelSize: 12
                    }
                }

                Row {
                    spacing: 12
                    Text {
                        text: "👣 Pohyb: " + modelData.movement
                        color: theme.statMove
                        font.pixelSize: 12
                    }
                    Text {
                        text: "🎯 Dostřel: " + modelData.range
                        color: theme.statRange
                        font.pixelSize: 12
                    }
                }

                Text {
                    text: "⚠️ Útok v tahu: " + (modelData.hasAttacked ? "už použit" : "dostupný")
                    color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                    font.pixelSize: 12
                }
            }

            // ===== Stavění (Stronghold) =====
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

                    Button {
                        text: "🏗️  Kasárny (" + controller.unitCost(UnitType.Barracks) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Barracks

                        // ✅ nejde kliknout když nemáš gold (a jen když jsi na tahu) + ✅ prerekvizity
                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Barracks)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId,
                                                                       UnitType.Barracks)

                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Barracks
                        }
                    }

                    Button {
                        text: "🏇  Stáje (" + controller.unitCost(UnitType.Stables) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Stables

                        // ✅ gold + ✅ prerekvizity (typicky: musíš mít Kasárny)
                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Stables)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId,
                                                                       UnitType.Stables)

                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Stables
                        }
                    }
                }
            }

            // ===== Trénink (Barracks) =====
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

                    Button {
                        text: "⚔️  Válečník (" + controller.unitCost(UnitType.Warrior) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Warrior

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Warrior)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId,
                                                                       UnitType.Warrior)

                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Warrior
                        }
                    }

                    Button {
                        text: "🏹  Lučištník (" + controller.unitCost(UnitType.Archer) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Archer

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Archer)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId,
                                                                       UnitType.Archer)

                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Archer
                        }
                    }
                }
            }

            // ===== Trénink (Stables) =====
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

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10

                    Button {
                        text: "🏇  Jezdec (" + controller.unitCost(UnitType.Cavalry) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Cavalry

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Cavalry)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId,
                                                                       UnitType.Cavalry)

                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Cavalry
                        }
                    }
                }
            }
        }
    }
}
