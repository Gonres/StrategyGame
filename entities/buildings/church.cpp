#include "entities/buildings/church.h"

Church::Church(QPoint position, QObject *parent)
    : Unit(UnitType::Church, 120, position, parent)
{}
