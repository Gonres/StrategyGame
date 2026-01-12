#include "entities/buildings/barracks.h"

Barracks::Barracks(QPoint position, QObject *parent) : Unit(UnitType::Barracks, 125, position,
           parent)
{}
