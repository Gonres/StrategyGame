#pragma once
#include <QList>
#include <QHash>
#include <QObject>

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

inline QList<Type> prerequisites(Type t)
{
    static const auto prereqs = []() {
        QHash<Type, QList<Type>> map;
        map[Stronghold] = {};
        map[Barracks] = {Stronghold};
        map[Bank] = {Stronghold};
        map[Stables] = {Barracks};
        map[Church] = {Bank};
        map[SiegeWorkshop] = {Barracks, Stables};

        // Units
        map[Warrior] = {Barracks};
        map[Archer] = {Barracks};
        map[Cavalry] = {Stables};
        map[Priest] = {Church};
        map[Ram] = {SiegeWorkshop};

        return map;
    }
    ();

    return prereqs.value(t, {});
}

} // namespace UnitType
