import QtQuick
import QtQuick.Controls
import StrategyGame 1.0

Item {
    id: mapContainer

    signal backRequested

    // velikost jednoho políčka
    property int tileSize: 35

    property bool showUnitInfo: false
    property string unitInfoTitle: ""
    property string unitInfoStats: ""
    property string unitInfoColor: "red"

    function unitTypeToString(t) {
        // t je prostě číslo z C++ enumu (0, 1, 2)
        if (t === 0) {
            return "Válečník"
        } else if (t === 1) {
            return "Lučištník"
        } else if (t === 2) {
            return "Jezdec"
        } else {
            return "Neznámá jednotka"
        }
    }

    function updateUnitInfo(playerName, unitObj, colorStr) {
        if (!unitObj)
            return
        showUnitInfo = true
        unitInfoColor = colorStr

        unitInfoTitle = playerName + " – " + unitTypeToString(unitObj.unitType)

        unitInfoStats = "Životy: " + unitObj.health + " / " + unitObj.maxHealth
                + "\n" + "Útok: " + unitObj.attackDamage + "\n"
                + "Dosah útoku: " + unitObj.attackRange + "\n" + "Pohyb: " + unitObj.movementRange
    }

    Rectangle {
        anchors.fill: parent
        color: "#222222"
    }

    MenuButton {
        id: backButton
        text: "Menu / Zpět"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 16
        z: 10

        onClicked: mapContainer.backRequested()
    }

    Grid {
        id: mapGrid
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rows: controller.map ? controller.map.rows : 0
        columns: controller.map ? controller.map.columns : 0
        rowSpacing: 0
        columnSpacing: 0

        Repeater {
            model: controller.map ? controller.map.tiles : []

            delegate: Rectangle {
                width: mapContainer.tileSize
                height: mapContainer.tileSize
                color: modelData.color
                border.width: 1
                border.color: "#111111"
            }
        }
    }

    property int middleRow: controller.map ? Math.floor(
                                                 controller.map.rows / 2) : 0
    property int lastColumn: controller.map ? controller.map.columns - 1 : 0

    Rectangle {
        id: unitPlayer1
        width: mapContainer.tileSize
        height: mapContainer.tileSize
        radius: 6
        color: "red"
        border.width: 2
        border.color: "white"
        visible: controller.map !== null && controller.player1Unit !== null

        x: mapGrid.x + 0 * mapContainer.tileSize
        y: mapGrid.y + middleRow * mapContainer.tileSize
        z: 5

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: mapContainer.updateUnitInfo("Hráč 1",
                                                   controller.player1Unit,
                                                   "red")
            onExited: mapContainer.showUnitInfo = false
        }
    }

    Rectangle {
        id: unitPlayer2
        width: mapContainer.tileSize
        height: mapContainer.tileSize
        radius: 6
        color: "blue"
        border.width: 2
        border.color: "white"
        visible: controller.map !== null && controller.player2Unit !== null

        x: mapGrid.x + lastColumn * mapContainer.tileSize
        y: mapGrid.y + middleRow * mapContainer.tileSize
        z: 5

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: mapContainer.updateUnitInfo("Hráč 2",
                                                   controller.player2Unit,
                                                   "blue")
            onExited: mapContainer.showUnitInfo = false
        }
    }

    Rectangle {
        id: unitInfoPanel
        width: 260
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16
        radius: 8
        color: "#333333"
        visible: mapContainer.showUnitInfo
        border.width: 1
        border.color: "#777777"
        z: 20

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 4

            Text {
                text: unitInfoTitle
                font.pixelSize: 18
                font.bold: true
                color: unitInfoColor
                wrapMode: Text.WordWrap
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#555555"
            }

            Text {
                text: unitInfoStats
                font.pixelSize: 14
                color: "#f0f0f0"
                wrapMode: Text.WordWrap
            }
        }
    }
}
