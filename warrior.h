#ifndef WARRIOR_H
#define WARRIOR_H

#include "unit.h"

class Warrior: public Unit{
    Q_OBJECT
public:
    explicit Warrior(QObject *parent);
    void attack() override;
};

#endif // WARRIOR_H
