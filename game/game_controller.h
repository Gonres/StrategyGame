#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QVector>

#include "entities/units/unit_repository.h"
#include "game/action.h"
#include "map/game_map.h"

#include "game/game_config.h"
#include "game/player.h"

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(GameMap *map READ getMap CONSTANT)
    Q_PROPERTY(UnitRepository *unitRepository READ getUnitRepository CONSTANT)
    Q_PROPERTY(Action *action READ getAction CONSTANT)
    Q_PROPERTY(QString winnerText READ winnerText NOTIFY winnerTextChanged)

    // Multiplayer
    Q_PROPERTY(int playerCount READ playerCount NOTIFY playerCountChanged)
    Q_PROPERTY(int currentPlayerId READ currentPlayerId NOTIFY currentPlayerIdChanged)
    Q_PROPERTY(int currentGold READ currentGold NOTIFY currentGoldChanged)

public:
    explicit GameController(QObject *parent = nullptr);

    GameMap *getMap();
    UnitRepository *getUnitRepository();
    Action *getAction();
    int playerCount() const;
    int currentPlayerId() const;
    int currentGold() const;
    QString winnerText() const;

    Q_INVOKABLE void setGameConfig(int playerCount, int startGold);
    Q_INVOKABLE void startGame();
    Q_INVOKABLE void stopGame();
    Q_INVOKABLE void endTurn();
    Q_INVOKABLE void checkVictory();
    Q_INVOKABLE bool spendForCurrentPlayer(int cost, const QString &failMsg);

signals:
    void playerCountChanged();
    void currentPlayerIdChanged();
    void currentGoldChanged();
    void winnerTextChanged();

private:
    void setupPlayers();
    void advanceTurn();
    int bankCountForPlayer(int playerId) const;

private:
    GameMap m_map;
    UnitRepository *m_unitRepository;
    Action m_action;
    GameConfig m_config;
    QVector<Player> m_players;
    int m_currentPlayerId;
    QString m_winnerText;
};

#endif // GAME_CONTROLLER_H
