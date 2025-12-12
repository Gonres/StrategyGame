#include "game_controller.h"
#include "tile_type.h"
#include "unit_type.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // TileType enum pro QML
    qmlRegisterUncreatableMetaObject(
        TileType::staticMetaObject,
        "StrategyGame",
        1,
        0,
        "TileType",
        "TileType is an enum");

    // UnitType enum pro QML
    qmlRegisterUncreatableMetaObject(
        UnitType::staticMetaObject,
        "StrategyGame",
        1,
        0,
        "UnitType",
        "UnitType is an enum");

    QQmlContext *context = engine.rootContext();

    GameController controller;
    context->setContextProperty("controller", &controller);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
    []() {
        QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);

    engine.loadFromModule("StrategyGame", "Main");

    return app.exec();
}
