#include "entities/units/priest.h"
#include "entities/units/unit_factory.h"

Priest::Priest(QPoint position, QObject *parent)
    : Unit(UnitType::Priest, 65, 0, 7, 3, position, parent) {}

static const UnitRegister<Priest> registerPriest(UnitType::Priest);
