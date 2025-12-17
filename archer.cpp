#include "archer.h"

Archer::Archer(QPoint position, QObject *parent) : Unit(UnitType::archer, 50, 50, 20, 5, 3,
                                                            position, parent)
{}
