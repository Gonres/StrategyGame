#include "cavalry.h"

Cavalry::Cavalry(QPoint position, QObject *parent) : Unit(UnitType::Cavalry, 75, 25, 1, 10,
                                                              position,
                                                              parent)
{}
