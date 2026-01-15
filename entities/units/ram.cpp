#include "entities/units/ram.h"
#include "entities/units/unit_factory.h"

Ram::Ram(QPoint position, QObject *parent)
    : Unit(UnitType::Ram, 300, 25, 1, 1, position, parent) {}

static const UnitRegister<Ram> registerRam(UnitType::Ram);

int Ram::damageAgainst(const Unit *target) const
{
    if (target && target->isBuilding()) {
        return getAttackDamage() * 10; // 25 -> 250
    }
    return getAttackDamage();
}
