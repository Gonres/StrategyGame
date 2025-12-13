#include "unit.h"
#include "archer.h"
#include "cavalry.h"
#include "warrior.h"

Unit::Unit(UnitType::Type type, int health, int maxHealth, int attackDamage,
           int attackRange, int movementRange, QPoint position, QObject *parent)
    : m_unitType(type),
      m_health(health),
      m_maxHealth(maxHealth),
      m_attackDamage(attackDamage),
      m_attackRange(attackRange),
      m_movementRange(movementRange),
      m_position(position),
      m_unitSelected(false),
      QObject(parent) {}

Unit *Unit::create(UnitType::Type unitType, QPoint position, QObject *parent)
{
    switch (unitType) {
    case UnitType::warrior:
        return new Warrior(position, parent);
    case UnitType::archer:
        return new Archer(position, parent);
    case UnitType::cavalry:
        return new Cavalry(position, parent);
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

QPoint Unit::getPosition() const
{
    return m_position;
}

bool Unit::isUnitSelected() const
{
    return m_unitSelected;
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

void Unit::setPosition(QPoint position)
{
    if (m_position == position) {
        return;
    }
    m_position = position;
    emit positionChanged();
}

void Unit::setUnitSelected(bool selected)
{
    if (m_unitSelected == selected) {
        return;
    }
    m_unitSelected = selected;
    emit unitSelectedChanged();
}

QString Unit::unitTypeToString() const
{
    switch (static_cast<UnitType::Type>(m_unitType)) {
    case UnitType::Type::warrior:
        return "Válečník";
    case UnitType::Type::archer:
        return "Lučištník";
    case UnitType::Type::cavalry:
        return "Jezdec";
    default:
        return "Unknown";
    }
}
