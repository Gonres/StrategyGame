#include "entities/units/priest.h"

Priest::Priest(QPoint position, QObject *parent)
    : Unit(UnitType::Priest, 65, 14, 1, 3, position, parent)
{}
