#include "entities/buildings/siege_workshop.h"

SiegeWorkshop::SiegeWorkshop(QPoint position, QObject *parent)
    : Unit(UnitType::SiegeWorkshop, 150, position, parent)
{}
