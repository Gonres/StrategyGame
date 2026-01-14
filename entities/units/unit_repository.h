#ifndef UNIT_REPOSITORY_H
#define UNIT_REPOSITORY_H

#include "entities/units/unit.h"
#include "entities/units/unit_type.h"

#include <QObject>
#include <QQmlEngine>
#include <QVector>

// Stores all units grouped by playerId (0..playerCount-1).
class UnitRepository : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<Unit *> allUnits READ allUnits NOTIFY unitsChanged)

public:
    explicit UnitRepository(QObject *parent = nullptr);

    void configurePlayers(int playerCount);

    QList<Unit *> allUnits() const;
    QList<Unit *> unitsForPlayer(int playerId) const;

    void removeUnit(Unit *unit);
    void clearUnits();

    Q_INVOKABLE void addUnit(int playerId, UnitType::Type unitType, QPoint position);
    Q_INVOKABLE Unit *getUnitAt(QPoint position) const;

    Q_INVOKABLE bool canCreate(int playerId, UnitType::Type type) const;
    Q_INVOKABLE int countTypeForPlayer(int playerId, UnitType::Type type) const;

signals:
    void unitsChanged();

private:
    bool hasTypeForPlayer(int playerId, UnitType::Type type) const;

private:
    QVector<QList<Unit *>> m_unitsByPlayer;
};

#endif // UNIT_REPOSITORY_H
