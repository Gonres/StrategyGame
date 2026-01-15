#ifndef UNIT_INFO_H
#define UNIT_INFO_H

#include <QObject>
#include <QString>
#include "entities/units/unit_type.h"

struct UnitData {
    Q_GADGET
    Q_PROPERTY(QString name MEMBER name CONSTANT)
    Q_PROPERTY(QString icon MEMBER icon CONSTANT)
    Q_PROPERTY(int price MEMBER price CONSTANT)

public:
    QString name;
    QString icon;
    int price;
};

Q_DECLARE_METATYPE(UnitData)

class UnitInfo : public QObject
{
    Q_OBJECT
public:
    explicit UnitInfo(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE UnitData getInfo(UnitType::Type type) const
    {
        UnitData data;

        // Defaults
        data.price = 0;
        data.icon = "❓";
        data.name = "Neznámé";

        switch (type) {
        case UnitType::Warrior:
            data.name = "Válečník";
            data.icon = "⚔️";
            data.price = 100;
            break;
        case UnitType::Archer:
            data.name = "Lučištník";
            data.icon = "🏹";
            data.price = 80;
            break;
        case UnitType::Cavalry:
            data.name = "Jezdec";
            data.icon = "🐴";
            data.price = 80;
            break;
        case UnitType::Priest:
            data.name = "Kněz";
            data.icon = "🧙";
            data.price = 100;
            break;
        case UnitType::Ram:
            data.name = "Beranidlo";
            data.icon = "🪓";
            data.price = 300;
            break;
        case UnitType::Stronghold:
            data.name = "Stronghold";
            data.icon = "🏰";
            data.price = 0;
            break;
        case UnitType::Barracks:
            data.name = "Kasárny";
            data.icon = "🏯";
            data.price = 100;
            break;
        case UnitType::Stables:
            data.name = "Stáje";
            data.icon = "🏇";
            data.price = 100;
            break;
        case UnitType::Bank:
            data.name = "Banka";
            data.icon = "🏦";
            data.price = 200;
            break;
        case UnitType::Church:
            data.name = "Kostel";
            data.icon = "⛪";
            data.price = 250;
            break;
        case UnitType::SiegeWorkshop:
            data.name = "Obléhací dílna";
            data.icon = "🏗️";
            data.price = 250;
            break;
        }
        return data;
    }
};

#endif // UNIT_INFO_H
