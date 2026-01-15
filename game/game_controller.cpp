#include "game/game_controller.h"

GameController::GameController(QObject *parent)
    : QObject(parent),
      m_map(28, 28, this),
      m_unitRepository(new UnitRepository(this)),
      m_action(m_unitRepository, &m_map, this),
      m_currentPlayerId(0)
{
    setGameConfig(2, 200);
}

GameMap *GameController::getMap()
{
    return &m_map;
}

UnitRepository *GameController::getUnitRepository()
{
    return m_unitRepository;
}

Action *GameController::getAction()
{
    return &m_action;
}

int GameController::playerCount() const
{
    return m_config.m_playerCount;
}
int GameController::currentPlayerId() const
{
    return m_currentPlayerId;
}

int GameController::currentGold() const
{
    if (m_currentPlayerId < 0 || m_currentPlayerId >= m_players.size()) {
        return 0;
    }
    return m_players[m_currentPlayerId].gold();
}

QString GameController::winnerText() const
{
    return m_winnerText;
}

void GameController::setGameConfig(int playerCount, int startGold)
{
    if (playerCount < 2) {
        playerCount = 2;
    }
    if (playerCount > 4) {
        playerCount = 4;
    }
    if (startGold < 0) {
        startGold = 0;
    }

    m_config.m_playerCount = playerCount;
    m_config.m_startGold = startGold;
    emit playerCountChanged();
}

void GameController::startGame()
{
    if (!m_winnerText.isEmpty()) {
        m_winnerText.clear();
        emit winnerTextChanged();
    }

    m_map.generateMap();
    m_unitRepository->configurePlayers(m_config.m_playerCount);
    setupPlayers();

    int cols = m_map.getColumns();
    int rows = m_map.getRows();
    int off = 4;
    QVector<QPoint> spawns = {
        QPoint(off, off),
        QPoint(cols - 1 - off, rows - 1 - off),
        QPoint(cols - 1 - off, off),
        QPoint(off, rows - 1 - off)
    };

    for (int i = 0; i < m_config.m_playerCount; i++) {
        if (i < spawns.size()) {
            m_unitRepository->addUnit(i, UnitType::Stronghold, spawns[i]);
        }
    }

    m_currentPlayerId = 0;
    emit currentPlayerIdChanged();
    emit currentGoldChanged();

    m_action.clearSelection();
    m_action.setMode(ActionMode::Move);
}

void GameController::stopGame()
{
    m_action.clearSelection();
    m_action.setMode(ActionMode::Move);

    if (!m_winnerText.isEmpty()) {
        m_winnerText.clear();
        emit winnerTextChanged();
    }

    setGameConfig(2, 200);

    m_unitRepository->clearUnits();
}

void GameController::setupPlayers()
{
    m_players.clear();
    for (int i = 0; i < m_config.m_playerCount; ++i) {
        m_players.append(Player(i, m_config.m_startGold, m_config.m_incomePerTurn));
    }
}

bool GameController::spendForCurrentPlayer(int cost, const QString &failMsg)
{
    if (!m_players[m_currentPlayerId].trySpend(cost)) {
        emit m_action.actionMessage(failMsg);
        emit currentGoldChanged();
        return false;
    }
    emit currentGoldChanged();
    return true;
}

int GameController::bankCountForPlayer(int playerId) const
{
    int count = 0;
    for (Unit *unit : m_unitRepository->allUnits()) {
        if (!unit) {
            continue;
        }
        if (unit->ownerId() != playerId) {
            continue;
        }

        if (unit->getUnitType() == UnitType::Bank) {
            count++;
        }
    }

    return count;
}

void GameController::advanceTurn()
{
    // Income for the player ending the turn
    const int banks = bankCountForPlayer(m_currentPlayerId);
    const int income = m_config.m_incomePerTurn + banks * 25;
    m_players[m_currentPlayerId].addGold(income);

    m_currentPlayerId = (m_currentPlayerId + 1) % m_players.size();
    emit currentPlayerIdChanged();
    emit currentGoldChanged();

    m_action.resetTurnForCurrentPlayer(m_currentPlayerId);
}

void GameController::endTurn()
{

    if (!m_winnerText.isEmpty()) {
        return;
    }

    m_action.setMode(ActionMode::Move);

    checkVictory();
    if (!m_winnerText.isEmpty()) {
        return;
    }

    advanceTurn();
}


void GameController::checkVictory()
{
    if (!m_winnerText.isEmpty()) {
        return;
    }
    QVector<bool> alive(m_config.m_playerCount, false);

    for (Unit *unit : m_unitRepository->allUnits()) {
        if (!unit) {
            continue;
        }

        const int hp = unit->property("health").toInt();
        if (hp <= 0) {
            continue;
        }

        const int pid = unit->ownerId();
        if (pid >= 0 && pid < alive.size()) {
            alive[pid] = true;
        }
    }

    int aliveCount = 0;
    int lastAlive = -1;
    for (int i = 0; i < alive.size(); ++i) {
        if (alive[i]) {
            aliveCount++;
            lastAlive = i;
        }
    }

    if (aliveCount == 1 && lastAlive != -1) {
        m_winnerText = QString("Vyhrál hráč %1!").arg(lastAlive + 1);
        emit winnerTextChanged();
        return;
    }

    if (aliveCount == 0) {
        m_winnerText = QString("Remíza – na mapě už nic nezůstalo.");
        emit winnerTextChanged();
    }
}
