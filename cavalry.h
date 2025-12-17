#ifndef CAVALRY_H
#define CAVALRY_H

#include "unit.h"

class Cavalry : public Unit
{
    Q_OBJECT

public:
    Cavalry(QPoint position, QObject *parent);
};

#endif // CAVALRY_H
