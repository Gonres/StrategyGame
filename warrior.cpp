#include "warrior.h"

Warrior::Warrior(QPoint position, QObject *parent) : Unit(UnitType::warrior, 100, 100, 15, 1, 5,
                                                              position,
                                                              parent)
{}
