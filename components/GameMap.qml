import QtQuick
import QtQuick.Controls

Item {
    id: root
    signal backRequested()

    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Button {
        text: "Menu / Zpět"
        z: 10
        anchors.left: parent.left
        anchors.top: parent.top
        onClicked: root.backRequested()
    }

    //Map
    GridView {
        id: mapGrid
        anchors.centerIn: parent
        width: controller.map.columns * cellWidth
        height: controller.map.rows * cellHeight

        cellWidth: 50
        cellHeight: 50

        model: controller.map.tiles

        delegate: Rectangle {
            width: mapGrid.cellWidth
            height: mapGrid.cellHeight

            color: {

                switch(type) {
                    case TileType.Grass: return "green";
                    case TileType.Water: return "blue";
                    case TileType.Mountain: return "saddlebrown";
                    default: return "magenta"; //Error color
                }
            }
            border.color: Qt.darker(color, 1.2)
            MouseArea {
                anchors.fill: parent
                onClicked: console.log("Klik na: " + index)
            }
        }
    }
}
