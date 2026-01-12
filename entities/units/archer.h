#ifndef ARCHER_H
#define ARCHER_H

#include "entities/units/unit.h"

class Archer : public Unit
{
    Q_OBJECT

public:
    Archer(QPoint position, QObject *parent);
};

#endif // ARCHER_H
