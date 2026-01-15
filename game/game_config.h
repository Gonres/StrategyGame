#ifndef GAME_CONFIG_H
#define GAME_CONFIG_H

// Minimal config for a new game.
// Kept small on purpose so the project doesn't bloat.
struct GameConfig {
    int m_playerCount = 2;      // 2..4
    int m_startGold = 200;      // per player
    int m_incomePerTurn = 50;   // per turn, for current player
};

#endif // GAME_CONFIG_H


