#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include "map/game_map.h"
#include "game/action.h"
#include "entities/units/unit_repository.h"

#include <QObject>

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)
    Q_PROPERTY(GameMap *map READ getMap CONSTANT)
    Q_PROPERTY(UnitRepository *unitRepository READ getUnitRepository CONSTANT)
    Q_PROPERTY(Action *action READ getAction CONSTANT)
    Q_PROPERTY(bool isPlayer1Turn READ isPlayer1Turn NOTIFY turnChanged)
    Q_PROPERTY(QString winnerText READ winnerText NOTIFY winnerTextChanged)

public:
    explicit GameController(QObject *parent = nullptr);

    bool isRunning() const;
    GameMap *getMap();
    UnitRepository *getUnitRepository() const;
    Action *getAction();
    bool isPlayer1Turn() const;
    QString winnerText() const;

    Q_INVOKABLE void startGame();
    Q_INVOKABLE void stopGame();
    Q_INVOKABLE void endTurn();
    Q_INVOKABLE void checkVictory();

signals:
    void isRunningNotify();
    void turnChanged();
    void winnerTextChanged();

private:
    bool m_running;
    GameMap m_map;
    UnitRepository *m_unitRepository;
    Action m_action;
    bool m_isPlayer1Turn;
    QString m_winnerText;
};

#endif // GAME_CONTROLLER_H
