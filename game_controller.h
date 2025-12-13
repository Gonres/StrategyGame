#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include "game_map.h"
#include "unit.h"
#include <QObject>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)
    Q_PROPERTY(GameMap *map READ getMap CONSTANT)
    Q_PROPERTY(QList<Unit *> player1Units READ player1Units NOTIFY player1UnitsChanged)
    Q_PROPERTY(QList<Unit *> player2Units READ player2Units NOTIFY player2UnitsChanged)
    Q_PROPERTY(QList<Unit *> selectedUnits READ getSelectedUnits NOTIFY selectionChanged)
    Q_PROPERTY(bool isPlayer1Turn READ isPlayer1Turn NOTIFY turnChanged)

public:
    explicit GameController(QObject *parent = nullptr);
    ~GameController();

    bool isRunning() const;
    GameMap *getMap();
    QList<Unit *> player1Units() const;
    QList<Unit *> player2Units() const;
    QList<Unit *> getSelectedUnits() const;
    bool isPlayer1Turn() const;

    Q_INVOKABLE void clearSelection();
    Q_INVOKABLE void addToSelection(Unit *unit);
    Q_INVOKABLE void moveSelectedUnits(int targetX, int targetY);
    Q_INVOKABLE void startGame();
    Q_INVOKABLE void stopGame();
    Q_INVOKABLE void endTurn();

signals:
    void isRunningNotify();
    void selectionChanged();
    void player1UnitsChanged();
    void player2UnitsChanged();
    void turnChanged();

private:
    bool m_running;
    GameMap m_map;
    QList<Unit *> m_player1Units;
    QList<Unit *> m_player2Units;
    QList<Unit *> m_selectedUnits;
    bool m_isPlayer1Turn;
};

#endif // GAME_CONTROLLER_H
