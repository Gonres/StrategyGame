#ifndef STRONGHOLD_H
#define STRONGHOLD_H

#include "unit.h"

class Stronghold : public Unit
{
    Q_OBJECT

public:
    Stronghold(QPoint position, QObject *parent);
};

#endif // STRONGHOLD_H
