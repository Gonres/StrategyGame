#ifndef ARCHER_H
#define ARCHER_H

#include "unit.h"

class Archer : public Unit
{
    Q_OBJECT
public:
    explicit Archer(QObject *parent);

    void attack() override;
};

#endif // ARCHER_H
