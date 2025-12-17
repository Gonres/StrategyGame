#include "cavalry.h"

Cavalry::Cavalry(QPoint position, QObject *parent) : Unit(UnitType::cavalry, 75, 75, 25, 1, 10,
                                                              position,
                                                              parent)
{}
