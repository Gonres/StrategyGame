#ifndef CAVALRY_H
#define CAVALRY_H

#include "unit.h"

class Cavalry : public Unit
{
    Q_OBJECT

public:
    explicit Cavalry(QPoint position, QObject *parent);

    void attack() override;
};

#endif // CAVALRY_H
