#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include <QObject>
#include "game_map.h"
#include "unit.h"

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)
    Q_PROPERTY(GameMap *map READ getMap CONSTANT)
    Q_PROPERTY(Unit *player1Unit READ player1Unit CONSTANT)
    Q_PROPERTY(Unit *player2Unit READ player2Unit CONSTANT)

public:
    explicit GameController(QObject *parent = nullptr);
    ~GameController();

    bool isRunning() const;
    GameMap *getMap();

    Unit *player1Unit() const;
    Unit *player2Unit() const;

    Q_INVOKABLE void startGame();

signals:
    void isRunningNotify();

private:
    bool m_running;
    GameMap m_map;
    Unit *m_player1Unit;
    Unit *m_player2Unit;
};

#endif // GAME_CONTROLLER_H
