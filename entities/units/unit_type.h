#pragma once
#include <QObject>
#include <QList>

namespace UnitType {
Q_NAMESPACE

enum Type {
    // Buildings
    Stronghold,
    Barracks,
    Stables,
    Bank,
    Church,

    // Units
    Warrior,
    Archer,
    Cavalry,
    Priest
};
Q_ENUM_NS(Type)

inline int cost(Type t)
{
    switch (t) {
    case Stronghold: return 0;

    case Barracks:   return 80;
    case Stables:    return 90;
    case Bank:       return 110;
    case Church:     return 95;
    case Warrior:    return 40;
    case Archer:     return 55;
    case Cavalry:    return 75;
    case Priest:     return 60;
    default:         return 50;
    }
}

inline QList<Type> prerequisites(Type t)
{
    switch (t) {
    case Stronghold:
        return {};

    case Barracks:
    case Bank:
    case Church:
        return { Stronghold };

    case Stables:
        return { Barracks };

    case Warrior:
    case Archer:
        return { Barracks };

    case Cavalry:
        return { Stables };

    case Priest:
        return { Church };

    default:
        return {};
    }
}

} // namespace UnitType
