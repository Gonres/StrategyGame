// import QtQuick
import QtQuick

Item {
    id: root

    signal selectionCompleted(real x, real y, real width, real height)
    signal rightChanged(real x, real y)

    property point selectionStartPos: Qt.point(0, 0)
    property bool selecting: false

    MouseArea {
        id: selectionMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
                       if (mouse.button === Qt.RightButton) {
                           root.rightChanged(mouse.x, mouse.y)
                       }
                   }

        onPressed: mouse => {
                       if (mouse.button !== Qt.LeftButton) {
                           return
                       }
                       root.selecting = true
                       root.selectionStartPos = Qt.point(mouse.x, mouse.y)
                       visualSelectionRectangle.x = mouse.x
                       visualSelectionRectangle.y = mouse.y
                       visualSelectionRectangle.width = 0
                       visualSelectionRectangle.height = 0
                   }

        onPositionChanged: mouse => {
                               if (!root.selecting) {
                                   return
                               }
                               let startX = root.selectionStartPos.x
                               let startY = root.selectionStartPos.y
                               let endX = mouse.x
                               let endY = mouse.y
                               visualSelectionRectangle.x = Math.min(startX,
                                                                     endX)
                               visualSelectionRectangle.width = Math.abs(
                                   endX - startX)
                               visualSelectionRectangle.y = Math.min(startY,
                                                                     endY)
                               visualSelectionRectangle.height = Math.abs(
                                   endY - startY)
                           }

        onReleased: mouse => {
                        if (!root.selecting) {
                            return
                        }

                        root.selecting = false
                        root.selectionCompleted(visualSelectionRectangle.x,
                                                visualSelectionRectangle.y,
                                                visualSelectionRectangle.width,
                                                visualSelectionRectangle.height)

                        visualSelectionRectangle.width = 0
                        visualSelectionRectangle.height = 0
                    }
    }

    Rectangle {
        id: visualSelectionRectangle
        color: "#33AADD55"
        border.color: "#90EE91"
        border.width: 2
        visible: root.selecting
        width: 0
        height: 0
        z: 50
        opacity: 0.8
    }
}
