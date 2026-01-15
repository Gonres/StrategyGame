#include "entities/units/cavalry.h"
#include "entities/units/unit_factory.h"

Cavalry::Cavalry(QPoint position, QObject *parent)
    : Unit(UnitType::Cavalry, 75, 25, 1, 10, position, parent) {}

static const UnitRegister<Cavalry> registerCavalry(UnitType::Cavalry);
