#include "game/action.h"

#include <QtMath>

static bool isPointValid(GameMap *map, QPoint p)
{
    if (!map) {
        return false;
    }
    if (p.x() < 0 || p.y() < 0) {
        return false;
    }
    return map->isValid(p.x(), p.y());
}

Action::Action(UnitRepository *repository, GameMap *map, QObject *parent)
    : QObject(parent),
      m_unitRepository(repository),
      m_map(map),
      m_mode(ActionMode::Move),
      m_chosenUnitType(UnitType::Warrior) {}

QList<Unit *> Action::selectedUnits() const
{
    return m_selectedUnits;
}

ActionMode::Mode Action::mode() const
{
    return m_mode;
}

void Action::setMode(ActionMode::Mode mode)
{
    if (m_mode == mode) {
        return;
    }
    m_mode = mode;
    emit modeChanged();
    recalcReachable();
}

QList<QPoint> Action::reachableTiles() const
{
    return m_reachableTiles;
}

void Action::clearSelection()
{
    for (Unit *unit : m_selectedUnits) {
        if (unit) {
            unit->setUnitSelected(false);
        }
    }
    m_selectedUnits.clear();
    emit selectedUnitsChanged();

    m_reachableTiles.clear();
    emit reachableTilesChanged();
}

void Action::trySelectUnit(Unit *unit)
{
    if (!unit) {
        return;
    }

    clearSelection();
    unit->setUnitSelected(true);
    m_selectedUnits.append(unit);

    emit selectedUnitsChanged();
    recalcReachable();
}

bool Action::tryMoveSelectedTo(QPoint destination)
{
    if (m_selectedUnits.isEmpty()) {
        return false;
    }

    Unit *unit = m_selectedUnits.first();
    if (!unit || unit->isBuilding()) {
        return false;
    }

    if (!isPointValid(m_map, destination)) {
        return false;
    }
    if (!m_map->isPassable(destination.x(), destination.y())) {
        return false;
    }
    if (m_unitRepository->getUnitAt(destination)) {
        return false;
    }

    const int dx = qAbs(destination.x() - unit->getPosition().x());
    const int dy = qAbs(destination.y() - unit->getPosition().y());
    const int cost = dx + dy;

    if (!unit->spendMovement(cost))
        return false;

    unit->setPosition(destination);
    recalcReachable();
    emit actionMessage("Jednotka se pohnula.");
    return true;
}

bool Action::tryAttack(Unit *target)
{
    if (m_selectedUnits.isEmpty() || !target) {
        return false;
    }

    Unit *attacker = m_selectedUnits.first();
    if (!attacker || attacker->isBuilding()) {
        return false;
    }
    if (!attacker->canAttack()) {
        return false;
    }
    if (attacker->hasAttacked()) {
        return false;
    }
    if (attacker->ownerId() == target->ownerId()) {
        return false;
    }

    const int dx = qAbs(attacker->getPosition().x() - target->getPosition().x());
    const int dy = qAbs(attacker->getPosition().y() - target->getPosition().y());
    const int dist = dx + dy;

    if (dist > attacker->getAttackRange()) {
        return false;
    }

    attacker->attack(target);
    attacker->markAttacked();

    if (target->getHealth() <= 0) {
        m_unitRepository->removeUnit(target);
        setMode(ActionMode::Move);
        emit victoryStateMayHaveChanged();
    }

    emit actionMessage("Útok!");
    emit reachableTilesChanged();
    return true;
}

bool Action::tryHeal(Unit *target)
{
    if (m_selectedUnits.isEmpty() || !target) {
        return false;
    }

    Unit *healer = m_selectedUnits.first();
    if (!healer || healer->isBuilding()) {
        return false;
    }

    if (healer->getUnitType() != UnitType::Priest) {
        return false;
    }
    if (healer->hasAttacked()) {
        return false;
    }

    if (healer->ownerId() != target->ownerId()) {
        return false;
    }

    const int dx = qAbs(healer->getPosition().x() - target->getPosition().x());
    const int dy = qAbs(healer->getPosition().y() - target->getPosition().y());
    const int dist = dx + dy;
    if (dist > healer->getAttackRange()) {
        return false;
    }

    const int maxHp = target->getMaxHealth();
    const int curHp = target->getHealth();
    if (curHp >= maxHp) {
        return false;
    }

    const int healAmount = 15;
    const int newHp = qMin(maxHp, curHp + healAmount);
    target->setHealth(newHp);

    // heal spotřebuje akci jako útok
    healer->markAttacked();

    emit actionMessage("Heal!");
    emit reachableTilesChanged();
    return true;
}

