#include "unit.h"
#include "archer.h"
#include "barracks.h"
#include "cavalry.h"
#include "stables.h"
#include "warrior.h"

#include <stronghold.h>

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
      QObject(parent) {}

Unit::Unit(UnitType::Type type, int maxHealth, QPoint position, QObject *parent)
    : m_unitType(type),
      m_health(maxHealth),
      m_maxHealth(maxHealth),
      m_attackDamage(0),
      m_attackRange(0),
      m_movementRange(0),
      m_movementPoints(type == UnitType::Stronghold ? 5 : 0),
      m_hasAttacked(false),
      m_position(position),
      m_unitSelected(false),
      m_isBuilding(true),
      QObject(parent) {}

Unit *Unit::create(UnitType::Type unitType, QPoint position, QObject *parent)
{
    switch (unitType) {
    case UnitType::Warrior:
        return new Warrior(position, parent);
    case UnitType::Archer:
        return new Archer(position, parent);
    case UnitType::Cavalry:
        return new Cavalry(position, parent);
    case UnitType::Stronghold:
        return new Stronghold(position, parent);
    case UnitType::Barracks:
        return new Barracks(position, parent);
    case UnitType::Stables:
        return new Stables(position, parent);
    default:
        return nullptr;
    }
}

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

QString Unit::unitTypeToString() const
{
    switch (m_unitType) {
    case UnitType::Warrior:
        return "Válečník";
    case UnitType::Archer:
        return "Lučištník";
    case UnitType::Cavalry:
        return "Jezdec";
    case UnitType::Stronghold:
        return "Pevnost";
    case UnitType::Barracks:
        return "Kasárny";
    case UnitType::Stables:
        return "Stáje";
    default:
        return "Unknown";
    }
}

void Unit::attack(Unit *target)
{
    if (!target) {
        return;
    }

    // Default damage calculation
    int newHealth = target->getHealth() - m_attackDamage;
    if (newHealth < 0) {
        newHealth = 0;
    }
    target->setHealth(newHealth);
    qDebug() << "Unit " << unitTypeToString() << " attacked "
             << target->unitTypeToString() << " dealing " << m_attackDamage
             << " damage. Remaining Health: " << newHealth;
}
