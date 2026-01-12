import QtQuick
import QtQuick.Controls
import StrategyGame 1.0
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

        color: theme.cardBg
        radius: 10
        border.width: 1
        border.color: theme.cardBorder

        Column {
            id: contentCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            spacing: 12

            // ================= HLAVIČKA =================
            Column {
                spacing: 6
                Text {
                    text: modelData.unitTypeName
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 17
                }
                Text {
                    text: "💚 Životy: " + modelData.health + " / " + modelData.maxHealth
                    color: theme.statHealth
                    font.pixelSize: 13
                }
            }

            // ================= STATY (JEDNOTKY) =================
            Column {
                visible: !modelData.isBuilding
                spacing: 6

                Row {
                    spacing: 12
                    Text {
                        text: "⚔️ Útok: " + modelData.attackDamage
                        color: theme.statAttack
                        font.pixelSize: 12
                    }
                    Text {
                        text: "🏹 Dosah: " + modelData.attackRange
                        color: theme.statRange
                        font.pixelSize: 12
                    }
                }

                Text {
                    text: "🦶 Pohyb: " + modelData.movementPoints + " / " + modelData.movementRange
                    color: theme.statMove
                    font.pixelSize: 12
                }

                Text {
                    text: "⚠️ Útok v tahu: " + (modelData.hasAttacked ? "už použit" : "dostupný")
                    color: modelData.hasAttacked ? theme.statUsed : theme.statReady
                    font.pixelSize: 12
                }
            }

            // ================= NOVĚ: ÚTOK (JEN JEDNOTKY) =================
            Column {
                visible: !modelData.isBuilding
                spacing: 8
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: "⚔️ Akce"
                    color: theme.textSecondary
                    font.pixelSize: 12
                    font.bold: true
                }

                Button {
                    text: "⚔️  Útok"
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    enabled: !modelData.hasAttacked
                    checkable: true
                    checked: controller.action.mode === ActionMode.Attack

                    onClicked: {
                        controller.action.mode = ActionMode.Attack
                    }
                }
            }

            // ================= STAVĚNÍ (STRONGHOLD) =================
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
                        text: "🏗️  Kasárny"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Barracks
                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Barracks
                        }
                    }

                    Button {
                        text: "🏇  Stáje"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Stables
                        onClicked: {
                            controller.action.mode = ActionMode.Build
                            controller.action.chosenBuildType = UnitType.Stables
                        }
                    }
                }
            }

            // ================= TRÉNINK (BARRACKS) =================
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
                        text: "⚔️  Válečník"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Warrior
                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Warrior
                        }
                    }

                    Button {
                        text: "🏹  Lučištník"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Archer
                        onClicked: {
                            controller.action.mode = ActionMode.Train
                            controller.action.chosenTrainType = UnitType.Archer
                        }
                    }
                }
            }

            // ================= TRÉNINK (STABLES) =================
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
                        text: "🏇  Jezdec"
                        height: 48
                        anchors.left: parent.left
                        anchors.right: parent.right
                        checkable: true
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Cavalry
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
