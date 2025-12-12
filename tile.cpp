#include "tile.h"

Tile::Tile(TileType::Type type, QObject *parent)
    : QObject(parent),
    m_type(type)
{
}

TileType::Type Tile::getType() const
{
    return m_type;
}

void Tile::setTileType(TileType::Type newType)
{
    if (m_type == newType)
        return;

    m_type = newType;
    emit typeChanged();
}
