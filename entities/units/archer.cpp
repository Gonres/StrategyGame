#include "entities/units/archer.h"
#include "entities/units/unit_factory.h"

Archer::Archer(QPoint position, QObject *parent)
    : Unit(UnitType::Archer, 50, 20, 5, 3, position, parent) {}

static const UnitRegister<Archer> registerArcher(UnitType::Archer);
