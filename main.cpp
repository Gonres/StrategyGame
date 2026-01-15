#include "game/action_mode.h"
#include "game/game_controller.h"
#include "map/tile_type.h"
#include "entities/units/unit_type.h"
#include "units/unit_info.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // TileType enum pro QML
    qmlRegisterUncreatableMetaObject(TileType::staticMetaObject, "StrategyGame",
                                     1, 0, "TileType", "TileType is an enum");

    // UnitType enum pro QML
    qmlRegisterUncreatableMetaObject(UnitType::staticMetaObject, "StrategyGame",
                                     1, 0, "UnitType", "UnitType is an enum");

    qmlRegisterUncreatableMetaObject(ActionMode::staticMetaObject, "StrategyGame",
                                     1, 0, "ActionMode", "ActionMode is an enum");

    qRegisterMetaType<UnitData>("UnitData");

    GameController controller;
    UnitInfo unitInfo;

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("controller", &controller);
    context->setContextProperty("unitInfo", &unitInfo);

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed, &app,
    []() {
        QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.loadFromModule("StrategyGame", "Main");

    return app.exec();
}
