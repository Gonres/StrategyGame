#ifndef RAM_H
#define RAM_H

#include "entities/units/unit.h"

class Ram : public Unit
{
    Q_OBJECT

public:
    Ram(QPoint position, QObject *parent);

    int damageAgainst(const Unit *target) const override;
};

#endif // RAM_H
