#include "game/action.h"

#include <QtMath>

static bool isPointValid(GameMap *map, const QPoint &p)
{
    if (!map) return false;
    if (p.x() < 0 || p.y() < 0) return false;
    return map->isValid(p.x(), p.y());
}

Action::Action(UnitRepository *repo, GameMap *map, QObject *parent)
    : QObject(parent),
    m_unitRepository(repo),
    m_map(map),
    m_mode(ActionMode::Move),
    m_chosenBuildType(UnitType::Barracks),
    m_chosenTrainType(UnitType::Warrior)
{
}

QList<Unit*> Action::selectedUnits() const
{
    return m_selectedUnits;
}

ActionMode::Mode Action::mode() const
{
    return m_mode;
}

void Action::setMode(ActionMode::Mode m)
{
    if (m_mode == m) return;
    m_mode = m;
    emit modeChanged();
    recalcReachable();
}

QList<QPoint> Action::reachableTiles() const
{
    return m_reachableTiles;
}

// ===== QML helpers =====

void Action::clearSelection()
{
    for (Unit *u : m_selectedUnits) {
        if (u) u->setUnitSelected(false);
    }
    m_selectedUnits.clear();
    emit selectedUnitsChanged();

    m_reachableTiles.clear();
    emit reachableTilesChanged();
}

void Action::refreshReachable()
{
    recalcReachable();
}

// ===== Gameplay =====

void Action::trySelectUnit(Unit *unit)
{
    if (!unit) return;

    clearSelection();
    unit->setUnitSelected(true);
    m_selectedUnits.append(unit);

    emit selectedUnitsChanged();
    recalcReachable();
}

bool Action::tryMoveSelectedTo(QPoint dest)
{
    if (m_selectedUnits.isEmpty()) return false;

    Unit *u = m_selectedUnits.first();
    if (!u || u->isBuilding()) return false;

    if (!isPointValid(m_map, dest)) return false;
    if (!m_map->isPassable(dest.x(), dest.y())) return false;
    if (m_unitRepository->getUnitAt(dest)) return false;

    const int dx = qAbs(dest.x() - u->getPosition().x());
    const int dy = qAbs(dest.y() - u->getPosition().y());
    const int cost = dx + dy;

    if (!u->spendMovement(cost)) return false;

    u->setPosition(dest);
    recalcReachable();
    emit actionMessage("Jednotka se pohnula.");
    return true;
}

bool Action::tryAttack(Unit *target)
{
    if (m_selectedUnits.isEmpty() || !target) return false;

    Unit *attacker = m_selectedUnits.first();
    if (!attacker || attacker->isBuilding()) return false;
    if (attacker->hasAttacked()) return false;
    if (attacker->ownerId() == target->ownerId()) return false;

    const int dx = qAbs(attacker->getPosition().x() - target->getPosition().x());
    const int dy = qAbs(attacker->getPosition().y() - target->getPosition().y());
    const int dist = dx + dy;

    if (dist > attacker->getAttackRange()) return false;

    attacker->attack(target);
    attacker->markAttacked();

    const int targetHealth = target->property("health").toInt();
    if (targetHealth <= 0) {
        m_unitRepository->removeUnit(target);
        emit victoryStateMayHaveChanged();
    }

    emit actionMessage("Útok!");
    emit reachableTilesChanged();
    return true;
}

void Action::resetTurnForCurrentPlayer(int playerId)
{
    const QList<Unit*> units = m_unitRepository->unitsForPlayer(playerId);
    for (Unit *u : units) {
        if (!u || u->isBuilding()) continue;
        u->resetMovement();
        u->resetAttack();
    }
}

// ===== Reachable =====

void Action::recalcReachable()
{
    m_reachableTiles.clear();

    // ✅ Speciální režim: úvodní umístění Strongholdu – není potřeba mít vybranou jednotku.
    if (m_mode == ActionMode::PlaceStronghold) {
        m_reachableTiles = computeReachableForStrongholdPlacement();
        emit reachableTilesChanged();
        return;
    }

    if (m_selectedUnits.isEmpty()) {
        emit reachableTilesChanged();
        return;
    }

    Unit *u = m_selectedUnits.first();
    if (!u) {
        emit reachableTilesChanged();
        return;
    }

    if (m_mode == ActionMode::Move && !u->isBuilding()) {
        m_reachableTiles = computeReachableForMove(u);
    } else if ((m_mode == ActionMode::Build || m_mode == ActionMode::Train) && u->isBuilding()) {
        m_reachableTiles = computeReachableForBuild(u);
    }

    emit reachableTilesChanged();
}

QList<QPoint> Action::computeReachableForStrongholdPlacement() const
{
    QList<QPoint> out;
    if (!m_map || !m_unitRepository) return out;

    const int cols = m_map->getColumns();
    const int rows = m_map->getRows();

    for (int y = 0; y < rows; ++y) {
        for (int x = 0; x < cols; ++x) {
            if (!m_map->isValid(x, y)) continue;
            if (!m_map->isPassable(x, y)) continue;                 // ❌ voda / neprostupné
            if (m_unitRepository->getUnitAt(QPoint(x, y))) continue; // ❌ obsazeno
            out.append(QPoint(x, y));
        }
    }
    return out;
}

QList<QPoint> Action::computeReachableForMove(Unit *u) const
{
    QList<QPoint> out;
    const QPoint pos = u->getPosition();
    const int range = u->getMovementPoints();

    for (int dx = -range; dx <= range; ++dx) {
        for (int dy = -range; dy <= range; ++dy) {
            if (qAbs(dx) + qAbs(dy) > range) continue;

            QPoint p(pos.x() + dx, pos.y() + dy);
            if (!isPointValid(m_map, p)) continue;
            if (!m_map->isPassable(p.x(), p.y())) continue;
            if (m_unitRepository->getUnitAt(p)) continue;

            out.append(p);
        }
    }
    return out;
}

QList<QPoint> Action::computeReachableForBuild(Unit *u) const
{
    QList<QPoint> out;
    const QPoint pos = u->getPosition();

    const QList<QPoint> dirs = {
        QPoint(1,0), QPoint(-1,0), QPoint(0,1), QPoint(0,-1)
};

for (const QPoint &d : dirs) {
    QPoint p(pos.x() + d.x(), pos.y() + d.y());
    if (!isPointValid(m_map, p)) continue;
    if (!m_map->isPassable(p.x(), p.y())) continue;
    if (m_unitRepository->getUnitAt(p)) continue;

    out.append(p);
}
return out;
}

UnitType::Type Action::chosenBuildType() const { return m_chosenBuildType; }
UnitType::Type Action::chosenTrainType() const { return m_chosenTrainType; }

void Action::setChosenBuildType(UnitType::Type t)
{
    if (m_chosenBuildType == t) return;
    m_chosenBuildType = t;
    emit chosenBuildTypeChanged();
    recalcReachable();
}

void Action::setChosenTrainType(UnitType::Type t)
{
    if (m_chosenTrainType == t) return;
    m_chosenTrainType = t;
    emit chosenTrainTypeChanged();
    recalcReachable();
}
