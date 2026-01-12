#ifndef GAME_MAP_H
#define GAME_MAP_H

#include <QList>
#include <QObject>
#include <QRandomGenerator>
#include <QVector>

#include "map/tile.h"
#include "map/tile_type.h"

class GameMap : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QList<Tile *> tiles READ getTiles NOTIFY mapChanged)
    Q_PROPERTY(int rows READ getRows CONSTANT)
    Q_PROPERTY(int columns READ getColumns CONSTANT)

public:
    GameMap(unsigned int numberOfRows, unsigned int numberOfColumns, QObject *parent = nullptr);
    ~GameMap();

    void generateMap();
    int getRows() const;
    int getColumns() const;
    QList<Tile *> getTiles() const;

    Q_INVOKABLE int getIndex(unsigned int x, unsigned int y) const;
    Q_INVOKABLE bool isValid(unsigned int x, unsigned int y) const;

    // ✅ nové helpery pro “voda = nechodit/nebuildit”
    Q_INVOKABLE TileType::Type tileTypeAt(int x, int y) const;
    Q_INVOKABLE bool isPassable(int x, int y) const; // true = není voda

signals:
    void mapChanged();

private:
    QList<Tile *> m_grid;
    unsigned int m_rows;
    unsigned int m_columns;

    void clearTiles();
};

#endif // GAME_MAP_H
