#include "entities/units/unit_repository.h"

#include "entities/units/unit_type.h"

UnitRepository::UnitRepository(QObject *parent)
    : QObject{parent}
{
    // Default for old behavior (2 players) until configured by GameController.
    configurePlayers(2);
}

void UnitRepository::configurePlayers(int playerCount)
{
    if (playerCount < 2) {
        playerCount = 2;
    }
    if (playerCount > 4) {
        playerCount = 4;
    }

    // Clear any existing units when reconfiguring.
    clearUnits();
    m_unitsByPlayer.clear();
    m_unitsByPlayer.resize(playerCount);
    emit unitsChanged();
}

QList<Unit *> UnitRepository::allUnits() const
{
    QList<Unit *> out;
    for (const QList<Unit *> &list : m_unitsByPlayer) {
        out.append(list);
    }
    return out;
}

QList<Unit *> UnitRepository::unitsForPlayer(int playerId) const
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) {
        return {};
    }
    return m_unitsByPlayer[playerId];
}

bool UnitRepository::playerHasType(int playerId, UnitType::Type type) const
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) {
        return false;
    }

    const QList<Unit *> &list = m_unitsByPlayer[playerId];
    for (Unit *u : list) {
        if (u && u->getUnitType() == type) {
            return true;
        }
    }
    return false;
}

bool UnitRepository::canCreate(int playerId, UnitType::Type type) const
{
    const QList<UnitType::Type> reqs = UnitType::prerequisites(type);
    for (UnitType::Type req : reqs) {
        if (!playerHasType(playerId, req)) {
            return false;
        }
    }
    return true;
}

void UnitRepository::addUnit(int playerId, UnitType::Type unitType, QPoint position)
{
    if (playerId < 0 || playerId >= m_unitsByPlayer.size()) {
        return;
    }

    Unit *unit = Unit::create(unitType, position, this);
    if (!unit) {
        return;
    }

    unit->setOwnerId(playerId);
    m_unitsByPlayer[playerId].append(unit);
    emit unitsChanged();
}

void UnitRepository::removeUnit(Unit *unit)
{
    if (!unit) {
        return;
    }

    const int owner = unit->ownerId();
    if (owner >= 0 && owner < m_unitsByPlayer.size()) {
        if (m_unitsByPlayer[owner].removeAll(unit) > 0) {
            unit->deleteLater();
            emit unitsChanged();
            return;
        }
    }

    // Fallback: search all lists.
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
            if (u && u->getPosition() == position) {
                return u;
            }
        }
    }
    return nullptr;
}
