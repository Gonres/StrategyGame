#include "warrior.h"

Warrior::Warrior(QPoint position, QObject *parent) : Unit(UnitType::warrior, 100, 100, 20, 1, 1,
                                                              position,
                                                              parent)
{}

void Warrior::attack()
{

}
