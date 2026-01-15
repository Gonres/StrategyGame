cmake_minimum_required(VERSION 3.16)

project(StrategyGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Core)

qt_standard_project_setup(REQUIRES 6.8)

# main.cpp je v rootu
qt_add_executable(appStrategyGame
    main.cpp
)

qt_add_qml_module(appStrategyGame
    URI StrategyGame
    VERSION 1.0

    QML_FILES
        qml/Main.qml

        qml/style/Theme.qml

        qml/components/MenuButton.qml
        qml/components/GameMap.qml
        qml/components/UnitList.qml
        qml/components/UnitPiece.qml
        qml/components/BuyUnitButton.qml

        qml/screens/MainMenu.qml
        qml/screens/NewGameMenu.qml
        qml/screens/SettingsMenu.qml

    SOURCES
        # --- game ---
        game/game_controller.h
        game/game_controller.cpp
        game/action.h
        game/action.cpp
        game/action_mode.h

        # --- map ---
        map/tile_type.h
        map/tile.h
        map/tile.cpp
        map/game_map.h
        map/game_map.cpp

        # --- units ---
        entities/units/unit_type.h
        entities/units/unit_info.h
        entities/units/unit.h
        entities/units/unit.cpp
        entities/units/unit_factory.h
        entities/units/unit_factory.cpp
        entities/units/unit_repository.h
        entities/units/unit_repository.cpp
        entities/units/warrior.h
        entities/units/warrior.cpp
        entities/units/archer.h
        entities/units/archer.cpp
        entities/units/cavalry.h
        entities/units/cavalry.cpp

        # --- buildings ---
        entities/buildings/stronghold.h
        entities/buildings/stronghold.cpp
        entities/buildings/barracks.h
        entities/buildings/barracks.cpp
        entities/buildings/stables.h
        entities/buildings/stables.cpp
        SOURCES game/game_config.h
        SOURCES game/player.h game/player.cpp
        QML_FILES qml/screens/NewGameMenu.qml
        SOURCES entities/buildings/bank.h entities/buildings/bank.cpp
        SOURCES entities/buildings/church.h entities/buildings/church.cpp
        SOURCES entities/units/priest.h entities/units/priest.cpp
        SOURCES entities/units/ram.h entities/units/ram.cpp
        SOURCES entities/buildings/siege_workshop.h entities/buildings/siege_workshop.cpp
        QML_FILES qml/screens/HelpRules.qml
        QML_FILES
        QML_FILES qml/screens/HelpTechTree.qml
)

# aby fungovaly include typu <action.h> / <unit.h> i v qmltyperegistrations.cpp
target_include_directories(appStrategyGame PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/game
    ${CMAKE_CURRENT_SOURCE_DIR}/map
    ${CMAKE_CURRENT_SOURCE_DIR}/entities
    ${CMAKE_CURRENT_SOURCE_DIR}/entities/units
    ${CMAKE_CURRENT_SOURCE_DIR}/entities/buildings
)

set_target_properties(appStrategyGame PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appStrategyGame
    PRIVATE Qt6::Quick Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS appStrategyGame
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
