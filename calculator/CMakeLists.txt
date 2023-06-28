cmake_minimum_required(VERSION 3.5)

set(PROJECT_NAME cute-calculator)
project(${PROJECT_NAME})

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT Core Gui Quick QuickControls2 LinguistTools)
find_package(Qt5 REQUIRED ${QT})
if (MSVC)
    # fix warning C4819: The file contains a character that cannot be represented in the current code page (936).
    # Save the file in Unicode format to prevent data loss
    add_compile_options("/utf-8")
endif ()
set(SRCS
    main.cpp
    calcengine.cpp
    engine/constants.cpp
    engine/evaluator.cpp
    engine/functions.cpp
    engine/hmath.cpp
    engine/number.c
)

set(RESOURCES
    qml.qrc
)

add_executable(${PROJECT_NAME} ${SRCS} ${RESOURCES})
target_link_libraries(${PROJECT_NAME}
        Qt5::Core
        Qt5::Quick
        Qt5::QuickControls2
)
if (MSVC)
    # do nothing
else()
    file(GLOB TS_FILES translations/*.ts)
    qt5_create_translation(QM_FILES ${TS_FILES})
    add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
    add_dependencies(${PROJECT_NAME} translations)
endif ()


install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION /usr/bin)

install(FILES
    cute-calculator.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)

install(FILES ${QM_FILES} DESTINATION /usr/share/${PROJECT_NAME}/translations)
