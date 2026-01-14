#ifndef PLAYER_H
#define PLAYER_H

#include <QString>

class Player
{
public:
    Player();
    Player(int id, int startGold, int incomePerTurn);

    int id() const;
    int gold() const;
    int incomePerTurn() const;

    void addGold(int amount);
    bool trySpend(int amount);

private:
    int m_id = 0;
    int m_gold = 0;
    int m_incomePerTurn = 50;
};

#endif // PLAYER_H
