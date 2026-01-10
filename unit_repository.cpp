#include "unit_repository.h"

UnitRepository::UnitRepository(QObject *parent) : QObject{parent} {}

QList<Unit *> UnitRepository::player1Units() const
{
    return m_player1Units;
}

QList<Unit *> UnitRepository::player2Units() const
{
    return m_player2Units;
}

void UnitRepository::addPlayer1Unit(UnitType::Type unitType, QPoint position)
{
    m_player1Units.append(Unit::create(unitType, position, parent()));
    emit player1UnitsChanged();
}

void UnitRepository::addPlayer2Unit(UnitType::Type unitType, QPoint position)
{
    m_player2Units.append(Unit::create(unitType, position, parent()));
    emit player2UnitsChanged();
}

void UnitRepository::removeUnit(Unit *unit)
{
    if (!unit) {
        return;
    }

    if (m_player1Units.removeOne(unit)) {
        emit player1UnitsChanged();
    }
    if (m_player2Units.removeOne(unit)) {
        emit player2UnitsChanged();
    }
}


void UnitRepository::clearUnits()
{
    qDeleteAll(m_player1Units);
    m_player1Units.clear();
    emit player1UnitsChanged();

    qDeleteAll(m_player2Units);
    m_player2Units.clear();
    emit player2UnitsChanged();
}

Unit *UnitRepository::getUnitAt(QPoint position) const
{
    for (Unit *unit : m_player1Units) {
        if (unit->getPosition() == position) {
            return unit;
        }
    }
    for (Unit *unit : m_player2Units) {
        if (unit->getPosition() == position) {
            return unit;
        }
    }
    return nullptr;
}
