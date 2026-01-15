import QtQuick
import "../style" as Style

Rectangle {
    id: root

    property var unitModel

    // Configuration
    property int tileSize: 35
    property var mapGridObj
    property bool gameOver: false

    signal attackSuccess
    signal healSuccess

    Style.Theme {
        id: theme
    }

    width: tileSize
    height: tileSize
    radius: 7
    z: 20

    readonly property bool isOwnerTurn: unitModel
                                        && (unitModel.ownerId === controller.currentPlayerId)

    function colorForOwner(ownerId) {
        switch (ownerId) {
        case 0:
            return theme.unitP1
        case 1:
            return theme.unitP2
        case 2:
            return theme.unitP3
        case 3:
            return theme.unitP4
        default:
            return theme.unitP1
        }
    }

    color: colorForOwner(unitModel ? unitModel.ownerId : 0)

    border.width: (unitModel && unitModel.unitSelected) ? 3 : 2
    border.color: (unitModel
                   && unitModel.unitSelected) ? theme.unitSelectedBorder : theme.unitBorder

    opacity: unitModel && unitModel.health <= 0 ? 0 : 1

    // Icon overlay
    Text {
        id: unitIcon
        anchors.centerIn: parent
        text: unitModel ? unitInfo.getInfo(unitModel.unitType).icon : ""
        font.pixelSize: Math.floor(tileSize * 0.62)
        scale: unitModel && unitModel.isBuilding ? 0.92 : 1.0
        z: 24
        style: Text.Outline
        styleColor: "#000000aa"
    }

    // Move Animation
    Rectangle {
        id: moveGlow
        anchors.fill: parent
        radius: parent.radius
        color: theme.unitMoveGlow
        opacity: 0
        visible: opacity > 0
    }

    SequentialAnimation {
        id: moveAnim
        ParallelAnimation {
            PropertyAnimation {
                target: moveGlow
                property: "opacity"
                to: 0.60
                duration: 90
            }
            SequentialAnimation {
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.18
                    duration: 90
                }
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.00
                    duration: 140
                }
            }
        }
        PropertyAnimation {
            target: moveGlow
            property: "opacity"
            to: 0.00
            duration: 220
        }
    }

    // Hit Animation
    Rectangle {
        id: hitFlash
        anchors.fill: parent
        radius: parent.radius
        color: theme.unitHitFlash
        opacity: 0
        visible: opacity > 0
    }

    SequentialAnimation {
        id: hitAnim
        ParallelAnimation {
            PropertyAnimation {
                target: hitFlash
                property: "opacity"
                to: 0.75
                duration: 70
            }
            SequentialAnimation {
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 0.92
                    duration: 60
                }
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.08
                    duration: 70
                }
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.00
                    duration: 90
                }
            }
        }
        PropertyAnimation {
            target: hitFlash
            property: "opacity"
            to: 0.00
            duration: 220
        }
    }

    // Heal Animation (jemný flash)
    Rectangle {
        id: healFlash
        anchors.fill: parent
        radius: parent.radius
        color: theme.unitMoveGlow
        opacity: 0
        visible: opacity > 0
    }

    SequentialAnimation {
        id: healAnim
        ParallelAnimation {
            PropertyAnimation {
                target: healFlash
                property: "opacity"
                to: 0.55
                duration: 90
            }
            SequentialAnimation {
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.10
                    duration: 90
                }
                PropertyAnimation {
                    target: root
                    property: "scale"
                    to: 1.00
                    duration: 140
                }
            }
        }
        PropertyAnimation {
            target: healFlash
            property: "opacity"
            to: 0.00
            duration: 220
        }
    }

    // Binding na pozici modelu
    function bindToModel() {
        if (!mapGridObj)
            return

        root.x = Qt.binding(function () {
            return (unitModel
                    && mapGridObj) ? mapGridObj.x + unitModel.position.x * tileSize : 0
        })
        root.y = Qt.binding(function () {
            return (unitModel
                    && mapGridObj) ? mapGridObj.y + unitModel.position.y * tileSize : 0
        })
    }

    Component.onCompleted: bindToModel()

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !gameOver && unitModel !== null

        drag.target: null
        drag.axis: Drag.XAndYAxis

        onPressed: {
            //  Výběr vlastní jednotky jen když nejsme v Attack/Heal módu.
            // (když je aktivní Heal/Attack, chceme klikem cíl, ne přepínat selection)
            if (!isOwnerTurn)
                return

            if (controller.action.mode === ActionMode.Attack)
                return

            if (controller.action.mode === ActionMode.Heal)
                return

            controller.action.trySelectUnit(unitModel)
            controller.action.mode = ActionMode.Move
        }

        onClicked: {
            if (!unitModel)
                return

            // HEAL mode
            if (controller.action.mode === ActionMode.Heal) {
                // klik = cíl heal
                let okHeal = controller.action.tryHeal(unitModel)
                if (okHeal) {
                    healAnim.restart()
                    root.healSuccess()
                } else {
                    // pokud heal nevyšel a klikl jsi na vlastní jednotku,
                    // tak dovolíme vybrat jiného castera (např. jiného Priesta)
                    if (isOwnerTurn) {
                        controller.action.trySelectUnit(unitModel)
                    }
                }
                return
            }

            // ATTACK mode
            if (controller.action.mode === ActionMode.Attack) {
                // klik = cíl útoku
                let okAtk = controller.action.tryAttack(unitModel)
                if (okAtk) {
                    hitAnim.restart()
                    root.attackSuccess()
                } else {
                    // pokud útok nevyšel a je to vlastní jednotka, tak dovolíme přepnout útočníka
                    if (isOwnerTurn) {
                        controller.action.trySelectUnit(unitModel)
                        controller.action.mode = ActionMode.Attack
                    }
                }
                return
            }

            // Normal click
            if (isOwnerTurn) {
                controller.action.trySelectUnit(unitModel)
                controller.action.mode = ActionMode.Move
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.width: (ma.pressed || ma.containsMouse) ? 1 : 0
        border.color: ma.pressed ? theme.unitPressedBorder : theme.unitHoverBorder
        z: 25
        visible: !gameOver
    }
}
