#ifndef CHURCH_H
#define CHURCH_H

#include <QObject>
#include "entities/units/unit.h"

class Church : public Unit
{
    Q_OBJECT

public:
    Church(QPoint position, QObject *parent);
};

#endif // CHURCH_H
