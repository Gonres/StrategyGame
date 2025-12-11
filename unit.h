#ifndef UNIT_H
#define UNIT_H

#include <QObject>
#include <QQmlEngine>
#include "unit_type.h"





class Unit : public QObject{
    Q_OBJECT
    Q_PROPERTY(int health READ getHealth WRITE setHealth NOTIFY healthChanged)
    Q_PROPERTY(int maxHealth READ getMaxHealth CONSTANT)
    Q_PROPERTY(int attackDamage READ getAttackDamage CONSTANT)
    Q_PROPERTY(int attackRange READ getAttackRange CONSTANT)
    Q_PROPERTY(int movementRange READ getMovementRange CONSTANT)

private:
    UnitType::Type m_unitType;
    int m_health;
    int m_maxHealth;
    int m_attackDamage;
    int m_attackRange;
    int m_movementRange;

public:
    explicit Unit(UnitType::Type type, int health, int maxHealth, int attackDamage, int attackRange, int movementRange, QObject *parent);
    //Unit factory
    Unit* create(UnitType::Type unitType, QObject *parent);

    UnitType::Type getUnitType() const;
    int getHealth() const;
    int getMaxHealth()const;
    int getAttackDamage() const;
    int getAttackRange() const;
    int getMovementRange() const;

    void setHealth(int newHealth);

    virtual ~Unit() = default;
    virtual void attack() = 0;
signals:
    void healthChanged();
};



#endif // UNIT_H
