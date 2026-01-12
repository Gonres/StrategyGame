#ifndef TILE_H
#define TILE_H

#include "map/tile_type.h"
#include <QObject>
#include <qqmlintegration.h>

class Tile : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(TileType::Type type READ getType WRITE setTileType NOTIFY typeChanged)
    Q_PROPERTY(QString color READ getColor CONSTANT)

public:
    explicit Tile(TileType::Type type, QObject *parent = nullptr);

    TileType::Type getType() const;
    QString getColor() const;
    void setTileType(TileType::Type newType);

signals:
    void typeChanged();

private:
    TileType::Type m_type;
};

#endif // TILE_H
