#ifndef TILE_H
#define TILE_H

#include <QObject>
#include "tile_type.h"

class Tile : public QObject{
    Q_OBJECT
private:
    TileType::Type m_type;
public:
    explicit Tile(TileType::Type, QObject *parent = nullptr);
    TileType::Type getType() const;
    void setTileType(TileType::Type);
};


#endif // TILE_H
