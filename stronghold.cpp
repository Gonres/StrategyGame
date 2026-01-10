#include "stronghold.h"

Stronghold::Stronghold(QPoint position, QObject *parent) : Unit(UnitType::Stronghold, 200, position,
                                                                    parent)
{}
