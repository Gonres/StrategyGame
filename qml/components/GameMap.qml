import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../style" as Style

Item {
    id: mapContainer
    signal backRequested

    Style.Theme {
        id: theme
    }

    property int baseTileSize: 35
    property int minTileSize: 20

    // symetrické boční panely
    property int sidePanelWidth: 320
    property int messageBarHeight: 48

    property var selectedUnit: controller.action.selectedUnits.length
                               > 0 ? controller.action.selectedUnits[0] : null

    property bool gameOver: controller.winnerText !== ""
    property string winnerText: controller.winnerText
    property string lastMoveMessage: ""

    property int baseIncomePerTurn: 50
    property int bankBonusPerTurn: 25

    // jednoduchý "refresh", aby se příjem přepočítal i po postavení banky
    property int unitsRevision: controller && controller.unitRepository ? controller.unitRepository.allUnits.length : 0

    function bankCountForCurrentPlayer() {
        var _rev = unitsRevision
        if (!controller || !controller.unitRepository) return 0
        return controller.unitRepository.countTypeForPlayer(controller.currentPlayerId, UnitType.Bank)
    }

    function incomeText() {
        var banks = bankCountForCurrentPlayer()
        var total = baseIncomePerTurn + banks * bankBonusPerTurn

        if (banks > 0) {
            return "Příjem za tah: +" + total + " (" + baseIncomePerTurn + "g hráč + " + banks + "x" + bankBonusPerTurn + "g Banka)"
        }
        return "Příjem za tah: +" + total + " (" + baseIncomePerTurn + "g hráč)"
    }

    function colorForPlayer(pid) {
        switch (pid) {
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

    Timer {
        id: msgTimer
        interval: 3000
        onTriggered: lastMoveMessage = ""
    }

    Connections {
        target: controller.action
        function onActionMessage(msg) {
            lastMoveMessage = msg
            msgTimer.restart()
        }
    }

    Connections {
        target: controller.unitRepository
        function onUnitsChanged() {
            controller.checkVictory()
        }
    }

    // =====================================================
    // POZADÍ
    // =====================================================
    Rectangle {
        anchors.fill: parent
        color: theme.mapBackground
        z: 0
    }

    // =====================================================
    // BAREVNÝ RÁM PODLE HRÁČE (aktuální tah)
    // =====================================================
    Rectangle {
        anchors.fill: parent
        radius: 16
        color: "transparent"
        border.width: 4
        border.color: colorForPlayer(controller.currentPlayerId)
        z: 1
    }

    // =====================================================
    // HLAVNÍ LAYOUT
    // =====================================================
    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8
        z: 5

        // =================================================
        // LEVÝ PANEL
        // =================================================
        Rectangle {
            Layout.preferredWidth: sidePanelWidth
            Layout.fillHeight: true
            radius: 12
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Column {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                MenuButton {
                    text: "Ukončit hru"
                    enabled: !gameOver
                    onClicked: {
                        if (controller) {
                            controller.action.mode = ActionMode.Move
                            controller.action.clearSelection()
                        }
                        backRequested()
                    }
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: theme.panelBorder
                }

                Text {
                    text: "Hraje: Hráč " + (controller.currentPlayerId + 1)
                          + " / " + controller.playerCount
                    color: theme.textMuted
                    font.pixelSize: 14
                }

                Text {
                    text: "💰 Gold: " + controller.currentGold
                    color: theme.textPrimary
                    font.pixelSize: 16
                    font.bold: true
                }

                // ✅ tady byla natvrdo +50 → teď se počítá (50g hráč + Nx25g Banka)
                Text {
                    text: incomeText()
                    color: theme.textMuted
                    font.pixelSize: 12
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        // =================================================
        // STŘED – MAPA
        // =================================================
        Item {
            id: centerArea
            Layout.fillWidth: true
            Layout.fillHeight: true

            property int tileSize: {
                if (!controller.map)
                    return baseTileSize
                let cols = controller.map.columns
                let rows = controller.map.rows

                let reservedH = messageBarHeight + endTurnButton.height + 24

                let availW = width
                let availH = height - reservedH

                let s = Math.min(Math.floor(availW / cols),
                                 Math.floor(availH / rows), baseTileSize)
                return Math.max(minTileSize, s)
            }

            Column {
                anchors.fill: parent
                spacing: 10

                // =============================================
                // HLÁŠKY – STÁLÉ MÍSTO
                // =============================================
                Rectangle {
                    id: messageBar
                    height: messageBarHeight
                    width: Math.min(parent.width, 720)
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 8
                    color: theme.toastBg
                    opacity: lastMoveMessage.length > 0 ? theme.toastOpacity : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 160
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: lastMoveMessage
                        color: theme.toastText
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // =============================================
                // ✅ NOVÉ: INSTRUKCE PRO VÝBĚR ZÁKLADNY
                // =============================================
                Rectangle {
                    id: placementBanner
                    width: Math.min(parent.width, 820)
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 10
                    color: theme.panelBg
                    border.width: 1
                    border.color: theme.panelBorder
                    visible: !gameOver && controller && controller.action
                             && controller.action.mode === ActionMode.PlaceStronghold

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 4

                        Text {
                            width: parent.width
                            text: "🏰 Vyber si políčko, kde bude tvoje základna"
                            color: theme.textPrimary
                            font.pixelSize: 14
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Text {
                            width: parent.width
                            text: "Na vodu ani na obsazené políčko to nejde. Hraje: Hráč " + (controller.currentPlayerId + 1)
                            color: theme.textMuted
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // =============================================
                // MAPA
                // =============================================
                Item {
                    id: mapContent
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: controller.map.columns * centerArea.tileSize
                    height: controller.map.rows * centerArea.tileSize

                    // ---------- Tiles ----------
                    Grid {
                        id: mapGrid
                        anchors.fill: parent
                        rows: controller.map.rows
                        columns: controller.map.columns

                        Repeater {
                            model: controller.map.tiles
                            delegate: Rectangle {
                                width: centerArea.tileSize
                                height: centerArea.tileSize
                                color: modelData.color
                                border.width: 1
                                border.color: theme.mapTileBorder
                            }
                        }
                    }

                    // ✅ Klik mimo reachable / mimo jednotky -> zavři reachable + selection
                    // (během výběru Strongholdu to nechceme – hráč musí jen vybrat políčko)
                    MouseArea {
                        anchors.fill: parent
                        z: 5
                        enabled: !gameOver
                                 && !(controller && controller.action && controller.action.mode === ActionMode.PlaceStronghold)
                                 && (controller.action.selectedUnits.length > 0
                                     || controller.action.reachableTiles.length > 0)
                        onClicked: {
                            controller.action.mode = ActionMode.Move
                            controller.action.clearSelection()
                        }
                    }

                    // ---------- Reachable highlights ----------
                    Repeater {
                        model: {
                            if (gameOver || !controller || !controller.action) return []

                            // ✅ Úvodní výběr základny: zobraz reachable pro celou mapu (passable & free)
                            if (controller.action.mode === ActionMode.PlaceStronghold) {
                                return controller.action.reachableTiles
                            }

                            // Normální režimy: jen když je vybraná jednotka a odpovídající mode
                            if (!selectedUnit) return []

                            if (controller.action.mode === ActionMode.Move && !selectedUnit.isBuilding)
                                return controller.action.reachableTiles

                            if ((controller.action.mode === ActionMode.Build || controller.action.mode === ActionMode.Train) && selectedUnit.isBuilding)
                                return controller.action.reachableTiles

                            return []
                        }

                        delegate: Item {
                            width: centerArea.tileSize
                            height: centerArea.tileSize
                            x: modelData.x * centerArea.tileSize
                            y: modelData.y * centerArea.tileSize
                            z: 10

                            Rectangle {
                                anchors.fill: parent
                                color: theme.reachableTile
                                opacity: 0.45
                                border.width: 2
                                border.color: "#ffffffaa"
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: !gameOver
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var ctrl = controller

                                    // ✅ NOVÉ: úvodní umístění Strongholdu
                                    if (ctrl.action.mode === ActionMode.PlaceStronghold) {
                                        ctrl.tryPlaceStrongholdAt(modelData.x, modelData.y)
                                        return
                                    }

                                    if (ctrl.action.mode === ActionMode.Build) {
                                        let ok = ctrl.tryBuildAt(modelData.x, modelData.y)
                                        if (ok) {
                                            ctrl.action.clearSelection()
                                            ctrl.action.mode = ActionMode.Move
                                        }
                                    } else if (ctrl.action.mode === ActionMode.Train) {
                                        let ok2 = ctrl.tryTrainAt(modelData.x, modelData.y)
                                        if (ok2) {
                                            ctrl.action.clearSelection()
                                            ctrl.action.mode = ActionMode.Move
                                        }
                                    } else if (ctrl.action.mode === ActionMode.Move) {
                                        ctrl.action.tryMoveSelectedTo(Qt.point(modelData.x, modelData.y))
                                    }
                                }
                            }
                        }
                    }

                    // Attack flash
                    Rectangle {
                        id: mapHitFlash
                        anchors.fill: parent
                        z: 60
                        color: theme.flashAttack
                        opacity: 0
                        visible: opacity > 0
                    }

                    // ---------- All units (players 1..4) ----------
                    Repeater {
                        model: controller.unitRepository.allUnits
                        delegate: UnitPiece {
                            unitModel: modelData
                            tileSize: centerArea.tileSize
                            mapGridObj: mapGrid
                            gameOver: gameOver

                            onAttackSuccess: {
                                mapHitFlashAnim.restart()
                                controller.action.mode = ActionMode.Move
                                controller.checkVictory()
                            }
                        }
                    }
                }

                // =============================================
                // KONEC KOLA
                // (během PlaceStronghold vypneme – tahy se ukončují automaticky po výběru základny)
                // =============================================
                MenuButton {
                    id: endTurnButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Konec kola"
                    enabled: !gameOver
                             && !(controller && controller.action && controller.action.mode === ActionMode.PlaceStronghold)
                    onClicked: {
                        controller.action.mode = ActionMode.Move
                        controller.action.clearSelection()
                        controller.endTurn()
                    }
                }
            }
        }

        // =================================================
        // PRAVÝ PANEL
        // =================================================
        Rectangle {
            Layout.preferredWidth: sidePanelWidth
            Layout.fillHeight: true
            radius: 12
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Item {
                anchors.fill: parent
                anchors.margins: 14

                Text {
                    visible: controller.action.selectedUnits.length === 0
                    anchors.centerIn: parent
                    text: (controller && controller.action && controller.action.mode === ActionMode.PlaceStronghold)
                          ? "Vyber políčko\npro základnu"
                          : "Vyber jednotku\nna mapě"
                    color: theme.textMuted
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }

                UnitList {
                    visible: controller.action.selectedUnits.length > 0
                    anchors.fill: parent
                }
            }
        }
    }

    // Flash anim
    SequentialAnimation {
        id: mapHitFlashAnim
        PropertyAnimation {
            target: mapHitFlash
            property: "opacity"
            to: 0.45
            duration: 70
        }
        PropertyAnimation {
            target: mapHitFlash
            property: "opacity"
            to: 0.00
            duration: 220
        }
    }

    // =====================================================
    // GAME OVER "VÝHERNÍ STRÁNKA" (overlay)
    // =====================================================
    Rectangle {
        id: victoryOverlay
        anchors.fill: parent
        z: 200
        visible: gameOver
        color: "#000000"
        opacity: 0.65

        Behavior on opacity {
            NumberAnimation {
                duration: 180
            }
        }

        // blokace kliků
        MouseArea {
            anchors.fill: parent
            enabled: victoryOverlay.visible
        }

        // karta
        Rectangle {
            id: victoryCard
            width: Math.min(parent.width * 0.70, 720)
            height: Math.min(parent.height * 0.45, 380)
            anchors.centerIn: parent
            radius: 18
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            // jednoduchý "pop" efekt
            scale: victoryOverlay.visible ? 1.0 : 0.92
            opacity: victoryOverlay.visible ? 1.0 : 0.0
            Behavior on scale {
                NumberAnimation {
                    duration: 180
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 180
                }
            }

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Text {
                    text: "Konec hry"
                    color: theme.textPrimary
                    font.pixelSize: 34
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                Rectangle {
                    height: 1
                    width: parent.width
                    color: theme.panelBorder
                }

                Text {
                    text: winnerText
                    color: theme.textPrimary
                    font.pixelSize: 26
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                Text {
                    text: "🎉 Gratuluji! Můžeš začít novou hru nebo se vrátit do menu."
                    color: theme.textMuted
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    wrapMode: Text.WordWrap
                }

                Item { height: 6; width: 1 }

                Row {
                    spacing: 12
                    anchors.horizontalCenter: parent.horizontalCenter

                    MenuButton {
                        text: "Zpět do menu"
                        onClicked: {
                            controller.action.clearSelection()
                            controller.action.mode = ActionMode.Move
                            backRequested()
                        }
                    }
                }
            }
        }
    }
}
