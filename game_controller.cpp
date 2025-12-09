#include "game_controller.h"

GameController::GameController(QObject *parent)
    : QObject{parent} {
    m_running = false;
}

bool GameController::isRunning() const {
    return m_running;
}

void GameController::startGame() {
    m_running = true;
    emit isRunningNotify();
}
