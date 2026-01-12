#ifndef ACTION_H
#define ACTION_H

#include "game/action_mode.h"
#include "map/game_map.h"
#include "entities/units/unit_repository.h"
#include "entities/units/unit.h"

#include <QObject>
#include <QVariantList>
#include <QQmlEngine>


class Action : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<Unit *> selectedUnits READ getSelectedUnits NOTIFY selectionChanged)
    Q_PROPERTY(ActionMode::Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QVariantList reachableTiles READ reachableTiles NOTIFY reachableTilesChanged)
    Q_PROPERTY(UnitType::Type chosenBuildType READ chosenBuildType WRITE setchosenBuildType NOTIFY
                   chosenBuildTypeChanged)

public:
    Action(UnitRepository *unitRepository, GameMap *map, QObject *parent = nullptr);

    QList<Unit *> getSelectedUnits() const;
    void resetTurnForCurrentPlayer(bool isPlayer1Turn);
    void setMode(ActionMode::Mode mode);
    ActionMode::Mode mode() const;
    UnitType::Type chosenBuildType() const;
    QVariantList reachableTiles();

    void setchosenBuildType(UnitType::Type type);

    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void addToSelection(Unit *unit);
    Q_INVOKABLE bool tryMoveSelectedTo(int col, int row);
    Q_INVOKABLE bool tryAttack(Unit *target);

signals:
    void selectionChanged();
    void actionMessage(QString msg);
    void modeChanged(ActionMode::Mode);
    void chosenBuildTypeChanged();
    void reachableTilesChanged();

private:
    QList<Unit *> m_selectedUnits;
    UnitRepository *m_unitRepository;
    GameMap *m_map;
    ActionMode::Mode m_mode;
    UnitType::Type m_chosenBuildType;
};

#endif // ACTION_H
