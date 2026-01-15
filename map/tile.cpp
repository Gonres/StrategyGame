#include "map/tile.h"

Tile::Tile(TileType::Type type, QObject *parent)
    : QObject(parent),
      m_type(type) {}

TileType::Type Tile::getType() const
{
    return m_type;
}

QString Tile::getColor() const
{
    switch (m_type) {
    case TileType::Grass:
        return "#4caf50";
    case TileType::Water:
        return "#2196f3";
    case TileType::Mountain:
        return "#8d6e63";
    case TileType::Sand:
        return "#fdd835";
    default:
        return "#ff00ff";
    }
}

void Tile::setTileType(TileType::Type newType)
{
    if (m_type == newType) {
        return;
    }
    m_type = newType;
    emit typeChanged();
}
