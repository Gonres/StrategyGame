#ifndef ARCHER_H
#define ARCHER_H

#include "unit.h"

class Archer : public Unit
{
    Q_OBJECT

public:
    explicit Archer(QPoint position, QObject *parent);

    void attack() override;
};

#endif // ARCHER_H
