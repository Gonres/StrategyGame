#include "cavalry.h"

Cavalry::Cavalry(QPoint position, QObject *parent) : Unit(UnitType::cavalry, 100, 100, 20, 1, 1,
                                                              position,
                                                              parent)
{}

void Cavalry::attack()
{

}
