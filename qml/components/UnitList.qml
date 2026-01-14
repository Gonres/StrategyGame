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

            Text {
                color: theme.textPrimary
                font.pixelSize: 15
                font.bold: true
                elide: Text.ElideRight
            }

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
                    Text { text: "🗡️ Útok: " + modelData.attackDamage; color: theme.statAttack; font.pixelSize: 12 }
                    Text { text: "🎯 Dostřel: " + modelData.attackRange; color: theme.statRange; font.pixelSize: 12 }
                }

                Row {
                    spacing: 12
                    Text { text: "👣 Pohyb: " + modelData.movementPoints + " / " + modelData.movementRange; color: theme.statMove; font.pixelSize: 12 }
                    Text {
                        text: "⚠️ Útok v tahu: " + (modelData.hasAttacked ? "už použit" : "dostupný")
                        color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                        font.pixelSize: 12
                    }
                }

                // Tlačítko ÚTOK
                Button {
                    text: "🗡️ Útok"
                    height: 46
                    anchors.left: parent.left
                    anchors.right: parent.right

                    enabled: modelData.ownerId === controller.currentPlayerId
                             && !modelData.hasAttacked
                             && controller.action.selectedUnits.length > 0
                             && controller.action.selectedUnits[0] === modelData

                    onClicked: controller.action.mode = ActionMode.Attack
                }
            }

            // STAVĚNÍ – jen Stronghold
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

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Barracks)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Barracks)

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

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Stables)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Stables)

                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Stables
                        }
                    }

                    Button {
                        text: "🏦  Banka (" + controller.unitCost(UnitType.Bank) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Bank

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Bank)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Bank)

                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Bank
                        }
                    }

                    Button {
                        text: "⛪  Kostel (" + controller.unitCost(UnitType.Church) + "g)"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Church

                        enabled: modelData.ownerId === controller.currentPlayerId
                                 && controller.currentGold >= controller.unitCost(UnitType.Church)
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Church)

                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Church
                        }
                    }
                }
            }

            // TRÉNINK – Barracks
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
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Warrior)

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
                                 && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Archer)

                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Archer
                        }
                    }
                }
            }

            // TRÉNINK – Stables
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
                             && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Cavalry)

                    onClicked: {
                        controller.action.mode = ActionMode.Train
                        controller.action.chosenTrainType = UnitType.Cavalry
                    }
                }
            }

            // TRÉNINK – Church => Priest
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

                Button {
                    text: "🧙  Kněz (" + controller.unitCost(UnitType.Priest) + "g)"
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    checkable: true
                    checked: controller.action.mode === ActionMode.Train
                             && controller.action.chosenTrainType === UnitType.Priest

                    enabled: modelData.ownerId === controller.currentPlayerId
                             && controller.currentGold >= controller.unitCost(UnitType.Priest)
                             && controller.unitRepository.canCreate(controller.currentPlayerId, UnitType.Priest)

                    onClicked: {
                        controller.action.mode = ActionMode.Train
                        controller.action.chosenTrainType = UnitType.Priest
                    }
                }
            }
        }
    }
}
