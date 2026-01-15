#ifndef UNIT_FACTORY_H
#define UNIT_FACTORY_H

#include "entities/units/unit.h"
#include "entities/units/unit_type.h"
#include <QHash>
#include <QPoint>
#include <functional>

class UnitFactory
{
public:
    using Creator = std::function<Unit *(QPoint, QObject *)>;

    static void registerUnit(UnitType::Type type, Creator creator);
    static Unit *createUnit(UnitType::Type type, QPoint position,
                            QObject *parent);

private:
    static QHash<UnitType::Type, Creator> s_registry;
};

template <typename T> struct UnitRegister {
    UnitRegister(UnitType::Type type)
    {
        UnitFactory::registerUnit(type, [](QPoint position, QObject * parent) {
            return new T(position, parent);
        });
    }
};

#endif // UNIT_FACTORY_H
