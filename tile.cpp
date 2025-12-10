#include "tile.h"

Tile::Tile(TileType::Type type, QObject *parent) : QObject(parent), m_type()
{
}

TileType::Type Tile::getType() const
{
    return m_type;
}

void Tile::setTileType(TileType::Type type){
    m_type = type;
}
