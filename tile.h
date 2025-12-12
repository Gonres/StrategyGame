#ifndef TILE_H
#define TILE_H

#include <QObject>
#include "tile_type.h"

class Tile : public QObject {
    Q_OBJECT

    Q_PROPERTY(TileType::Type type READ getType WRITE setTileType NOTIFY typeChanged)

private:
    TileType::Type m_type;

public:
    explicit Tile(TileType::Type type, QObject *parent = nullptr);
    TileType::Type getType() const;
    void setTileType(TileType::Type newType);

signals:
    void typeChanged();
};

#endif // TILE_H
