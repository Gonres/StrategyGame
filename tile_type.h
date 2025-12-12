#ifndef TILE_TYPE_H
#define TILE_TYPE_H

#include <QObject>

namespace TileType {
Q_NAMESPACE

enum Type {
    Grass,
    Watter,
    Mountain,
    Sand
};
Q_ENUM_NS(Type)
}

#endif // TILE_TYPE_H
