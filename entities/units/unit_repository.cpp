#include "entities/units/unit_repository.h"

UnitRepository::UnitRepository(QObject *parent)
    : QObject{parent}
{
    configurePlayers(2);
}

void UnitRepository::configurePlayers(int playerCount)
{
    if (playerCount < 2) playerCount = 2;
    if (playerCount > 4) playerCount = 4;

    clearUnits();
    m_unitsByPlayer.clear();
    m_unitsByPlayer.resize(playerCount);
    emit unitsChanged();
}

QList<Unit *> UnitRepository::allUnits() const
{
    QList<Unit *> out;
    for (const QList<Unit *> &list : m_unitsByPlayer) out.append(list);
    return out;
}

QList<Unit *> UnitRepository::unitsForPlayer(int playerId) const
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) return {};
    return m_unitsByPlayer[playerId];
}

void UnitRepository::addUnit(int playerId, UnitType::Type unitType, QPoint position)
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) return;

    Unit *unit = Unit::create(unitType, position, this);
    if (!unit) return;

    unit->setOwnerId(playerId);
    m_unitsByPlayer[playerId].append(unit);
    emit unitsChanged();
}

void UnitRepository::removeUnit(Unit *unit)
{
    if (!unit) return;

    const int owner = unit->ownerId();
    if (owner >= 0 && owner < m_unitsByPlayer.size()) {
        if (m_unitsByPlayer[owner].removeAll(unit) > 0) {
            unit->deleteLater();
            emit unitsChanged();
            return;
        }
    }

    for (int i = 0; i < m_unitsByPlayer.size(); ++i) {
        if (m_unitsByPlayer[i].removeAll(unit) > 0) {
            unit->deleteLater();
            emit unitsChanged();
            return;
        }
    }
}

void UnitRepository::clearUnits()
{
    for (QList<Unit *> &list : m_unitsByPlayer) {
        qDeleteAll(list);
        list.clear();
    }
    emit unitsChanged();
}

Unit *UnitRepository::getUnitAt(QPoint position) const
{
    for (const QList<Unit *> &list : m_unitsByPlayer) {
        for (Unit *u : list) {
            if (u && u->getPosition() == position) return u;
        }
    }
    return nullptr;
}

int UnitRepository::countTypeForPlayer(int playerId, UnitType::Type type) const
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) return 0;

    int c = 0;
    for (Unit *u : m_unitsByPlayer[playerId]) {
        if (u && u->getUnitType() == type) c++;
    }
    return c;
}

bool UnitRepository::hasTypeForPlayer(int playerId, UnitType::Type type) const
{
    return countTypeForPlayer(playerId, type) > 0;
}

bool UnitRepository::canCreate(int playerId, UnitType::Type type) const
{
    const QList<UnitType::Type> req = UnitType::prerequisites(type);
    for (UnitType::Type r : req) {
        if (!hasTypeForPlayer(playerId, r)) return false;
    }
    return true;
}
