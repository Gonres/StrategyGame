#include "game_controller.h"
#include "tile_type.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    //Globalni enum
    qmlRegisterUncreatableMetaObject(
        TileType::staticMetaObject,
        "StrategyGame",
        1, 0,
        "TileType",
        "Error: TileType is a namespace"
        );

    QQmlContext* context = engine.rootContext();

    GameController controller;
    context->setContextProperty("controller", &controller);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("StrategyGame", "Main");

    return app.exec();
}
