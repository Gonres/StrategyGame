#include "entities/units/warrior.h"

Warrior::Warrior(QPoint position, QObject *parent) : Unit(UnitType::Warrior, 100, 15, 1, 5,
                                                              position,
                                                              parent)
{}
