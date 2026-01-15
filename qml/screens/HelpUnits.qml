import QtQuick
import QtQuick.Controls
import "../components" as Comp
import "../style" as Style

Item {
    id: root
    width: parent ? parent.width : 1280
    height: parent ? parent.height : 720

    signal backRequested

    Style.Theme { id: theme }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: theme.bgTop }
            GradientStop { position: 1; color: theme.bgBottom }
        }
    }

    // ✅ Data s hodnotami (HP/ATK/MOVE)
    // Kde to nemá smysl, nechávám jen HP (budovy)
    property var items: [
        // ===== Budovy =====
        { key: "Stronghold",    name: "Stronghold",        icon: "🏰", price: 100, hp: 200, prereq: [], category: "Budovy" },
        { key: "Barracks",      name: "Kasárny",           icon: "🏯", price: 100, hp: 125, prereq: ["Stronghold"], category: "Budovy" },
        { key: "Bank",          name: "Banka",             icon: "🏦", price: 200, hp: 110, prereq: ["Stronghold"], category: "Budovy" },
        { key: "Stables",       name: "Stáje",             icon: "🏇", price: 100, hp: 150, prereq: ["Barracks"], category: "Budovy" },
        { key: "Church",        name: "Kostel",            icon: "⛪", price: 250, hp: 120, prereq: ["Bank"], category: "Budovy" },
        { key: "SiegeWorkshop", name: "Obléhací dílna",    icon: "🏗️", price: 250, hp: 150, prereq: ["Barracks", "Stables"], category: "Budovy" },

        // ===== Jednotky =====
        { key: "Warrior", name: "Válečník",   icon: "⚔️", price: 100, hp: 100, atk: 15, move: 5,  prereq: ["Barracks"],      category: "Jednotky" },
        { key: "Archer",  name: "Lučištník",  icon: "🏹", price: 80,  hp: 50,  atk: 20, move: 3,  prereq: ["Barracks"],      category: "Jednotky" },
        { key: "Cavalry", name: "Jezdec",     icon: "🐴", price: 80,  hp: 75,  atk: 25, move: 10, prereq: ["Stables"],       category: "Jednotky" },
        { key: "Priest",  name: "Kněz",       icon: "🧙", price: 100, hp: 65,  atk: 0,  move: 3,  prereq: ["Church"],        category: "Jednotky" },
        { key: "Ram",     name: "Beranidlo",  icon: "🪓", price: 300, hp: 300, atk: 25, move: 1,  prereq: ["SiegeWorkshop"], category: "Jednotky" }
    ]

    function filtered(category) {
        var out = []
        for (var i = 0; i < items.length; i++) {
            if (items[i].category === category) out.push(items[i])
        }
        return out
    }

    // ✅ Statický pill (bez implicitWidth → žádný polish loop)
    component StatPill: Rectangle {
        property string label: ""
        property string value: ""

        width: 112
        height: 26
        radius: 10
        color: theme.panelBg
        border.width: 1
        border.color: theme.cardBorder

        Row {
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: label
                color: theme.textSecondary
                font.pixelSize: 13
                elide: Text.ElideRight
            }

            Text {
                text: value
                color: theme.textPrimary
                font.pixelSize: 13
                font.bold: true
                elide: Text.ElideRight
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.92, 980)
        height: Math.min(parent.height * 0.88, 640)
        radius: 20
        color: theme.panelBg
        border.width: 1
        border.color: theme.panelBorder

        Column {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "📗 Jednotky a budovy"
                color: theme.textPrimary
                font.pixelSize: 30
                font.bold: true
            }

            Rectangle { width: parent.width; height: 1; color: theme.panelBorder; opacity: 0.7 }

            ScrollView {
                id: scroll
                clip: true
                width: parent.width
                height: parent.height - backRow.height - 80

                Column {
                    width: scroll.availableWidth
                    spacing: 14

                    // ===== Budovy =====
                    Text { text: "🏗️ Budovy"; color: theme.textPrimary; font.pixelSize: 20; font.bold: true }

                    Repeater {
                        model: root.filtered("Budovy")
                        delegate: Rectangle {
                            width: parent.width
                            radius: 16
                            color: theme.cardBg
                            border.width: 1
                            border.color: theme.cardBorder
                            height: col.implicitHeight + 20

                            Column {
                                id: col
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Row {
                                    spacing: 10
                                    Text { text: modelData.icon; font.pixelSize: 22 }
                                    Text {
                                        text: modelData.name
                                        color: theme.textPrimary
                                        font.pixelSize: 18
                                        font.bold: true
                                        wrapMode: Text.WordWrap
                                        width: parent.width - 80
                                    }
                                }

                                // Cena + HP
                                Row {
                                    spacing: 10
                                    Text { text: "Cena: " + modelData.price + " 🪙"; color: theme.textSecondary; font.pixelSize: 14 }
                                    Text { text: "•"; color: theme.textSecondary; font.pixelSize: 14 }
                                    Text { text: "HP: " + modelData.hp + " ❤️"; color: theme.textSecondary; font.pixelSize: 14 }
                                }

                                Text {
                                    text: (modelData.prereq.length > 0)
                                            ? ("Vyžaduje: " + modelData.prereq.join(", "))
                                            : "Vyžaduje: nic (základ)"
                                    color: theme.textSecondary
                                    font.pixelSize: 14
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }
                        }
                    }

                    Item { height: 6 }

                    // ===== Jednotky =====
                    Text { text: "⚔️ Jednotky"; color: theme.textPrimary; font.pixelSize: 20; font.bold: true }

                    Repeater {
                        model: root.filtered("Jednotky")
                        delegate: Rectangle {
                            width: parent.width
                            radius: 16
                            color: theme.cardBg
                            border.width: 1
                            border.color: theme.cardBorder
                            height: col2.implicitHeight + 20

                            Column {
                                id: col2
                                anchors.fill: parent
                                anchors.margins: 14
                                spacing: 8

                                Row {
                                    spacing: 10
                                    Text { text: modelData.icon; font.pixelSize: 22 }
                                    Text {
                                        text: modelData.name
                                        color: theme.textPrimary
                                        font.pixelSize: 18
                                        font.bold: true
                                        wrapMode: Text.WordWrap
                                        width: parent.width - 80
                                    }
                                }

                                Text {
                                    text: "Cena: " + modelData.price + " 🪙"
                                    color: theme.textSecondary
                                    font.pixelSize: 14
                                }

                                // ✅ Staty jednotky (staticky + Flow → bezpečné)
                                Flow {
                                    width: parent.width
                                    spacing: 10

                                    StatPill { label: "❤️ HP";   value: String(modelData.hp) }
                                    StatPill { label: "🗡️ ATK";  value: String(modelData.atk) }
                                    StatPill { label: "👣 MOVE"; value: String(modelData.move) }
                                }

                                Text {
                                    text: (modelData.prereq.length > 0)
                                            ? ("Vyžaduje: " + modelData.prereq.join(", "))
                                            : "Vyžaduje: nic (základ)"
                                    color: theme.textSecondary
                                    font.pixelSize: 14
                                    wrapMode: Text.WordWrap
                                    width: parent.width
                                }
                            }
                        }
                    }

                    Item { height: 8 }
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
}
