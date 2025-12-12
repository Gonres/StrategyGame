#ifndef TILE_H
#define TILE_H

#include "tile_type.h"
#include <QObject>

class Tile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(TileType::Type type READ getType WRITE setTileType NOTIFY typeChanged)
    Q_PROPERTY(QString color READ getColor CONSTANT)

private:
    TileType::Type m_type;

public:
    explicit Tile(TileType::Type type, QObject *parent = nullptr);

    TileType::Type getType() const;
    QString getColor() const;
    void setTileType(TileType::Type newType);

signals:
    void typeChanged();
};

#endif // TILE_H
