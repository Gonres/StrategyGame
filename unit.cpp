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
      m_movementPoints(movementRange),
      m_hasAttacked(false),
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

bool Unit::hasAttacked() const
{
    return m_hasAttacked;
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
