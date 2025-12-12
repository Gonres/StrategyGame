#include "game_controller.h"
#include "warrior.h"
#include "archer.h"

GameController::GameController(QObject *parent)
    : QObject{parent},
    m_running(false),
    m_map(nullptr),
    m_player1Unit(nullptr),
    m_player2Unit(nullptr)
{
}

GameController::~GameController()
{
    if (m_map) {
        delete m_map;
        m_map = nullptr;
    }
    if (m_player1Unit) {
        delete m_player1Unit;
        m_player1Unit = nullptr;
    }
    if (m_player2Unit) {
        delete m_player2Unit;
        m_player2Unit = nullptr;
    }
}

GameMap* GameController::getMap() const
{
    return m_map;
}

bool GameController::isRunning() const
{
    return m_running;
}

Unit* GameController::player1Unit() const
{
    return m_player1Unit;
}

Unit* GameController::player2Unit() const
{
    return m_player2Unit;
}

void GameController::startGame()
{
    m_running = true;
    emit isRunningNotify();

    // nová mapa 20x20
    if (m_map) {
        delete m_map;
        m_map = nullptr;
    }
    m_map = new GameMap(20, 20, this);

    // jednotky obou hráčů – jednoduchý setup:
    // Hráč 1 = Warrior, Hráč 2 = Archer
    if (m_player1Unit) {
        delete m_player1Unit;
        m_player1Unit = nullptr;
    }
    if (m_player2Unit) {
        delete m_player2Unit;
        m_player2Unit = nullptr;
    }

    m_player1Unit = new Warrior(this);
    m_player2Unit = new Archer(this);
}
