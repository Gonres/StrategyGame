#include "stronghold.h"

Stronghold::Stronghold(QPoint position, QObject *parent) : Unit(UnitType::Stronghold, 100, position,
                                                                    parent)
{}
