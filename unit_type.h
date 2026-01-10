#ifndef UNIT_TYPE_H
#define UNIT_TYPE_H

#include <QObject>

namespace UnitType {
Q_NAMESPACE

enum Type {
    Warrior,
    Archer,
    Cavalry,
    Stronghold,
};
Q_ENUM_NS(Type)
};

#endif // UNIT_TYPE_H
