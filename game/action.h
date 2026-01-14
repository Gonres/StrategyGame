#ifndef ACTION_H
#define ACTION_H

#include <QObject>
#include <QList>
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

    Q_PROPERTY(QList<Unit*> selectedUnits READ selectedUnits NOTIFY selectedUnitsChanged)
    Q_PROPERTY(ActionMode::Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QList<QPoint> reachableTiles READ reachableTiles NOTIFY reachableTilesChanged)

    Q_PROPERTY(UnitType::Type chosenBuildType READ chosenBuildType WRITE setChosenBuildType NOTIFY chosenBuildTypeChanged)
    Q_PROPERTY(UnitType::Type chosenTrainType READ chosenTrainType WRITE setChosenTrainType NOTIFY chosenTrainTypeChanged)

public:
    explicit Action(UnitRepository *repo, GameMap *map, QObject *parent = nullptr);

    QList<Unit*> selectedUnits() const;

    ActionMode::Mode mode() const;
    void setMode(ActionMode::Mode m);

    QList<QPoint> reachableTiles() const;

    // ===== QML volá =====
    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void refreshReachable();

    Q_INVOKABLE void trySelectUnit(Unit *unit);
    Q_INVOKABLE bool tryMoveSelectedTo(QPoint dest);
    Q_INVOKABLE bool tryAttack(Unit *target);

    void resetTurnForCurrentPlayer(int playerId);

    UnitType::Type chosenBuildType() const;
    void setChosenBuildType(UnitType::Type t);

    UnitType::Type chosenTrainType() const;
    void setChosenTrainType(UnitType::Type t);

signals:
    void selectedUnitsChanged();
    void modeChanged();
    void reachableTilesChanged();

    void chosenBuildTypeChanged();
    void chosenTrainTypeChanged();

    void actionMessage(const QString &msg);

    void victoryStateMayHaveChanged();

private:
    UnitRepository *m_unitRepository;
    GameMap *m_map;

    QList<Unit*> m_selectedUnits;
    ActionMode::Mode m_mode;
    QList<QPoint> m_reachableTiles;

    UnitType::Type m_chosenBuildType;
    UnitType::Type m_chosenTrainType;

private:
    void recalcReachable();
    QList<QPoint> computeReachableForMove(Unit *u) const;
    QList<QPoint> computeReachableForBuild(Unit *u) const;
    QList<QPoint> computeReachableForStrongholdPlacement() const;
};

#endif // ACTION_H
