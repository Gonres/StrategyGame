#include "game/player.h"

Player::Player(int id, int startGold, int incomePerTurn)
    : m_id(id),
    m_gold(startGold),
    m_incomePerTurn(incomePerTurn)
{
}

int Player::id() const
{
    return m_id;
}

int Player::gold() const
{
    return m_gold;
}

int Player::incomePerTurn() const
{
    return m_incomePerTurn;
}

void Player::addGold(int amount)
{
    m_gold += amount;
    if (m_gold < 0) {
        m_gold = 0;
    }
}

bool Player::trySpend(int amount)
{
    if (amount <= 0) {
        return true;
    }
    if (m_gold < amount) {
        return false;
    }
    m_gold -= amount;
    return true;
}
