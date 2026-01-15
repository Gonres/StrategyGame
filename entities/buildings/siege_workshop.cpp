#include "entities/buildings/siege_workshop.h"
#include "entities/units/unit_factory.h"

SiegeWorkshop::SiegeWorkshop(QPoint position, QObject *parent)
    : Unit(UnitType::SiegeWorkshop, 150, position, parent) {}

static const UnitRegister<SiegeWorkshop> registerSiegeWorkshop(UnitType::SiegeWorkshop);
