#ifndef SIEGE_WORKSHOP_H
#define SIEGE_WORKSHOP_H

#include "entities/units/unit.h"

class SiegeWorkshop : public Unit
{
    Q_OBJECT
public:
    SiegeWorkshop(QPoint position, QObject *parent);
};

#endif // SIEGE_WORKSHOP_H
