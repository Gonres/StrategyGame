#ifndef UNIT_REPOSITORY_H
#define UNIT_REPOSITORY_H

#include "entities/units/unit.h"
#include <QObject>
#include <QQmlEngine>

class UnitRepository : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<Unit *> player1Units READ player1Units NOTIFY player1UnitsChanged)
    Q_PROPERTY(QList<Unit *> player2Units READ player2Units NOTIFY player2UnitsChanged)

public:
    explicit UnitRepository(QObject *parent = nullptr);

    QList<Unit *> player1Units() const;
    QList<Unit *> player2Units() const;

    void removeUnit(Unit *unit);
    void clearUnits();

    Q_INVOKABLE void addPlayer1Unit(UnitType::Type unitType, QPoint position);
    Q_INVOKABLE void addPlayer2Unit(UnitType::Type unitType, QPoint position);
    Q_INVOKABLE Unit *getUnitAt(QPoint position) const;

signals:
    void player1UnitsChanged();
    void player2UnitsChanged();

private:
    QList<Unit *> m_player1Units;
    QList<Unit *> m_player2Units;
};

#endif // UNIT_REPOSITORY_H
