#ifndef UNIT_REPOSITORY_H
#define UNIT_REPOSITORY_H

#include "entities/units/unit.h"

#include <QObject>
#include <QQmlEngine>
#include <QVector>

// Stores all units grouped by playerId (0..playerCount-1).
// QML reads allUnits for rendering.
class UnitRepository : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QList<Unit *> allUnits READ allUnits NOTIFY unitsChanged)

public:
    explicit UnitRepository(QObject *parent = nullptr);

    // Must be called when a new game starts.
    void configurePlayers(int playerCount);

    QList<Unit *> allUnits() const;
    QList<Unit *> unitsForPlayer(int playerId) const;

    void removeUnit(Unit *unit);
    void clearUnits();

    Q_INVOKABLE void addUnit(int playerId, UnitType::Type unitType, QPoint position);
    Q_INVOKABLE Unit *getUnitAt(QPoint position) const;

signals:
    void unitsChanged();

private:
    QVector<QList<Unit *>> m_unitsByPlayer; // [playerId] => units
};

#endif // UNIT_REPOSITORY_H
