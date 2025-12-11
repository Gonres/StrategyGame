import QtQuick
import QtQuick.Controls

Item {
    id: mapContainer
    signal backRequested

    Rectangle {
        anchors.fill: parent
        color: "#222"
    }

    Button {
        text: "Menu / Zpět"
        z: 10
        anchors.left: parent.left
        anchors.top: parent.top
        onClicked: mapContainer.backRequested()
    }

    property int cols: controller.map.columns
    property int rows: controller.map.rows
    property int dynamicCellSize: Math.floor(Math.min(width / cols,height / rows))

    //Map
    GridView {
        id: mapGrid
        anchors.centerIn: parent
        width: mapContainer.dynamicCellSize * mapContainer.cols
        height: mapContainer.dynamicCellSize * mapContainer.rows
        cellWidth: mapContainer.dynamicCellSize
        cellHeight: mapContainer.dynamicCellSize

        model: controller.map.tiles

        delegate: Rectangle {
            width: mapGrid.cellWidth
            height: mapGrid.cellHeight

            color: {

                switch (type) {
                case TileType.Grass:
                    return "green"
                case TileType.Water:
                    return "blue"
                case TileType.Mountain:
                    return "saddlebrown"
                default:
                    return "magenta" //Error color
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
