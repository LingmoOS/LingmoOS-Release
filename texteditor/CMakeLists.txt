cmake_minimum_required(VERSION 3.14)

project(cute-texteditor LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT Core Gui Quick QuickControls2 LinguistTools)
find_package(Qt5 REQUIRED ${QT})

find_package(Qt5 COMPONENTS Core Widgets Quick REQUIRED)
find_package(KF5SyntaxHighlighting)

set(PROJECT_SOURCES
        src/main.cpp
        src/documenthandler.cpp
        src/highlightmodel.cpp
        src/texteditor.cpp
        qml.qrc
)

add_executable(cute-texteditor
  ${PROJECT_SOURCES}
)

target_link_libraries(cute-texteditor
  PRIVATE
  Qt5::Core
  Qt5::Widgets
  Qt5::Quick
  KF5::SyntaxHighlighting
  )

file(GLOB TS_FILES translations/*.ts)
qt5_create_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
add_dependencies(cute-texteditor translations)
  
install(TARGETS cute-texteditor RUNTIME DESTINATION /usr/bin)
install(FILES ${QM_FILES} DESTINATION /usr/share/cute-texteditor/translations)

install(FILES
    cute-texteditor.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
