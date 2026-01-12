import QtQuick

QtObject {
    // Backgrounds
    readonly property color bgTop: "#02160d"
    readonly property color bgBottom: "#000b06"

    // Brand
    readonly property color primary: "#3dd68c"
    readonly property color primaryDark: "#2ba96d"
    readonly property color primaryBorder: "#7af7bf"

    // Text
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#9ce3c3"
    readonly property color textMuted: "#dddddd"

    // Map
    readonly property color mapBackground: "#222222"
    readonly property color mapTileBorder: "#111111"

    readonly property color reachableTile: "#7f8fa3"

    // Panels / cards
    readonly property color panelBg: "#333333"
    readonly property color panelBorder: "#777777"
    readonly property color cardBg: "#444444"
    readonly property color cardBorder: "#555555"

    // Buttons (pro ty dva v panelu)
    readonly property color buttonBg: "#3a3a3a"
    readonly property color buttonBorder: "#5b5b5b"
    readonly property color buttonText: "#ffffff"

    readonly property color buttonActive: "#2ba96d"
    readonly property color buttonActiveBorder: "#7af7bf"

    readonly property color buttonDanger: "#a83232"
    readonly property color buttonDangerBorder: "#ff9aa2"

    // Stats
    readonly property color statHealth: "#FFAAAA"
    readonly property color statAttack: "#AAAAFF"
    readonly property color statRange: "#AAFFAA"
    readonly property color statMove: "#DDDDDD"
    readonly property color statUsed: "#ff9aa2"
    readonly property color statReady: "#b7ffb7"

    // Toast
    readonly property color toastBg: "#000000"
    readonly property color toastText: "#ffffff"
    readonly property real toastOpacity: 0.7

    // Effects / overlays
    readonly property color flashAttack: "#ff0000"
    readonly property color gameOverOverlay: "#000000cc"

    // Units (base)
    readonly property color unitP1: "#ff3b3b"
    readonly property color unitP2: "#3b7bff"

    // UnitPiece / interactions
    readonly property color unitBorder: "#ffffff"
    readonly property color unitSelectedBorder: "#55ff55"
    readonly property color unitHoverBorder: "#ffffff66"
    readonly property color unitPressedBorder: "#ffffffaa"

    readonly property color unitMoveGlow: "#55ff55"
    readonly property color unitHitFlash: "#ff2222"
}

