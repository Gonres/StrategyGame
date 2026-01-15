#include "entities/buildings/bank.h"
#include "entities/units/unit_factory.h"

Bank::Bank(QPoint position, QObject *parent)
    : Unit(UnitType::Bank, 110, position, parent) {}

static const UnitRegister<Bank> registerBank(UnitType::Bank);
