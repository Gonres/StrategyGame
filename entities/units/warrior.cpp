#include "entities/units/warrior.h"
#include "entities/units/unit_factory.h"

Warrior::Warrior(QPoint position, QObject *parent)
    : Unit(UnitType::Warrior, 100, 15, 1, 5, position, parent) {}

static const UnitRegister<Warrior> registerWarrior(UnitType::Warrior);
