#include "entities/units/priest.h"

Priest::Priest(QPoint position, QObject *parent)
    : Unit(UnitType::Priest, 65, 0, 7, 3, position, parent)
{}
