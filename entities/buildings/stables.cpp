#include "entities/buildings/stables.h"
#include "entities/units/unit_factory.h"

Stables::Stables(QPoint position, QObject *parent)
    : Unit(UnitType::Stables, 150, position, parent) {}

static const UnitRegister<Stables> registerStables(UnitType::Stables);
