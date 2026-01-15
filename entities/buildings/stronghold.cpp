#include "entities/buildings/stronghold.h"
#include "entities/units/unit_factory.h"

Stronghold::Stronghold(QPoint position, QObject *parent)
    : Unit(UnitType::Stronghold, 200, position, parent) {}

static const UnitRegister<Stronghold> registerStronghold(UnitType::Stronghold);
