#pragma once
#include <QObject>
#include <QList>

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

// - Stables require Barracks.
// - Cavalry require Stables.
// - Warrior/Archer require Barracks.
// - Barracks require Stronghold.
inline QList<Type> prerequisites(Type t)
{
    switch (t) {
    case Stronghold:
        return {};

    case Barracks:
        return { Stronghold };

    case Stables:
        return { Barracks };

    case Warrior:
    case Archer:
        return { Barracks };

    case Cavalry:
        return { Stables };

    default:
        return {};
    }
}

} // namespace UnitType
