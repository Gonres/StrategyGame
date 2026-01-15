#include "entities/buildings/barracks.h"
#include "entities/units/unit_factory.h"

Barracks::Barracks(QPoint position, QObject *parent)
    : Unit(UnitType::Barracks, 125, position, parent) {}

static const UnitRegister<Barracks> registerBarracks(UnitType::Barracks);
