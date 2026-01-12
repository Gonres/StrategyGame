#ifndef UNIT_H
#define UNIT_H

#include "entities/units/unit_type.h"
#include <QObject>
#include <QQmlEngine>
#include <qpoint.h>

class Unit : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(UnitType::Type unitType READ getUnitType CONSTANT)
    Q_PROPERTY(int health READ getHealth WRITE setHealth NOTIFY healthChanged)
    Q_PROPERTY(int maxHealth READ getMaxHealth CONSTANT)
    Q_PROPERTY(int attackDamage READ getAttackDamage CONSTANT)
    Q_PROPERTY(int attackRange READ getAttackRange CONSTANT)
    Q_PROPERTY(int movementRange READ getMovementRange CONSTANT)
    Q_PROPERTY(int movementPoints READ getMovementPoints NOTIFY movementPointsChanged)
    Q_PROPERTY(bool hasAttacked READ hasAttacked NOTIFY hasAttackedChanged)
    Q_PROPERTY(QString unitTypeName READ unitTypeToString CONSTANT)
    Q_PROPERTY(QPoint position READ getPosition NOTIFY positionChanged)
    Q_PROPERTY(bool unitSelected READ isUnitSelected NOTIFY unitSelectedChanged)
    Q_PROPERTY(bool isBuilding READ isBuilding CONSTANT)
    Q_PROPERTY(int ownerId READ ownerId WRITE setOwnerId NOTIFY ownerIdChanged)

protected:
    // Normal movable unit
    Unit(UnitType::Type type, int maxHealth, int attackDamage,
         int attackRange, int movementRange, QPoint position, QObject *parent);

    // Non movable building
    Unit(UnitType::Type type, int maxHealth, QPoint position, QObject *parent);

public:
    static Unit *create(UnitType::Type unitType, QPoint position,
                        QObject *parent);

    UnitType::Type getUnitType() const;
    int getHealth() const;
    int getMaxHealth() const;
    int getAttackDamage() const;
    int getAttackRange() const;
    int getMovementRange() const;
    int getMovementPoints() const;
    QPoint getPosition() const;
    bool isUnitSelected() const;
    bool hasAttacked() const;
    bool isBuilding() const;
    int ownerId() const;
    QString unitTypeToString() const;

    void setHealth(int newHealth);
    void setPosition(QPoint position);
    void setUnitSelected(bool selected);
    void setOwnerId(int ownerId);
    void attack(Unit *target);

    Q_INVOKABLE void resetMovement();
    Q_INVOKABLE bool spendMovement(int cost);
    Q_INVOKABLE void resetAttack();
    Q_INVOKABLE void markAttacked();

signals:
    void healthChanged();
    void positionChanged();
    void unitSelectedChanged();
    void movementPointsChanged();
    void hasAttackedChanged();
    void ownerIdChanged();

private:
    UnitType::Type m_unitType;
    int m_health;
    int m_maxHealth;
    int m_attackDamage;
    int m_attackRange;
    int m_movementRange;
    int m_movementPoints;
    bool m_hasAttacked;
    QPoint m_position;
    bool m_unitSelected;
    bool m_isBuilding;

    // Player ownership (0..3). Set by UnitRepository on spawn.
    int m_ownerId;
};

#endif // UNIT_H
