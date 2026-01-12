#include "game/game_controller.h"

#include "entities/units/archer.h"
#include "entities/units/warrior.h"
#include "entities/buildings/stronghold.h"
#include "entities/units/cavalry.h"

GameController::GameController(QObject *parent)
    : QObject{parent},
    m_running(false),
    m_map(GameMap(33, 35, this)),
    m_unitRepository(new UnitRepository(this)),
    m_action(m_unitRepository, &m_map, this),
    m_isPlayer1Turn(true) {}

GameMap *GameController::getMap()
{
    return &m_map;
}

UnitRepository *GameController::getUnitRepository() const
{
    return m_unitRepository;
}

Action *GameController::getAction()
{
    return &m_action;
}

bool GameController::isRunning() const
{
    return m_running;
}

QString GameController::winnerText() const
{
    return m_winnerText;
}

void GameController::startGame()
{
    m_winnerText = "";
    emit winnerTextChanged();

    m_running = true;
    emit isRunningNotify();
    m_map.generateMap();

    int midRow = m_map.getRows() / 2;
    int lastCol = m_map.getColumns() - 1;

    m_unitRepository->addPlayer1Unit(UnitType::Stronghold, QPoint{5, 5});
    m_unitRepository->addPlayer2Unit(UnitType::Stronghold, QPoint{29, 27});
    m_unitRepository->addPlayer1Unit(UnitType::Warrior, QPoint{0, midRow});
    m_unitRepository->addPlayer1Unit(UnitType::Cavalry, QPoint{0, midRow - 1});
    m_unitRepository->addPlayer1Unit(UnitType::Warrior, QPoint{0, midRow + 1});
}

void GameController::stopGame()
{
    m_running = false;
    emit isRunningNotify();

    m_action.clearSelection();
    m_unitRepository->clearUnits();

    m_isPlayer1Turn = true;
    emit turnChanged();

    m_winnerText = "";
    emit winnerTextChanged();
}

void GameController::endTurn()
{
    m_action.clearSelection();
    m_isPlayer1Turn = !m_isPlayer1Turn;
    m_action.resetTurnForCurrentPlayer(m_isPlayer1Turn);
    emit turnChanged();
}

bool GameController::isPlayer1Turn() const
{
    return m_isPlayer1Turn;
}

void GameController::checkVictory()
{
    if (!m_running) {
        return;
    }

    int p1Count = m_unitRepository->player1Units().size();
    int p2Count = m_unitRepository->player2Units().size();

    bool gameOver = false;

    if (p1Count == 0 && p2Count > 0) {
        gameOver = true;
        m_winnerText = "Vyhrál hráč 2";
    } else if (p2Count == 0 && p1Count > 0) {
        gameOver = true;
        m_winnerText = "Vyhrál hráč 1";
    } else if (p1Count == 0 && p2Count == 0) {
        if (m_running) {
            gameOver = true;
            m_winnerText = "Remíza";
        }
    }

    if (gameOver) {
        m_running = false;
        emit isRunningNotify();
        emit winnerTextChanged();
        m_action.clearSelection();
    }
}
