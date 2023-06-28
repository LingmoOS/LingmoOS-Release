cmake_minimum_required(VERSION 3.14)

project(cute-screenshot LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core DBus Gui Widgets Quick LinguistTools REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/screenshotview.cpp
    qml.qrc
)

add_executable(cute-screenshot
  ${PROJECT_SOURCES}
)

target_link_libraries(cute-screenshot
  PRIVATE
  Qt5::Core
  Qt5::DBus
  Qt5::Gui
  Qt5::Widgets
  Qt5::Quick
)

file(GLOB TS_FILES translations/*.ts)
qt5_create_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
add_dependencies(cute-screenshot translations)

install(FILES ${QM_FILES} DESTINATION /usr/share/cute-screenshot/translations)

install(TARGETS cute-screenshot RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES
    cute-screenshot.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
