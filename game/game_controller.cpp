#include "game/game_controller.h"

GameController::GameController(QObject *parent)
    : QObject(parent),
    m_running(false),
    m_map(33, 35, this),
    m_unitRepository(new UnitRepository(this)),
    m_action(m_unitRepository, &m_map, this),
    m_currentPlayerId(0)
{
    setGameConfig(2, 200);
    connect(&m_action, &Action::victoryStateMayHaveChanged,
            this, &GameController::checkVictory);
}

bool GameController::isRunning() const { return m_running; }

GameMap *GameController::getMap() { return &m_map; }
UnitRepository *GameController::getUnitRepository() { return m_unitRepository; }
Action *GameController::getAction() { return &m_action; }

int GameController::playerCount() const { return m_config.m_playerCount; }
int GameController::currentPlayerId() const { return m_currentPlayerId; }

int GameController::currentGold() const
{
    if (m_currentPlayerId < 0 || m_currentPlayerId >= m_players.size()) return 0;
    return m_players[m_currentPlayerId].gold();
}

QString GameController::winnerText() const { return m_winnerText; }

void GameController::setGameConfig(int playerCount, int startGold)
{
    if (playerCount < 2) playerCount = 2;
    if (playerCount > 4) playerCount = 4;
    if (startGold < 0) startGold = 0;

    m_config.m_playerCount = playerCount;
    m_config.m_startGold = startGold;
    emit playerCountChanged();
}

void GameController::startGame()
{
    resetGame();
    m_running = true;
    emit isRunningNotify();
}

void GameController::stopGame()
{
    resetToDefaults();
}

void GameController::resetGame()
{
    m_map.generateMap();
    m_unitRepository->configurePlayers(m_config.m_playerCount);
    setupPlayers();

    // ✅ Úvodní fáze: hráči si postupně zvolí, kam položí Stronghold.
    m_isPlacingStrongholds = true;
    m_placementIndex = 0;
    emit isPlacingStrongholdsChanged();

    m_currentPlayerId = 0;
    emit currentPlayerIdChanged();
    emit currentGoldChanged();

    m_action.clearSelection();
    m_action.setMode(ActionMode::PlaceStronghold);
    m_action.refreshReachable();
}

void GameController::resetToDefaults()
{
    m_running = false;
    m_action.clearSelection();
    m_action.setMode(ActionMode::Move);

    if (!m_winnerText.isEmpty()) {
        m_winnerText.clear();
        emit winnerTextChanged();
    }

    setGameConfig(2, 200);
    resetGame();
    emit isRunningNotify();
}

void GameController::setupPlayers()
{
    m_players.clear();
    for (int i = 0; i < m_config.m_playerCount; ++i) {
        m_players.append(Player(i, m_config.m_startGold, m_config.m_incomePerTurn));
    }
}

bool GameController::isPlacingStrongholds() const
{
    return m_isPlacingStrongholds;
}

void GameController::advancePlacementPlayer()
{
    // Posun na dalšího hráče bez income a bez resetu jednotek (zatím žádné nemá).
    m_currentPlayerId = (m_currentPlayerId + 1) % m_players.size();
    emit currentPlayerIdChanged();
    emit currentGoldChanged();

    m_action.clearSelection();
    m_action.setMode(ActionMode::PlaceStronghold);
    m_action.refreshReachable();
}

bool GameController::tryPlaceStrongholdAt(int x, int y)
{
    if (!m_running) return false;
    if (!m_isPlacingStrongholds) return false;
    if (!m_map.isValid(x, y)) return false;
    if (!m_map.isPassable(x, y)) return false; // ❌ voda / neprostupné
    if (m_unitRepository->getUnitAt(QPoint(x, y)) != nullptr) return false; // ❌ obsazeno

    m_unitRepository->addUnit(m_currentPlayerId, UnitType::Stronghold, QPoint(x, y));

    m_placementIndex++;
    if (m_placementIndex >= m_players.size()) {
        m_isPlacingStrongholds = false;
        emit isPlacingStrongholdsChanged();

        m_currentPlayerId = 0;
        emit currentPlayerIdChanged();
        emit currentGoldChanged();

        m_action.clearSelection();
        m_action.setMode(ActionMode::Move);
        m_action.resetTurnForCurrentPlayer(m_currentPlayerId);
        return true;
    }

    advancePlacementPlayer();
    return true;
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

bool GameController::tryBuildAt(int x, int y)
{
    if (!m_running) return false;
    if (m_isPlacingStrongholds) return false;
    if (!m_map.isPassable(x, y)) return false;

    const int cost = unitCost(m_action.chosenBuildType());
    if (!spendForCurrentPlayer(cost, "Nemáš dost goldu!")) return false;

    m_unitRepository->addUnit(m_currentPlayerId, m_action.chosenBuildType(), QPoint(x,y));
    return true;
}

bool GameController::tryTrainAt(int x, int y)
{
    if (!m_running) return false;
    if (m_isPlacingStrongholds) return false;
    if (!m_map.isPassable(x, y)) return false;

    const int cost = unitCost(m_action.chosenTrainType());
    if (!spendForCurrentPlayer(cost, "Nemáš dost goldu!")) return false;

    m_unitRepository->addUnit(m_currentPlayerId, m_action.chosenTrainType(), QPoint(x,y));
    return true;
}

void GameController::advanceTurn()
{
    m_currentPlayerId = (m_currentPlayerId + 1) % m_players.size();
    emit currentPlayerIdChanged();
    m_players[m_currentPlayerId].addGold(m_config.m_incomePerTurn);
    emit currentGoldChanged();
    m_action.resetTurnForCurrentPlayer(m_currentPlayerId);
}

void GameController::endTurn()
{
    if (!m_running) return;
    if (m_isPlacingStrongholds) return;
    if (!m_winnerText.isEmpty()) return;

    m_action.setMode(ActionMode::Move);

    checkVictory();
    if (!m_winnerText.isEmpty()) return;

    advanceTurn();
}

void GameController::checkVictory()
{
    if (!m_running) return;
    if (m_isPlacingStrongholds) return;

    if (!m_winnerText.isEmpty()) return;

    QVector<bool> alive(m_config.m_playerCount, false);

    const QList<Unit*> all = m_unitRepository->allUnits();
    for (Unit *u : all) {
        if (!u) continue;

        const int hp = u->property("health").toInt();
        if (hp <= 0) continue;

        const int pid = u->ownerId();
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

int GameController::unitCost(UnitType::Type type) const
{
    return UnitType::cost(type);
}
