#include "entities/units/unit.h"

Unit::Unit(UnitType::Type type, int maxHealth, int attackDamage,
           int attackRange, int movementRange, QPoint position, QObject *parent)
    : m_unitType(type),
      m_health(maxHealth),
      m_maxHealth(maxHealth),
      m_attackDamage(attackDamage),
      m_attackRange(attackRange),
      m_movementRange(movementRange),
      m_movementPoints(movementRange),
      m_hasAttacked(false),
      m_position(position),
      m_unitSelected(false),
      m_isBuilding(false),
      m_ownerId(-1),
      QObject(parent) {}

Unit::Unit(UnitType::Type type, int maxHealth, QPoint position, QObject *parent)
    : m_unitType(type),
      m_health(maxHealth),
      m_maxHealth(maxHealth),
      m_attackDamage(0),
      m_attackRange(0),
      m_movementRange(0),
      m_movementPoints(type == UnitType::Stronghold ? 3 : 1),
      m_hasAttacked(false),
      m_position(position),
      m_unitSelected(false),
      m_isBuilding(true),
      m_ownerId(-1),
      QObject(parent) {}

UnitType::Type Unit::getUnitType() const
{
    return m_unitType;
}
bool Unit::hasAttacked() const
{
    return m_hasAttacked;
}
bool Unit::isBuilding() const
{
    return m_isBuilding;
}

bool Unit::canAttack() const
{
    return !m_isBuilding && m_attackDamage > 0;
}

int Unit::ownerId() const
{
    return m_ownerId;
}

void Unit::setOwnerId(int ownerId)
{
    if (m_ownerId == ownerId)
        return;
    m_ownerId = ownerId;
    emit ownerIdChanged();
}

void Unit::resetMovement()
{
    m_movementPoints = m_movementRange;
    emit movementPointsChanged();
}

bool Unit::spendMovement(int cost)
{
    if (cost <= 0) {
        return true;
    }
    if (m_movementPoints < cost) {
        return false;
    }
    m_movementPoints -= cost;
    emit movementPointsChanged();
    return true;
}

void Unit::resetAttack()
{
    if (!m_hasAttacked) {
        return;
    }
    m_hasAttacked = false;
    emit hasAttackedChanged();
}

void Unit::markAttacked()
{
    if (m_hasAttacked) {
        return;
    }
    m_hasAttacked = true;
    emit hasAttackedChanged();
}

int Unit::getMovementPoints() const
{
    return m_movementPoints;
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

// default dmg (běžné jednotky)
int Unit::damageAgainst(const Unit *target) const
{
    Q_UNUSED(target);
    return m_attackDamage;
}

void Unit::attack(Unit *target)
{
    if (!target) {
        return;
    }

    const int dmg = damageAgainst(target);
    target->setHealth(target->getHealth() - dmg);
}
