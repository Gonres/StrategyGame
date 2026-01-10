#ifndef STABLES_H
#define STABLES_H

#include <QObject>
#include "unit.h"

class Stables : public Unit
{
    Q_OBJECT

public:
    Stables(QPoint position, QObject *parent);
};
#endif // STABLES_H
