project (cutedecoration)
set(CMAKE_CXX_STANDARD 11)

find_package(KF5CoreAddons REQUIRED)
find_package(KF5Config REQUIRED)
find_package(KF5WindowSystem REQUIRED)
find_package(KDecoration2 REQUIRED)
find_package(Qt5 CONFIG REQUIRED COMPONENTS Gui Widgets Core X11Extras)

set (decoration_SRCS
    decoration.cpp
    x11shadow.cpp
    button.cpp
    resources.qrc
)

add_library (cutedecoration MODULE
    ${decoration_SRCS}
)

target_link_libraries (cutedecoration
    PUBLIC
        Qt5::Core
        Qt5::Gui
        Qt5::Widgets
        Qt5::X11Extras
        KF5::ConfigCore
        KF5::ConfigGui
        KF5::CoreAddons
        KF5::WindowSystem

    PRIVATE
        KDecoration2::KDecoration
)

install (TARGETS cutedecoration
         DESTINATION ${QT_PLUGINS_DIR}/org.kde.kdecoration2)
