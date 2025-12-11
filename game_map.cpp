#include "game_map.h"
//#include <QDebug>

GameMap::GameMap(unsigned int numberOfRows, unsigned int numberOfColumns, QObject* parent)
    : QObject(parent),
    m_rows(numberOfRows),
    m_columns(numberOfColumns)
{
    generateMap();
}


void GameMap::generateMap(){

    m_map.reserve(m_rows * m_columns); //Reservation of memory

    for (unsigned int i = 0; i <m_rows * m_columns; i++){
        int rand = QRandomGenerator::global()->bounded(100);
        TileType::Type type;
        if(rand<60){
            type = TileType::Grass;
        }
        else if(rand<80){
            type = TileType::Mountain;
        }
        else if(rand<100){
            type = TileType::Water;
        }
        Tile* newTile = new Tile(type, this);
        //qDebug()<<"Tyle: " << newTile->getType();
        m_map.append(newTile);
    }
}
int GameMap::getIndex(unsigned int x, unsigned int y)const{
    return y*m_columns +x;
}
bool GameMap::isValid(unsigned int x, unsigned int y)const{
    return x >=0 && x <m_columns and y >=0 && y < m_rows;
}

int GameMap::getRows()const{
    return m_rows;
}
int GameMap::getColumns()const{
    return m_columns;
}

QList<QObject*> GameMap::getTiles() const {
    // Transfer QVector<Tile*> to QList<QObject*>
    QList<QObject*> list;
    for (Tile* t : m_map) {
        list.append(t);
    }
    return list;
}
























