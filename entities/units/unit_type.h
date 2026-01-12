#pragma once
#include <QObject>

namespace UnitType {
Q_NAMESPACE

enum Type {
    Stronghold,
    Barracks,
    Stables,
    Warrior,
    Archer,
    Cavalry
};
Q_ENUM_NS(Type)

inline int cost(Type t) {
    switch (t) {
    case Stronghold: return 0;
    case Barracks:   return 80;
    case Stables:    return 90;
    case Warrior:    return 40;
    case Archer:     return 55;
    case Cavalry:    return 75;
    default:         return 50;
    }
}

} // namespace UnitType
