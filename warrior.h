#ifndef WARRIOR_H
#define WARRIOR_H

#include "unit.h"

class Warrior : public Unit
{
    Q_OBJECT

public:
    Warrior(QPoint position, QObject *parent);
};

#endif // WARRIOR_H
