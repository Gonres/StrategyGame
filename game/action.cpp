#include "game/action.h"
#include <cmath>

Action::Action(UnitRepository *unitRepository, GameMap *map, QObject *parent)
    : QObject{parent},
      m_unitRepository(unitRepository),
      m_map(map),
      m_mode(ActionMode::Move),
      m_chosenBuildType(UnitType::Barracks) {}

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
    }
}

void Action::addToSelection(Unit *unit)
{
    if (unit && !m_selectedUnits.contains(unit)) {
        m_selectedUnits.append(unit);
        unit->setUnitSelected(true);
        emit selectionChanged();
    }
}

void Action::resetTurnForCurrentPlayer(bool isPlayer1Turn)
{
    QList<Unit *> units = isPlayer1Turn ? m_unitRepository->player1Units()
                          : m_unitRepository->player2Units();
    for (Unit *unit : units) {
        if (!unit || unit->isBuilding()) {
            continue;
        }
        unit->resetMovement();
        unit->resetAttack();
    }
}

void Action::setMode(ActionMode::Mode mode)
{
    if (m_mode == mode) {
        return;
    }
    m_mode = mode;
    emit modeChanged(mode);
}

ActionMode::Mode Action::mode() const
{
    return m_mode;
}

UnitType::Type Action::chosenBuildType() const
{
    return m_chosenBuildType;
}

bool Action::tryMoveSelectedTo(int col, int row)
{
    if (m_selectedUnits.isEmpty()) {
        return false;
    }
    Unit *unit = m_selectedUnits.first();

    if (col < 0 || row < 0 || col >= m_map->getColumns() ||
            row >= m_map->getRows()) {
        return false;
    }

    Unit *obstacle = m_unitRepository->getUnitAt(QPoint(col, row));
    if (obstacle && obstacle != unit) {
        emit actionMessage("Nelze se tam dostat!");
        return false;
    }
    int dist =
        qAbs(unit->getPosition().x() - col) + qAbs(unit->getPosition().y() - row);

    if (dist > unit->getMovementPoints()) {
        emit actionMessage("Nedostatek bodů pohybu!");
        return false;
    }

    int index = m_map->getIndex(col, row);
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

// ATTACK LOGIC
bool Action::tryAttack(Unit *target)
{
    if (m_selectedUnits.isEmpty() || !target) {
        return false;
    }
    Unit *attacker = m_selectedUnits.first();

    if (attacker->isBuilding()) {
        return false;
    }

    QPoint p1 = attacker->getPosition();
    QPoint p2 = target->getPosition();
    int dist = qAbs(p1.x() - p2.x()) + qAbs(p1.y() - p2.y());

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

// highlight
QVariantList Action::reachableTiles()
{
    QVariantList tiles;
    if (m_selectedUnits.isEmpty()) {
        return tiles;
    }

    Unit *unit = m_selectedUnits.first();
    int mp = unit->getMovementPoints();
    QPoint start = unit->getPosition();

    // Scan area
    for (int x = start.x() - mp; x <= start.x() + mp; ++x) {
        for (int y = start.y() - mp; y <= start.y() + mp; ++y) {

            if (x < 0 || y < 0 || x >= m_map->getColumns() || y >=
                    m_map->getRows()) {
                continue;
            }

            int dist = qAbs(x - start.x()) + qAbs(y - start.y());
            if (dist > 0 && dist <= mp) {
                // Check Terrain
                int index = m_map->getIndex(x, y);
                Tile *tile = m_map->getTiles().at(index);
                if (tile->getType() == TileType::Water) {
                    continue;
                }

                // Only add empty tiles to the highlight
                if (!m_unitRepository->getUnitAt(QPoint(x, y))) {
                    QVariantMap tileData;
                    tileData["x"] = x;
                    tileData["y"] = y;
                    tiles.append(tileData);
                }
            }
        }
    }
    return tiles;
}

void Action::setchosenBuildType(UnitType::Type type)
{
    if (m_chosenBuildType != type) {
        m_chosenBuildType = type;
        emit chosenBuildTypeChanged();
    }
}
