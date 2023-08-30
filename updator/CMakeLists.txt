cmake_minimum_required(VERSION 3.14)

project(ling-updator LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick DBus LinguistTools REQUIRED)
find_package(QApt REQUIRED)

set(PROJECT_SOURCES
    main.cpp
    updatorhelper.cpp
    upgradeablemodel.cpp
    qml.qrc
)

add_executable(ling-updator
  ${PROJECT_SOURCES}
)

target_link_libraries(ling-updator
  PRIVATE
  Qt5::Core
  Qt5::Quick
  Qt5::DBus
  QApt::Main
)

file(GLOB TS_FILES translations/*.ts)
qt5_create_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
add_dependencies(ling-updator translations)

install(TARGETS ling-updator RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QM_FILES} DESTINATION /usr/share/ling-updator/translations)

install(FILES
    ling-updator.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
