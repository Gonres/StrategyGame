#include "entities/units/unit_factory.h"

QHash<UnitType::Type, UnitFactory::Creator> UnitFactory::s_registry{};

void UnitFactory::registerUnit(UnitType::Type type, Creator creator)
{
    s_registry.insertOrAssign(type, creator);
}

Unit *UnitFactory::createUnit(UnitType::Type type, QPoint position,
                              QObject *parent)
{
    if (!s_registry.contains(type)) {
        return nullptr;
    }
    return s_registry[type](position, parent);
}
