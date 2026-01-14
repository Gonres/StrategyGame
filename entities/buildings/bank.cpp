#include "entities/buildings/bank.h"

Bank::Bank(QPoint position, QObject *parent)
    : Unit(UnitType::Bank, 110, position, parent)
{}
