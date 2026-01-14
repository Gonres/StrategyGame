#ifndef BANK_H
#define BANK_H

#include <QObject>
#include "entities/units/unit.h"

class Bank : public Unit
{
    Q_OBJECT

public:
    Bank(QPoint position, QObject *parent);
};

#endif // BANK_H
