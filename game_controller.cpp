#include "game_controller.h"
#include "archer.h"
#include "warrior.h"

GameController::GameController(QObject *parent)
    : QObject{parent},
      m_running(false),
      m_map(GameMap(20, 20, this)),
      m_player1Units(),
      m_player2Units(),
      m_selectedUnits(),
      m_isPlayer1Turn(true) {}

GameController::~GameController()
{
    m_selectedUnits.clear();

    qDeleteAll(m_player1Units);
    m_player1Units.clear();

    qDeleteAll(m_player2Units);
    m_player2Units.clear();
}

GameMap *GameController::getMap()
{
    return &m_map;
}

bool GameController::isRunning() const
{
    return m_running;
}

QList<Unit *> GameController::player1Units() const
{
    return m_player1Units;
}

QList<Unit *> GameController::player2Units() const
{
    return m_player2Units;
}

void GameController::startGame()
{
    m_running = true;
    emit isRunningNotify();
    m_map.generateMap();

    int midRow = m_map.getRows() / 2;
    int lastCol = m_map.getColumns() - 1;

    m_player1Units.append(new Warrior(QPoint{0, midRow}, this));
    m_player1Units.append(new Warrior(QPoint{0, midRow - 1}, this));
    m_player1Units.append(new Warrior(QPoint{0, midRow + 1}, this));
    emit player1UnitsChanged();

    m_player2Units.append(new Archer(QPoint{lastCol, midRow}, this));
    m_player2Units.append(new Archer(QPoint{lastCol, midRow - 1}, this));
    m_player2Units.append(new Archer(QPoint{lastCol, midRow + 1}, this));
    emit player2UnitsChanged();
}

void GameController::stopGame()
{
    m_selectedUnits.clear();
    emit selectionChanged();

    qDeleteAll(m_player1Units);
    m_player1Units.clear();
    emit player1UnitsChanged();

    qDeleteAll(m_player2Units);
    m_player2Units.clear();
    emit player2UnitsChanged();

    m_running = false;
    emit isRunningNotify();
}

void GameController::endTurn()
{
    clearSelection();
    m_isPlayer1Turn = !m_isPlayer1Turn;
    emit turnChanged();
}

QList<Unit *> GameController::getSelectedUnits() const
{
    return m_selectedUnits;
}

bool GameController::isPlayer1Turn() const
{
    return m_isPlayer1Turn;
}

void GameController::clearSelection()
{
    if (!m_selectedUnits.isEmpty()) {
        for (Unit *unit : m_selectedUnits) {
            unit->setUnitSelected(false);
        }
        m_selectedUnits.clear();
        emit selectionChanged();
    }
}

void GameController::addToSelection(Unit *unit)
{
    if (unit && !m_selectedUnits.contains(unit)) {
        m_selectedUnits.append(unit);
        unit->setUnitSelected(true);
        qDebug() << "Unit added to selection! Total selected:" << m_selectedUnits.size();
        emit selectionChanged();
    }
}

void GameController::moveSelectedUnits(int targetX, int targetY)
{
    if (m_selectedUnits.isEmpty()) {
        return;
    }

    QPoint targetPos{targetX, targetY};

    for (Unit *unit : m_selectedUnits) {
        if (unit) {
            qDebug() << "Moving unit" << unit << "to" << targetPos;
            unit->setPosition(targetPos);
        }
    }
}
