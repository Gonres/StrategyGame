#include "game_map.h"

GameMap::GameMap(unsigned int numberOfRows,
                 unsigned int numberOfColumns,
                 QObject* parent)
    : QObject(parent),
    m_rows(numberOfRows),
    m_columns(numberOfColumns)
{
    generateMap();
}

GameMap::~GameMap()
{
    clearTiles();
}

void GameMap::clearTiles()
{
    for (Tile* t : m_map) {
        delete t;
    }
    m_map.clear();
}

void GameMap::generateMap()
{
    clearTiles();
    m_map.reserve(m_rows * m_columns);

    for (unsigned int i = 0; i < m_rows * m_columns; ++i) {
        int r = QRandomGenerator::global()->bounded(100);
        TileType::Type type;

        if (r < 60) {
            type = TileType::Grass;
        } else if (r < 80) {
            type = TileType::Watter;
        } else if (r < 95) {
            type = TileType::Mountain;
        } else {
            type = TileType::Sand;
        }

        Tile* newTile = new Tile(type, this);
        m_map.append(newTile);
    }
}

int GameMap::getIndex(unsigned int x, unsigned int y) const
{
    return static_cast<int>(y * m_columns + x);
}

bool GameMap::isValid(unsigned int x, unsigned int y) const
{
    return x < m_columns && y < m_rows;
}

int GameMap::getRows() const
{
    return static_cast<int>(m_rows);
}

int GameMap::getColumns() const
{
    return static_cast<int>(m_columns);
}

QList<QObject*> GameMap::getTiles() const
{
    QList<QObject*> list;
    list.reserve(m_map.size());
    for (Tile* t : m_map) {
        list.append(t);
    }
    return list;
}
