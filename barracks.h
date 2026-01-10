#ifndef BARRACKS_H
#define BARRACKS_H

#include <QObject>
#include "unit.h"

class Barracks : public Unit
{
    Q_OBJECT

public:
    Barracks(QPoint position, QObject *parent);
};

#endif // BARRACKS_H
