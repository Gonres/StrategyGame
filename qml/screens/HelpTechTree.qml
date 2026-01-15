import QtQuick
import QtQuick.Controls
import "../components" as Comp
import "../style" as Style

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    signal backRequested
    Style.Theme {
        id: theme
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {
                position: 0
                color: theme.bgTop
            }
            GradientStop {
                position: 1
                color: theme.bgBottom
            }
        }
    }

    property color linkGreen: "#35d07f"

    property var nodes: ({
                             "Stronghold": {
                                 "n": "Stronghold",
                                 "i": "🏰",
                                 "req": ""
                             },
                             "Barracks": {
                                 "n": "Kasárny",
                                 "i": "🏯",
                                 "req": "Vyžaduje: Stronghold"
                             },
                             "Bank": {
                                 "n": "Banka",
                                 "i": "🏦",
                                 "req": "Vyžaduje: Stronghold"
                             },
                             "Warrior": {
                                 "n": "Válečník",
                                 "i": "⚔️",
                                 "req": "Vyžaduje: Kasárny"
                             },
                             "Archer": {
                                 "n": "Lučištník",
                                 "i": "🏹",
                                 "req": "Vyžaduje: Kasárny"
                             },
                             "Stables": {
                                 "n": "Stáje",
                                 "i": "🏇",
                                 "req": "Vyžaduje: Kasárny"
                             },
                             "Church": {
                                 "n": "Kostel",
                                 "i": "⛪",
                                 "req": "Vyžaduje: Banka"
                             },
                             "Cavalry": {
                                 "n": "Jezdec",
                                 "i": "🐴",
                                 "req": "Vyžaduje: Stáje"
                             },
                             "SiegeWorkshop": {
                                 "n": "Obléhací dílna",
                                 "i": "🏗️",
                                 "req": "Vyžaduje: Kasárny + Stáje"
                             },
                             "Priest": {
                                 "n": "Kněz",
                                 "i": "🧙",
                                 "req": "Vyžaduje: Kostel"
                             },
                             "Ram": {
                                 "n": "Beranidlo",
                                 "i": "🪓",
                                 "req": "Vyžaduje: Obléhací dílna"
                             }
                         })

    Column {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 14

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "🌳 Vývojový strom"
            color: theme.textPrimary
            font.pixelSize: 30
            font.bold: true
        }

        Rectangle {
            id: treePanel
            width: parent.width
            height: parent.height - backRow.height - 60
            radius: 20
            color: theme.panelBg
            border.width: 1
            border.color: theme.panelBorder

            Item {
                id: panelInner
                anchors.fill: parent
                anchors.margins: 16

                property int cardW: Math.round(
                                        Math.max(200, Math.min(
                                                     270,
                                                     panelInner.width * 0.22)))
                property int cardH: Math.round(
                                        Math.max(74, Math.min(
                                                     92,
                                                     panelInner.height * 0.12)))

                property real y0: panelInner.height * 0.06
                property real y1: panelInner.height * 0.22
                property real y2: panelInner.height * 0.40
                property real y3: panelInner.height * 0.62
                property real y4: panelInner.height * 0.80

                function px(centerRatio, w) {
                    return Math.round(panelInner.width * centerRatio - w / 2)
                }
                function py(v) {
                    return Math.round(v)
                }

                Component {
                    id: techCard
                    Rectangle {
                        id: card
                        property string title: ""
                        property string icon: ""
                        property string req: ""

                        width: panelInner.cardW
                        height: panelInner.cardH
                        radius: 14
                        color: theme.cardBg
                        border.width: 1
                        border.color: theme.cardBorder
                        z: 2

                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: "#ffffff"
                            opacity: 0.04
                        }

                        Column {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 4

                            Row {
                                spacing: 10
                                Text {
                                    text: card.icon
                                    font.pixelSize: 22
                                }
                                Text {
                                    text: card.title
                                    color: theme.textPrimary
                                    font.pixelSize: 15
                                    font.bold: true
                                    elide: Text.ElideRight
                                    width: card.width - 64
                                }
                            }

                            Text {
                                text: card.req
                                visible: card.req !== ""
                                color: root.linkGreen
                                font.pixelSize: 11
                                opacity: 0.95
                                elide: Text.ElideRight
                                width: card.width - 8
                            }
                        }
                    }
                }

                Item {
                    id: graph
                    anchors.fill: parent

                    // Nodes
                    Loader {
                        id: strong
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Stronghold"].n
                            item.icon = nodes["Stronghold"].i
                            item.req = nodes["Stronghold"].req
                        }
                        x: panelInner.px(0.50,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y0)
                    }

                    Loader {
                        id: barr
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Barracks"].n
                            item.icon = nodes["Barracks"].i
                            item.req = nodes["Barracks"].req
                        }
                        x: panelInner.px(0.38,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y1)
                    }
                    Loader {
                        id: bank
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Bank"].n
                            item.icon = nodes["Bank"].i
                            item.req = nodes["Bank"].req
                        }
                        x: panelInner.px(0.62,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y1)
                    }

                    // row2
                    Loader {
                        id: war
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Warrior"].n
                            item.icon = nodes["Warrior"].i
                            item.req = nodes["Warrior"].req
                        }
                        x: panelInner.px(0.10,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y2)
                    }
                    Loader {
                        id: arc
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Archer"].n
                            item.icon = nodes["Archer"].i
                            item.req = nodes["Archer"].req
                        }
                        x: panelInner.px(0.26,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y2)
                    }
                    Loader {
                        id: sta
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Stables"].n
                            item.icon = nodes["Stables"].i
                            item.req = nodes["Stables"].req
                        }
                        x: panelInner.px(0.52,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y2)
                    }
                    Loader {
                        id: chu
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Church"].n
                            item.icon = nodes["Church"].i
                            item.req = nodes["Church"].req
                        }
                        x: panelInner.px(0.74,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y2)
                    }

                    // row3: dílna pod kasárnami, jezdec trochu blíž (aby nelezl do Kněze)
                    Loader {
                        id: sie
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["SiegeWorkshop"].n
                            item.icon = nodes["SiegeWorkshop"].i
                            item.req = nodes["SiegeWorkshop"].req
                        }
                        x: panelInner.px(0.38,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y3)
                    }
                    Loader {
                        id: cav
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Cavalry"].n
                            item.icon = nodes["Cavalry"].i
                            item.req = nodes["Cavalry"].req
                        }
                        x: panelInner.px(0.60,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y3)
                    }
                    Loader {
                        id: pri
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Priest"].n
                            item.icon = nodes["Priest"].i
                            item.req = nodes["Priest"].req
                        }
                        x: panelInner.px(0.80,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y3)
                    }

                    // row4
                    Loader {
                        id: ram
                        sourceComponent: techCard
                        onLoaded: {
                            item.title = nodes["Ram"].n
                            item.icon = nodes["Ram"].i
                            item.req = nodes["Ram"].req
                        }
                        x: panelInner.px(0.38,
                                         item ? item.width : panelInner.cardW)
                        y: panelInner.py(panelInner.y4)
                    }

                    // ===== LINES =====
                    Canvas {
                        id: lines
                        anchors.fill: parent
                        z: 1

                        function midBottom(it) {
                            return it.mapToItem(lines, it.width / 2, it.height)
                        }
                        function midTop(it) {
                            return it.mapToItem(lines, it.width / 2, 0)
                        }

                        function drawArrowDown(ctx, x, y) {
                            var s = 9
                            ctx.beginPath()
                            ctx.moveTo(x, y)
                            ctx.lineTo(x - s, y - s)
                            ctx.moveTo(x, y)
                            ctx.lineTo(x + s, y - s)
                            ctx.stroke()
                        }

                        function strokePath(ctx, alpha, w) {
                            ctx.strokeStyle = root.linkGreen
                            ctx.globalAlpha = alpha
                            ctx.lineWidth = w
                            ctx.lineJoin = "round"
                            ctx.lineCap = "round"
                        }

                        function link(fromItem, toItem, laneY, arrowAtEnd) {
                            if (!fromItem || !toItem)
                                return
                            var ctx = lines.getContext("2d")
                            var A = midBottom(fromItem)
                            var B = midTop(toItem)

                            ctx.save()
                            strokePath(ctx, 0.18, 9)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.lineTo(B.x, laneY)
                            ctx.lineTo(B.x, B.y)
                            ctx.stroke()
                            ctx.restore()

                            ctx.save()
                            strokePath(ctx, 0.95, 3.2)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.lineTo(B.x, laneY)
                            ctx.lineTo(B.x, B.y)
                            ctx.stroke()
                            if (arrowAtEnd)
                                drawArrowDown(ctx, B.x, B.y)
                            ctx.restore()
                        }

                        // vývod z karty posunutý v X
                        function linkFromOffset(fromItem, toItem, laneY, startDx, arrowAtEnd) {
                            if (!fromItem || !toItem)
                                return
                            var ctx = lines.getContext("2d")
                            var A0 = midBottom(fromItem)
                            var B = midTop(toItem)
                            var A = {
                                "x": A0.x + startDx,
                                "y": A0.y
                            }

                            ctx.save()
                            strokePath(ctx, 0.18, 9)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.lineTo(B.x, laneY)
                            ctx.lineTo(B.x, B.y)
                            ctx.stroke()
                            ctx.restore()

                            ctx.save()
                            strokePath(ctx, 0.95, 3.2)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.lineTo(B.x, laneY)
                            ctx.lineTo(B.x, B.y)
                            ctx.stroke()
                            if (arrowAtEnd)
                                drawArrowDown(ctx, B.x, B.y)
                            ctx.restore()
                        }

                        function bus(parentItem, toItems, laneY) {
                            if (!parentItem)
                                return
                            var ctx = lines.getContext("2d")
                            var A = midBottom(parentItem)

                            var xs = []
                            for (var i = 0; i < toItems.length; i++) {
                                if (toItems[i])
                                    xs.push(midTop(toItems[i]).x)
                            }
                            if (xs.length === 0)
                                return
                            xs.sort(function (a, b) {
                                return a - b
                            })
                            var minX = xs[0]
                            var maxX = xs[xs.length - 1]

                            ctx.save()
                            strokePath(ctx, 0.18, 9)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.stroke()
                            ctx.beginPath()
                            ctx.moveTo(minX, laneY)
                            ctx.lineTo(maxX, laneY)
                            ctx.stroke()
                            ctx.restore()

                            ctx.save()
                            strokePath(ctx, 0.95, 3.2)
                            ctx.beginPath()
                            ctx.moveTo(A.x, A.y)
                            ctx.lineTo(A.x, laneY)
                            ctx.stroke()
                            ctx.beginPath()
                            ctx.moveTo(minX, laneY)
                            ctx.lineTo(maxX, laneY)
                            ctx.stroke()
                            ctx.restore()

                            for (var j = 0; j < toItems.length; j++) {
                                var it = toItems[j]
                                if (!it)
                                    continue
                                var B = midTop(it)

                                ctx.save()
                                strokePath(ctx, 0.18, 9)
                                ctx.beginPath()
                                ctx.moveTo(B.x, laneY)
                                ctx.lineTo(B.x, B.y)
                                ctx.stroke()
                                ctx.restore()

                                ctx.save()
                                strokePath(ctx, 0.95, 3.2)
                                ctx.beginPath()
                                ctx.moveTo(B.x, laneY)
                                ctx.lineTo(B.x, B.y)
                                ctx.stroke()
                                drawArrowDown(ctx, B.x, B.y)
                                ctx.restore()
                            }
                        }

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)

                            if (!strong.item || !barr.item || !bank.item)
                                return

                            var lane01 = panelInner.y0 + panelInner.cardH + 18
                            var lane12 = panelInner.y1 + panelInner.cardH + 18

                            var lane23 = panelInner.y2 + panelInner.cardH + 26

                            var lane34 = panelInner.y3 + panelInner.cardH + 18

                            bus(strong.item, [barr.item, bank.item], lane01)
                            bus(barr.item,
                                [war.item, arc.item, sta.item], lane12)

                            link(bank.item, chu.item, lane12, true)
                            link(chu.item, pri.item, lane23, true)

                            // Kasárny -> Dílna rovně dolů
                            var sieTop = midTop(sie.item)
                            link(barr.item, sie.item, sieTop.y, true)

                            // - levý vývod -> Dílna
                            // - pravý vývod -> Jezdec
                            // A OBOJE SE LOMÍ NA STEJNÉ lane23, aby to přicházelo SHORA
                            linkFromOffset(sta.item, sie.item, lane23,
                                           -10, false)
                            linkFromOffset(sta.item, cav.item, lane23, +10,
                                           true) // teď do Jezdce přichází shora

                            // Dílna -> Beranidlo
                            link(sie.item, ram.item, lane34, true)
                        }

                        Connections {
                            target: panelInner
                            function onWidthChanged() {
                                lines.requestPaint()
                            }
                            function onHeightChanged() {
                                lines.requestPaint()
                            }
                        }
                        Timer {
                            interval: 60
                            running: true
                            repeat: false
                            onTriggered: lines.requestPaint()
                        }
                    }
                }
            }
        }

        Row {
            id: backRow
            anchors.horizontalCenter: parent.horizontalCenter
            Comp.MenuButton {
                text: "Zpět"
                onClicked: root.backRequested()
            }
        }
    }
}
