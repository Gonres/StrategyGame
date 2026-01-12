#include "game/action.h"

Action::Action(UnitRepository *unitRepository, GameMap *map, QObject *parent)
    : QObject{parent},
      m_unitRepository(unitRepository),
      m_map(map),
      m_mode(ActionMode::Move),
      m_chosenBuildType(UnitType::Barracks),
      m_chosenTrainType(UnitType::Warrior)
{}

QList<Unit *> Action::getSelectedUnits() const
{
    return m_selectedUnits;
}

void Action::clearSelection()
{
    if (!m_selectedUnits.isEmpty()) {
        for (Unit *unit : m_selectedUnits) {
            unit->setUnitSelected(false);
        }
        m_selectedUnits.clear();
        emit selectionChanged();
        emit reachableTilesChanged();
    }
}

void Action::addToSelection(Unit *unit)
{
    if (unit && !m_selectedUnits.contains(unit)) {
        m_selectedUnits.append(unit);
        unit->setUnitSelected(true);
        emit selectionChanged();
        emit reachableTilesChanged();
    }
}

void Action::resetTurnForCurrentPlayer(bool isPlayer1Turn)
{
    QList<Unit *> units = isPlayer1Turn ? m_unitRepository->player1Units()
                                        : m_unitRepository->player2Units();
    for (Unit *unit : units) {
        if (!unit || unit->isBuilding()) continue;
        unit->resetMovement();
        unit->resetAttack();
    }
}

void Action::setMode(ActionMode::Mode mode)
{
    if (m_mode == mode) return;
    m_mode = mode;
    emit modeChanged(mode);
    emit reachableTilesChanged();
}

ActionMode::Mode Action::mode() const
{
    return m_mode;
}

UnitType::Type Action::chosenBuildType() const
{
    return m_chosenBuildType;
}

UnitType::Type Action::chosenTrainType() const
{
    return m_chosenTrainType;
}

void Action::setchosenBuildType(UnitType::Type type)
{
    if (m_chosenBuildType == type) return;
    m_chosenBuildType = type;
    emit chosenBuildTypeChanged();
    emit reachableTilesChanged();
}

void Action::setChosenTrainType(UnitType::Type type)
{
    if (m_chosenTrainType == type) return;
    m_chosenTrainType = type;
    emit chosenTrainTypeChanged();
    emit reachableTilesChanged();
}

bool Action::tryMoveSelectedTo(int col, int row)
{
    if (m_selectedUnits.isEmpty()) return false;
    Unit *unit = m_selectedUnits.first();

    if (col < 0 || row < 0 || col >= m_map->getColumns() || row >= m_map->getRows()) return false;

    Unit *obstacle = m_unitRepository->getUnitAt(QPoint(col, row));
    if (obstacle && obstacle != unit) {
        emit actionMessage("Nelze se tam dostat!");
        return false;
    }

    const int dist = qAbs(unit->getPosition().x() - col) + qAbs(unit->getPosition().y() - row);
    if (dist > unit->getMovementPoints()) {
        emit actionMessage("Nedostatek bodů pohybu!");
        return false;
    }

    const int index = m_map->getIndex(col, row);
    Tile *tile = m_map->getTiles().at(index);
    if (tile->getType() == TileType::Water) {
        emit actionMessage("Nemůžeš chodit na vodě!");
        return false;
    }

    unit->setPosition(QPoint(col, row));
    unit->spendMovement(dist);
    emit actionMessage("");
    return true;
}

bool Action::tryAttack(Unit *target)
{
    if (m_selectedUnits.isEmpty() || !target) return false;
    Unit *attacker = m_selectedUnits.first();
    if (attacker->isBuilding()) return false;

    const QPoint p1 = attacker->getPosition();
    const QPoint p2 = target->getPosition();
    const int dist = qAbs(p1.x() - p2.x()) + qAbs(p1.y() - p2.y());

    if (dist > attacker->getAttackRange()) {
        emit actionMessage("Cíl je daleko!");
        return false;
    }
    if (attacker->hasAttacked()) {
        emit actionMessage("Jednotka už zaútočila!");
        return false;
    }

    const int dmg = attacker->getAttackDamage();
    target->setHealth(target->getHealth() - dmg);
    attacker->markAttacked();

    if (target->getHealth() <= 0) {
        m_unitRepository->removeUnit(target);
        emit actionMessage("Cíl zničen! - " + QString::number(dmg) + " HP");
    } else {
        emit actionMessage("Hit! - " + QString::number(dmg) + " HP");
    }
    return true;
}

QVariantList Action::reachableTiles()
{
    QVariantList tiles;
    if (m_selectedUnits.isEmpty()) return tiles;

    Unit *unit = m_selectedUnits.first();
    QPoint start = unit->getPosition();

    // Move: používá movement points
    // Build/Train: vždy jen 1 políčko kolem budovy
    int range = unit->getMovementPoints();
    if (m_mode == ActionMode::Build || m_mode == ActionMode::Train) {
        range = 1;
    }

    for (int x = start.x() - range; x <= start.x() + range; ++x) {
        for (int y = start.y() - range; y <= start.y() + range; ++y) {

            if (x < 0 || y < 0 || x >= m_map->getColumns() || y >= m_map->getRows()) continue;

            const int dist = qAbs(x - start.x()) + qAbs(y - start.y());
            if (dist == 0 || dist > range) continue;

            const int index = m_map->getIndex(x, y);
            Tile *tile = m_map->getTiles().at(index);
            if (tile->getType() == TileType::Water) continue;

            // zvýrazňuj jen volná políčka
            if (m_unitRepository->getUnitAt(QPoint(x, y))) continue;

            QVariantMap t;
            t["x"] = x;
            t["y"] = y;
            tiles.append(t);
        }
    }

    return tiles;
}
