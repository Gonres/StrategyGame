#ifndef GAME_MAP_H
#define GAME_MAP_H

#include <QObject>
#include <QRandomGenerator>
#include <QVector>
#include <QList>

#include "tile.h"

class GameMap : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<Tile *> tiles READ getTiles NOTIFY mapChanged)
    Q_PROPERTY(int rows READ getRows CONSTANT)
    Q_PROPERTY(int columns READ getColumns CONSTANT)

public:
    GameMap(unsigned int numberOfRows,
            unsigned int numberOfColumns,
            QObject *parent = nullptr);

    ~GameMap();

    void generateMap();

    int getRows() const;
    int getColumns() const;

    Q_INVOKABLE int getIndex(unsigned int x, unsigned int y) const;
    Q_INVOKABLE bool isValid(unsigned int x, unsigned int y) const;

    QList<Tile *> getTiles() const;

signals:
    void mapChanged();

private:
    QList<Tile *> m_grid;
    unsigned int m_rows;
    unsigned int m_columns;

    void clearTiles();
};

#endif // GAME_MAP_H
