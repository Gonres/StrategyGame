import QtQuick
import StrategyGame 1.0

Rectangle {
    id: root

    property var unitModel

    // Configuration
    property bool isPlayer1Unit: true
    property string unitColor: "red"
    property int tileSize: 35
    property var mapGridObj

    property string actionMode: "move"
    property bool gameOver: false

    signal attackSuccess

    width: tileSize
    height: tileSize
    radius: 7
    color: unitColor
    border.width: (unitModel && unitModel.unitSelected) ? 3 : 2
    border.color: (unitModel && unitModel.unitSelected) ? "lime" : "white"
    z: 20

    // Internal state
    property point originalPos: Qt.point(0, 0)
    readonly property bool isOwnerTurn: (isPlayer1Unit
                                         && controller.isPlayer1Turn)
                                        || (!isPlayer1Unit
                                            && !controller.isPlayer1Turn)

    // Move Animation
    Rectangle {
        id: moveGlow
        anchors.fill: parent
        radius: parent.radius
        color: "#55ff55"
        opacity: 0
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
        color: "#ff2222"
        opacity: 0
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

    NumberAnimation on x {
        id: moveAnimX
        duration: 200
        running: false
    }
    NumberAnimation on y {
        id: moveAnimY
        duration: 200
        running: false
        onStopped: {
            root.bindToModel()
        }
    }

    // position binding
    function bindToModel() {
        if (!mapGridObj) {
            return
        }
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

    // interaction
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        enabled: !gameOver

        // Drag enabled only if it's owner's turn, move mode, unit selected, and has movement points
        drag.target: (unitModel && isOwnerTurn && actionMode === "move"
                      && unitModel.unitSelected
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
            }
            if (drag.active) {
                root.originalPos = Qt.point(root.x, root.y)
                root.x = root.x
                root.y = root.y
            }
        }

        onClicked: {
            if (!isOwnerTurn && actionMode === "attack") {
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
            }
        }
    }
}
