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

    // Reusable card
    component InfoCard: Rectangle {
        id: card
        property string title: ""
        property string body: ""

        width: parent ? parent.width : 800
        radius: 16
        color: theme.cardBg
        border.width: 1
        border.color: theme.cardBorder

        implicitHeight: content.implicitHeight + 28

        Column {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 14
            spacing: 8

            Text {
                text: card.title
                color: theme.textPrimary
                font.pixelSize: 20
                font.bold: true
            }

            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                color: theme.textSecondary
                font.pixelSize: 15
                text: card.body
            }
        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.92, 980)
        height: Math.min(parent.height * 0.88, 670)
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
                text: "📘 Jak se hra hraje"
                color: theme.textPrimary
                font.pixelSize: 30
                font.bold: true
            }

            Rectangle { width: parent.width; height: 1; color: theme.panelBorder; opacity: 0.7 }

            ScrollView {
                id: scroll
                clip: true
                width: parent.width
                height: parent.height - backRow.height - 84

                Column {
                    width: scroll.availableWidth
                    spacing: 14

                    InfoCard {
                        title: "🏁 Konec hry a vítězství"
                        body:
                            "Hra končí ve chvíli, kdy na mapě nezůstane žádná jiná jednotka nebo budova než tvoje.\n" +
                            "Vyhraješ, když jsi poslední hráč, který má na mapě své jednotky/budovy."
                    }

                    InfoCard {
                        title: "🔁 Průběh kola"
                        body:
                            "1) Vybereš jednotku nebo budovu na mapě\n" +
                            "2) Vpravo se zobrazí, co může dělat (akce)\n" +
                            "3) Provedeš akci (pohyb / útok / stavba / trénink)\n" +
                            "4) Ukončíš tah tlačítkem „Konec kola“\n\n" +
                            "Jednotky obvykle mají omezený počet akcí za kolo."
                    }

                    InfoCard {
                        title: "💰 Zlato a ekonomika"
                        body:
                            "Na začátku každého kola získáš automaticky 50 zlata.\n" +
                            "Zlato slouží ke stavbě budov a tréninku jednotek.\n" +
                            "Ekonomické budovy mohou do budoucna zvyšovat tvoje příjmy.\n" +
                            "Správné hospodaření se zlatem je klíčové pro vítězství."
                    }


                    InfoCard {
                        title: "🕹️ Ovládání (výběr, pohyb)"
                        body:
                            "• Klik na vlastní jednotku = výběr\n" +
                            "• Vpravo se ukážou akce jednotky\n" +
                            "• Po zvolení „Pohyb“ se na mapě rozsvítí dosah\n" +
                            "• Klik na zvýrazněné pole = přesun jednotky"
                    }

                    InfoCard {
                        title: "📌 Pravý panel – akce jednotky"
                        body:
                            "Po výběru jednotky/budovy se vpravo ukáže její detail a dostupné akce:\n" +
                            "• Pohyb\n• Útok\n• Stavba / Trénink (u budov)\n• Speciální akce (podle typu)"
                    }

                    InfoCard {
                        title: "⚔️ Jednotky – životy, útoky"
                        body:
                            "Různé jednotky mají různé statistiky:\n" +
                            "• ❤️ Životy (HP)\n• 🗡️ Útok (DMG)\n• 🎯 Dosah\n• 👣 Pohyb\n\n" +
                            "Kombinuj role jednotek pro lepší taktiku."
                    }

                    InfoCard {
                        title: "🏗️ Trénink jednotek v budovách"
                        body:
                            "Jednotky se trénují v budovách.\n" +
                            "Vybereš budovu → vpravo zvolíš jednotku → zaplatíš zlato.\n" +
                            "Nová jednotka se objeví u budovy (nebo na nejbližším volném poli)."
                    }

                    Item { height: 6 }
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
