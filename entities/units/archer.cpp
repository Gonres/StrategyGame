#include "entities/units/archer.h"

Archer::Archer(QPoint position, QObject *parent)
    : Unit(UnitType::Archer, 50, 20, 5, 3, position, parent)
{}
