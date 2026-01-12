#ifndef ACTION_H
#define ACTION_H

#include "action_mode.h"
#include "map/game_map.h"
#include "entities/units/unit_repository.h"

#include <QObject>
#include <QQmlEngine>
#include <QVariantList>

#include "entities/units/unit.h"

class Action : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<Unit *> selectedUnits READ getSelectedUnits NOTIFY selectionChanged)
    Q_PROPERTY(ActionMode::Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QVariantList reachableTiles READ reachableTiles NOTIFY reachableTilesChanged)
    Q_PROPERTY(UnitType::Type chosenBuildType READ chosenBuildType WRITE setchosenBuildType NOTIFY chosenBuildTypeChanged)
    Q_PROPERTY(UnitType::Type chosenTrainType READ chosenTrainType WRITE setChosenTrainType NOTIFY chosenTrainTypeChanged)

public:
    Action(UnitRepository *unitRepository, GameMap *map, QObject *parent = nullptr);

    QList<Unit *> getSelectedUnits() const;

    void resetTurnForCurrentPlayer(bool isPlayer1Turn);

    void setMode(ActionMode::Mode mode);
    ActionMode::Mode mode() const;

    UnitType::Type chosenBuildType() const;
    UnitType::Type chosenTrainType() const;

    QVariantList reachableTiles();

    void setchosenBuildType(UnitType::Type type);
    void setChosenTrainType(UnitType::Type type);

    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void addToSelection(Unit *unit);

    // existující akce (nechávám)
    Q_INVOKABLE bool tryMoveSelectedTo(int col, int row);
    Q_INVOKABLE bool tryAttack(Unit *target);

signals:
    void selectionChanged();
    void actionMessage(QString msg);

    void modeChanged(ActionMode::Mode);
    void chosenBuildTypeChanged();
    void chosenTrainTypeChanged();
    void reachableTilesChanged();

private:
    QList<Unit *> m_selectedUnits;
    UnitRepository *m_unitRepository;
    GameMap *m_map;

    ActionMode::Mode m_mode;

    UnitType::Type m_chosenBuildType;
    UnitType::Type m_chosenTrainType;
};

#endif // ACTION_H
