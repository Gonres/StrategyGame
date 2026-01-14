#ifndef PRIEST_H
#define PRIEST_H

#include "entities/units/unit.h"

class Priest : public Unit
{
    Q_OBJECT

public:
    Priest(QPoint position, QObject *parent);
};

#endif // PRIEST_H
