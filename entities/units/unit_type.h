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
    SiegeWorkshop,

    // Units
    Warrior,
    Archer,
    Cavalry,
    Priest,
    Ram
};
Q_ENUM_NS(Type)

inline int cost(Type t)
{
    switch (t) {
    case Stronghold:     return 500;

    case Barracks:       return 100;
    case Stables:        return 100;
    case Bank:           return 200;
    case Church:         return 250;

    case SiegeWorkshop:  return 250;

    case Warrior:        return 50;
    case Archer:         return 80;
    case Cavalry:        return 80;
    case Priest:         return 100;

    case Ram:            return 300;
    default:             return 50;
    }
}

inline QList<Type> prerequisites(Type t)
{
    switch (t) {
    case Stronghold:
        return {};

    case Barracks:
    case Bank:
        return { Stronghold };

    case Stables:
        return { Barracks };

    case Church:
        return { Bank };

    case SiegeWorkshop:
        return { Barracks, Stables };

    // Jednotky
    case Warrior:
    case Archer:
        return { Barracks };

    case Cavalry:
        return { Stables };

    case Priest:
        return { Church };

    case Ram:
        return { SiegeWorkshop };

    default:
        return {};
    }
}

} // namespace UnitType
