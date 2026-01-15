#ifndef ACTION_H
#define ACTION_H

#include <QList>
#include <QObject>
#include <QPoint>

#include "game/action_mode.h"
#include "map/game_map.h"
#include "units/unit.h"
#include "units/unit_repository.h"
#include "units/unit_type.h"

class Action : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<Unit *> selectedUnits READ selectedUnits NOTIFY
               selectedUnitsChanged)
    Q_PROPERTY(ActionMode::Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QList<QPoint> reachableTiles READ reachableTiles NOTIFY
               reachableTilesChanged)
    Q_PROPERTY(UnitType::Type chosenUnitType READ chosenUnitType WRITE
               setChosenUnitType NOTIFY chosenUnitTypeChanged)

public:
    explicit Action(UnitRepository *repository, GameMap *map,
                    QObject *parent = nullptr);

    QList<Unit *> selectedUnits() const;
    ActionMode::Mode mode() const;
    void setMode(ActionMode::Mode mode);
    QList<QPoint> reachableTiles() const;
    void  resetTurnForCurrentPlayer(int playerId);

    UnitType::Type chosenUnitType() const;

    void setChosenUnitType(UnitType::Type type);

    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void trySelectUnit(Unit *unit);
    Q_INVOKABLE bool tryMoveSelectedTo(QPoint destination);
    Q_INVOKABLE bool tryAttack(Unit *target);
    Q_INVOKABLE bool tryHeal(Unit *target);
    Q_INVOKABLE void destroyUnit(Unit *unit);
    Q_INVOKABLE bool putBoughtUnit(int x, int y, int currentPlayerId);
    Q_INVOKABLE void restUnit(Unit *unit);

signals:
    void selectedUnitsChanged();
    void modeChanged();
    void reachableTilesChanged();
    void chosenUnitTypeChanged();
    void actionMessage(const QString &msg);
    void victoryStateMayHaveChanged();

private:
    UnitRepository *m_unitRepository;
    GameMap *m_map;
    QList<Unit *> m_selectedUnits;
    ActionMode::Mode m_mode;
    QList<QPoint> m_reachableTiles;
    UnitType::Type m_chosenUnitType;

private:
    void recalcReachable();
    QList<QPoint> computeReachableForMove(Unit *unit) const;
    QList<QPoint> computeReachableForAttack(Unit *unit) const;
};

#endif // ACTION_H
