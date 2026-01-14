#ifndef UNIT_REPOSITORY_H
#define UNIT_REPOSITORY_H

#include <QObject>
#include <QQmlEngine>
#include <QVector>
#include <QList>
#include <QPoint>

#include "entities/units/unit.h"
#include "entities/units/unit_type.h"

// Ukládá všechny jednotky/budovy podle hráče (0..playerCount-1).
// QML používá allUnits pro vykreslení.
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

    // ===== Prerekvizity / helpery =====
    bool playerHasType(int playerId, UnitType::Type type) const;

    // Lze vytvořit daný typ? (splněné prerekvizity)
    Q_INVOKABLE bool canCreate(int playerId, UnitType::Type type) const;

    // Kolik daného typu hráč má (užitečné pro income z Banky apod.)
    Q_INVOKABLE int countTypeForPlayer(int playerId, UnitType::Type type) const;

    void removeUnit(Unit *unit);
    void clearUnits();

    Q_INVOKABLE void addUnit(int playerId, UnitType::Type unitType, QPoint position);
    Q_INVOKABLE Unit *getUnitAt(QPoint position) const;

signals:
    void unitsChanged();

private:
    QVector<QList<Unit *>> m_unitsByPlayer; // [playerId] => jednotky
};

#endif // UNIT_REPOSITORY_H
