#ifndef GAME_MAP_H
#define GAME_MAP_H

#include <QObject>
#include <QRandomGenerator>
#include <QVector>
#include <QList>

#include "tile.h"

class GameMap : public QObject {

    Q_OBJECT
    Q_PROPERTY(QList<QObject*> tiles READ getTiles CONSTANT)
    Q_PROPERTY(int rows READ getRows CONSTANT)
    Q_PROPERTY(int columns READ getColumns CONSTANT)

private:
    QVector<Tile*> m_map;
    unsigned int m_rows;
    unsigned int m_columns;

    void generateMap();
    void clearTiles();

public:
    explicit GameMap(unsigned int numberOfRows,
                     unsigned int numberOfColumns,
                     QObject *parent = nullptr);
    ~GameMap();

    int getRows() const;
    int getColumns() const;

    Q_INVOKABLE int  getIndex(unsigned int x, unsigned int y) const;
    Q_INVOKABLE bool isValid(unsigned int x, unsigned int y) const;

    QList<QObject*> getTiles() const;
};

#endif // GAME_MAP_H
