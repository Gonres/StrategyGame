#include "game_map.h"

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
            type = TileType::Watter;
        }
        Tile* newTile = new Tile(type);
        m_map.append(newTile);
    }
}

