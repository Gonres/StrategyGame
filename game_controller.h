#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include <QObject>
#include "game_map.h"

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)
    Q_PROPERTY(GameMap* map READ getMap CONSTANT)

public:
    explicit GameController(QObject *parent = nullptr);

    bool isRunning() const;
    GameMap* getMap() const;

    Q_INVOKABLE void startGame();

signals:
    void isRunningNotify();

private:
    bool m_running;
    GameMap* m_map;
};

#endif // GAME_CONTROLLER_H
