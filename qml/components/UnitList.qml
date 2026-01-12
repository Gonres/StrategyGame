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

        function build(type) {
            controller.action.mode = ActionMode.Build
            controller.action.chosenBuildType = type
        }

        function train(type) {
            controller.action.mode = ActionMode.Train
            controller.action.chosenTrainType = type
        }

        // Full width premium tlačítko
        component PremiumButton: Button {
            id: btn
            height: 48
            checkable: true
            enabled: controller.winnerText === ""

            property string leftIcon: ""
            property color activeBg: theme.buttonActive
            property color activeBorder: theme.buttonActiveBorder

            anchors.left: parent.left
            anchors.right: parent.right

            background: Rectangle {
                radius: 10
                color: btn.checked ? btn.activeBg : theme.buttonBg
                border.width: 1
                border.color: btn.checked ? btn.activeBorder : theme.buttonBorder
                opacity: btn.down ? 0.90 : 1.0
                Behavior on opacity { NumberAnimation { duration: 90 } }
            }

            contentItem: Row {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: btn.leftIcon
                    visible: btn.leftIcon.length > 0
                    font.pixelSize: 18
                    verticalAlignment: Text.AlignVCenter
                    color: theme.buttonText
                }

                Text {
                    text: btn.text
                    color: theme.buttonText
                    font.bold: true
                    font.pixelSize: 15
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    width: parent.width - 40
                }
            }
        }

        Column {
            id: contentCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 12
            spacing: 12

            // Header + HP
            Column {
                spacing: 6

                Text {
                    text: modelData.unitTypeName
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 17
                }

                Text {
                    text: "❤ Životy: " + modelData.health + " / " + modelData.maxHealth
                    color: theme.statHealth
                    font.pixelSize: 13
                }
            }

            // Stats jen pro jednotky
            Column {
                visible: !modelData.isBuilding
                spacing: 6

                Row {
                    spacing: 12
                    Text { text: "⚔ Útok: " + modelData.attackDamage; color: theme.statAttack; font.pixelSize: 12 }
                    Text { text: "➶ Dosah: " + modelData.attackRange; color: theme.statRange; font.pixelSize: 12 }
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

            // ======= BUILD (Stronghold) – bez boxu, jen titulek + tlačítka =======
            Column {
                visible: modelData.unitType === UnitType.Stronghold
                spacing: 10
                anchors.left: parent.left
                anchors.right: parent.right

                Text {
                    text: "🏗 Stavění"
                    color: theme.textSecondary
                    font.pixelSize: 12
                    font.bold: true
                }

                Column {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 10

                    PremiumButton {
                        text: "Kasárny"
                        leftIcon: "🏯"
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Barracks
                        onClicked: build(UnitType.Barracks)
                    }

                    PremiumButton {
                        text: "Stáje"
                        leftIcon: "🏇"
                        checked: controller.action.mode === ActionMode.Build
                                 && controller.action.chosenBuildType === UnitType.Stables
                        onClicked: build(UnitType.Stables)
                    }
                }
            }

            // ======= TRAIN (Barracks) – bez boxu =======
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

                    PremiumButton {
                        text: "Válečník"
                        leftIcon: "⚔️"
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Warrior
                        onClicked: train(UnitType.Warrior)
                    }

                    PremiumButton {
                        text: "Lučištník"
                        leftIcon: "🏹"
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Archer
                        onClicked: train(UnitType.Archer)
                    }
                }
            }

            // ======= TRAIN (Stables) – bez boxu =======
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

                    PremiumButton {
                        text: "Jezdec"
                        leftIcon: "🐴"
                        checked: controller.action.mode === ActionMode.Train
                                 && controller.action.chosenTrainType === UnitType.Cavalry
                        onClicked: train(UnitType.Cavalry)
                    }
                }
            }
        }
    }
}
