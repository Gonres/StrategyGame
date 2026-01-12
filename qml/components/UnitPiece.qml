import QtQuick
import StrategyGame 1.0
import "../style" as Style

Rectangle {
    id: root

    property var unitModel

    // Configuration
    property bool isPlayer1Unit: true
    property string unitColor: "red"
    property int tileSize: 35
    property var mapGridObj

    property bool gameOver: false

    signal attackSuccess

    Style.Theme { id: theme }

    width: tileSize
    height: tileSize
    radius: 7

    color: (isPlayer1Unit ? theme.unitP1 : theme.unitP2) || unitColor

    border.width: (unitModel && unitModel.unitSelected) ? 3 : 2
    border.color: (unitModel && unitModel.unitSelected) ? theme.unitSelectedBorder : theme.unitBorder
    z: 20

    // Internal state
    property point originalPos: Qt.point(0, 0)
    readonly property bool isOwnerTurn: (isPlayer1Unit && controller.isPlayer1Turn)
                                        || (!isPlayer1Unit && !controller.isPlayer1Turn)

    // ✅ ikonka podle typu jednotky/budovy (Stáje vs Jezdec odděleno)
    function iconForType(t) {
        switch (t) {
        case UnitType.Stronghold: return "🏰"
        case UnitType.Barracks:   return "🏯"
        case UnitType.Stables:    return "🏇"   // STÁJE (odlišit od jezdce)
        case UnitType.Warrior:    return "⚔️"
        case UnitType.Archer:     return "🏹"
        case UnitType.Cavalry:    return "🐴"   // JEZDEC (odlišná ikonka)
        default:                  return "❓"
        }
    }

    // --- ICON OVERLAY ---
    Text {
        id: unitIcon
        anchors.centerIn: parent
        text: unitModel ? iconForType(unitModel.unitType) : ""
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
            PropertyAnimation { target: moveGlow; property: "opacity"; to: 0.60; duration: 90 }
            SequentialAnimation {
                PropertyAnimation { target: root; property: "scale"; to: 1.18; duration: 90 }
                PropertyAnimation { target: root; property: "scale"; to: 1.00; duration: 140 }
            }
        }
        PropertyAnimation { target: moveGlow; property: "opacity"; to: 0.00; duration: 220 }
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
            PropertyAnimation { target: hitFlash; property: "opacity"; to: 0.75; duration: 70 }
            SequentialAnimation {
                PropertyAnimation { target: root; property: "scale"; to: 0.92; duration: 60 }
                PropertyAnimation { target: root; property: "scale"; to: 1.08; duration: 70 }
                PropertyAnimation { target: root; property: "scale"; to: 1.00; duration: 90 }
            }
        }
        PropertyAnimation { target: hitFlash; property: "opacity"; to: 0.00; duration: 220 }
    }

    NumberAnimation on x { id: moveAnimX; duration: 200; running: false }
    NumberAnimation on y {
        id: moveAnimY
        duration: 200
        running: false
        onStopped: root.bindToModel()
    }

    function bindToModel() {
        if (!mapGridObj) return

        root.x = Qt.binding(function () {
            return (unitModel && mapGridObj) ? mapGridObj.x + unitModel.position.x * tileSize : 0
        })
        root.y = Qt.binding(function () {
            return (unitModel && mapGridObj) ? mapGridObj.y + unitModel.position.y * tileSize : 0
        })
    }

    Component.onCompleted: bindToModel()

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !gameOver

        drag.target: (unitModel && isOwnerTurn
                      && controller.action.mode === ActionMode.Move
                      && unitModel.unitSelected && !unitModel.isBuilding
                      && unitModel.movementPoints > 0) ? root : null
        drag.axis: Drag.XAndYAxis

        drag.minimumX: mapGridObj ? mapGridObj.x : 0
        drag.maximumX: mapGridObj ? mapGridObj.x + mapGridObj.width - width : 0
        drag.minimumY: mapGridObj ? mapGridObj.y : 0
        drag.maximumY: mapGridObj ? mapGridObj.y + mapGridObj.height - height : 0

        onPressed: {
            if (isOwnerTurn) {
                controller.action.clearSelection()
                controller.action.addToSelection(unitModel)
                controller.action.mode = ActionMode.Move
            }
            if (drag.active) {
                root.originalPos = Qt.point(root.x, root.y)
                root.x = root.x
                root.y = root.y
            }
        }

        onClicked: {
            if (!isOwnerTurn && controller.action.mode === ActionMode.Attack) {
                let canAttack = controller.action.tryAttack(unitModel)
                if (canAttack) {
                    hitAnim.restart()
                    root.attackSuccess()
                }
            }
        }

        onReleased: {
            if (drag.target === root) {
                let centerX = (root.x - mapGridObj.x) + (tileSize / 2)
                let centerY = (root.y - mapGridObj.y) + (tileSize / 2)

                let col = Math.floor(centerX / tileSize)
                let row = Math.floor(centerY / tileSize)

                if (controller.action.tryMoveSelectedTo(col, row)) {
                    root.x = mapGridObj.x + col * tileSize
                    root.y = mapGridObj.y + row * tileSize
                    root.bindToModel()
                } else {
                    root.x = root.originalPos.x
                    root.y = root.originalPos.y
                    root.bindToModel()
                }
                controller.action.reachableTilesChanged()
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

