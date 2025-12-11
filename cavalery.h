#ifndef CAVALERY_H
#define CAVALERY_H

#include "unit.h"

class Cavalery: public Unit{
    Q_OBJECT
public:
    explicit Cavalery(QObject *parent);
    void attack() override;
};

#endif // CAVALERY_H
