#ifndef ACTION_H
#define ACTION_H

#include "action_mode.h"
#include "game_map.h"
#include "unit_repository.h"
#include <QObject>
#include <QVariantList>
#include <unit.h>

class Action : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<Unit *> selectedUnits READ getSelectedUnits NOTIFY selectionChanged)
    Q_PROPERTY(ActionMode::Mode mode READ mode WRITE setMode NOTIFY modeChanged)
    Q_PROPERTY(QVariantList reachableTiles READ reachableTiles NOTIFY reachableTilesChanged)

public:
    Action(UnitRepository *unitRepository, GameMap *map, QObject *parent = nullptr);

    QList<Unit *> getSelectedUnits() const;
    void resetTurnForCurrentPlayer(bool isPlayer1Turn);
    void setMode(ActionMode::Mode mode);
    ActionMode::Mode mode() const;
    QVariantList reachableTiles();

    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void addToSelection(Unit *unit);
    Q_INVOKABLE bool tryMoveSelectedTo(int col, int row);
    Q_INVOKABLE bool tryAttack(Unit *target);

signals:
    void selectionChanged();
    void actionMessage(QString msg);
    void modeChanged(ActionMode::Mode);
    void reachableTilesChanged();

private:
    QList<Unit *> m_selectedUnits;
    UnitRepository *m_unitRepository;
    GameMap *m_map;
    ActionMode::Mode m_mode;
};

#endif // ACTION_H
