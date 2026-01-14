#include "entities/units/ram.h"

Ram::Ram(QPoint position, QObject *parent)
    : Unit(UnitType::Ram, 300, 25, 1, 1, position, parent)
{}

int Ram::damageAgainst(const Unit *target) const
{
    if (target && target->isBuilding()) {
        return getAttackDamage() * 10; // 25 -> 250
    }
    return getAttackDamage();
}
