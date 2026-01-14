#ifndef PRIEST_H
#define PRIEST_H

#include "entities/units/unit.h"

class Priest : public Unit
{
    Q_OBJECT

public:
    Priest(QPoint position, QObject *parent);

    bool canAttack() const override { return false; }
};

#endif // PRIEST_H
