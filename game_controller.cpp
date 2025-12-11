#include "game_controller.h"

GameController::GameController(QObject *parent)
    : QObject{parent} {
    m_running = false;
}

GameMap* GameController::getMap() const
{
    return m_map;
}

bool GameController::isRunning() const {
    return m_running;
}

void GameController::startGame() {
    m_running = true;
    emit isRunningNotify();
    m_map = new GameMap(20, 20, this);
}
