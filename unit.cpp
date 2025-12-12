#include "unit.h"
#include "warrior.h"
#include "archer.h"
#include "cavalry.h"

Unit::Unit(UnitType::Type type, int health, int maxHealth, int attackDamage,
           int attackRange, int movementRange, QObject *parent)
    : m_unitType(type),
      m_health(health),
      m_maxHealth(maxHealth),
      m_attackDamage(attackDamage),
      m_attackRange(attackRange),
      m_movementRange(movementRange),
      QObject(parent)
{}

Unit *Unit::create(UnitType::Type unitType, QObject *parent)
{
    switch (unitType) {
    case UnitType::warrior:
        return new Warrior(parent);
    case UnitType::archer:
        return new Archer(parent);
    case UnitType::cavalry:
        return new Cavalry(parent);
    default:
        return nullptr;
    }
}

UnitType::Type Unit::getUnitType() const
{
    return m_unitType;
}

int Unit::getHealth() const
{
    return m_health;
}

int Unit::getMaxHealth() const
{
    return m_maxHealth;
}

int Unit::getAttackDamage() const
{
    return m_attackDamage;
}

int Unit::getAttackRange() const
{
    return m_attackRange;
}

int Unit::getMovementRange() const
{
    return m_movementRange;
}

void Unit::setHealth(const int newHealth)
{
    if (newHealth < m_maxHealth) {
        m_health = newHealth;
    } else {
        m_health = m_maxHealth;
    }
    emit healthChanged();
}
