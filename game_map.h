#ifndef GAME_MAP_H
#define GAME_MAP_H
#include <QObject>
#include <QRandomGenerator>
#include "tile.h"
#include "tile_type.h"

class GameMap : public QObject{

    Q_OBJECT
private:
    QVector<Tile*> m_map;
    unsigned int m_rows;
    unsigned int m_columns;
    void generateMap();

public:
    explicit GameMap(unsigned int numberOfRows,unsigned int numberOfCollumns,QObject *parent = nullptr);
};
#endif // GAME_MAP_H
