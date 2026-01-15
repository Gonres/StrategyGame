#include "entities/buildings/church.h"
#include "entities/units/unit_factory.h"

Church::Church(QPoint position, QObject *parent)
    : Unit(UnitType::Church, 120, position, parent) {}

static const UnitRegister<Church> registerChurch(UnitType::Church);
