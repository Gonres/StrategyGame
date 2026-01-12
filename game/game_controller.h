#ifndef GAME_CONTROLLER_H
#define GAME_CONTROLLER_H

#include <QObject>
#include <QQmlEngine>
#include <QVector>

#include "map/game_map.h"
#include "game/action.h"
#include "entities/units/unit_repository.h"
#include "entities/units/unit_type.h"

#include "game/game_config.h"
#include "game/player.h"

class GameController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isRunning READ isRunning NOTIFY isRunningNotify)
    Q_PROPERTY(GameMap *map READ getMap CONSTANT)
    Q_PROPERTY(UnitRepository *unitRepository READ getUnitRepository CONSTANT)
    Q_PROPERTY(Action *action READ getAction CONSTANT)

    // Multiplayer
    Q_PROPERTY(int playerCount READ playerCount NOTIFY playerCountChanged)
    Q_PROPERTY(int currentPlayerId READ currentPlayerId NOTIFY currentPlayerIdChanged)
    Q_PROPERTY(int currentGold READ currentGold NOTIFY currentGoldChanged)

    Q_PROPERTY(QString winnerText READ winnerText NOTIFY winnerTextChanged)


public:
    explicit GameController(QObject *parent = nullptr);

    bool isRunning() const;
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

    // Called by QML when player chooses a specific tile for build/train
    Q_INVOKABLE bool tryBuildAt(int x, int y);
    Q_INVOKABLE bool tryTrainAt(int x, int y);

    // Keep old API name used in QML earlier
    Q_INVOKABLE void checkVictory();
    Q_INVOKABLE int unitCost(UnitType::Type t) const;


    Q_INVOKABLE void resetToDefaults();


signals:
    void isRunningNotify();
    void playerCountChanged();
    void currentPlayerIdChanged();
    void currentGoldChanged();
    void winnerTextChanged();

private:
    void resetGame();
    void setupPlayers();
    void setupStartingUnits();
    void advanceTurn();

    bool spendForCurrentPlayer(int cost, const QString &failMsg);

private:
    bool m_running;
    GameMap m_map;
    UnitRepository *m_unitRepository;
    Action m_action;

    GameConfig m_config;
    QVector<Player> m_players;
    int m_currentPlayerId;

    QString m_winnerText;
};

#endif // GAME_CONTROLLER_H