void Action::destroyUnit(Unit *unit)
{
    if (!unit) {
        return;
    }
    if (!m_unitRepository) {
        return;
    }

    setMode(ActionMode::Move);
    clearSelection();

    m_unitRepository->removeUnit(unit);
}

bool Action::putBoughtUnit(int x, int y, int currentPlayerId)
{
    if (!m_map->isPassable(x, y)) {
        return false;
    }

    m_unitRepository->addUnit(currentPlayerId, chosenUnitType(), QPoint(x, y));
    return true;
}

void Action::restUnit(Unit *unit)
{
    if (!unit) {
        return;
    }

    // jen vlastní jednotka (a ne budova)
    if (unit->isBuilding()) {
        return;
    }

    // spotřebuje akci v tahu stejně jako útok
    if (unit->hasAttacked()) {
        return;
    }

    const int maxHp = unit->getMaxHealth();
    const int curHp = unit->getHealth();
    if (curHp >= maxHp) {
        return;
    }

    // +10% z max HP, minimálně 1
    int add = maxHp / 10;
    if (add < 1)
        add = 1;

    const int newHp = qMin(maxHp, curHp + add);
    unit->setHealth(newHp);
    unit->markAttacked();

    emit actionMessage(QString("Odpočinek: +%1 HP").arg(add));
}

void Action::resetTurnForCurrentPlayer(int playerId)
{
    const QList<Unit *> units = m_unitRepository->unitsForPlayer(playerId);
    for (Unit *unit : units) {
        if (!unit || unit->isBuilding()) {
            continue;
        }
        unit->resetMovement();
        unit->resetAttack();
    }
}

// Reachable

void Action::recalcReachable()
{
    m_reachableTiles.clear();

    if (m_selectedUnits.isEmpty()) {
        emit reachableTilesChanged();
        return;
    }

    Unit *unit = m_selectedUnits.first();
    if (!unit) {
        emit reachableTilesChanged();
        return;
    }

    if (m_mode == ActionMode::Attack || m_mode == ActionMode::Heal) {
        m_reachableTiles = computeReachableForAttack(unit);
    } else {
        m_reachableTiles = computeReachableForMove(unit);
    }
    emit reachableTilesChanged();
}

QList<QPoint> Action::computeReachableForMove(Unit *unit) const
{
    QList<QPoint> out;
    const QPoint pos = unit->getPosition();
    const int range = unit->getMovementPoints();

    for (int dx = -range; dx <= range; ++dx) {
        for (int dy = -range; dy <= range; ++dy) {
            if (qAbs(dx) + qAbs(dy) > range) {
                continue;
            }

            QPoint p(pos.x() + dx, pos.y() + dy);
            if (!isPointValid(m_map, p)) {
                continue;
            }
            if (!m_map->isPassable(p.x(), p.y())) {
                continue;
            }
            if (m_unitRepository->getUnitAt(p)) {
                continue;
            }

            out.append(p);
        }
    }
    return out;
}

QList<QPoint> Action::computeReachableForAttack(Unit *unit) const
{
    QList<QPoint> out;
    const QPoint pos = unit->getPosition();
    const int range = unit->getAttackRange();

    for (int dx = -range; dx <= range; ++dx) {
        for (int dy = -range; dy <= range; ++dy) {

            if (qAbs(dx) + qAbs(dy) > range) {
                continue;
            }

            QPoint p(pos.x() + dx, pos.y() + dy);
            if (!isPointValid(m_map, p)) {
                continue;
            }

            out.append(p);
        }
    }
    return out;
}

UnitType::Type Action::chosenUnitType() const
{
    return m_chosenUnitType;
}

void Action::setChosenUnitType(UnitType::Type type)
{
    if (m_chosenUnitType == type) {
        return;
    }
    m_chosenUnitType = type;
    emit chosenUnitTypeChanged();
    recalcReachable();
}
