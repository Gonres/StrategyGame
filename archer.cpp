#include "archer.h"

Archer::Archer(QPoint position, QObject *parent) : Unit(UnitType::archer, 50, 50, 20, 3, 1,
                                                            position, parent)
{}

void Archer::attack()
{

}
