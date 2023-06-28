cmake_minimum_required(VERSION 3.14)

project(cute-debinstaller LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_MODULE_PATH
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

find_package(Qt5 COMPONENTS Core Widgets Quick LinguistTools REQUIRED)
find_package(QApt REQUIRED)
find_package(AptPkg REQUIRED)

# Find the required Libaries
include_directories(
    ${APTPKG_INCLUDE_DIR})

set(PROJECT_SOURCES
        src/main.cpp
        src/debinstaller.cpp
        qml.qrc
)

add_executable(cute-debinstaller
  ${PROJECT_SOURCES}
)

target_link_libraries(cute-debinstaller
  PRIVATE
  Qt5::Core
  Qt5::Widgets
  Qt5::Quick
  QApt
  ${APTPKG_LIBRARIES}
)

file(GLOB TS_FILES translations/*.ts)
qt5_create_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES} SOURCES ${TS_FILES})
add_dependencies(cute-debinstaller translations)

install(FILES ${QM_FILES} DESTINATION /usr/share/cute-debinstaller/translations)
install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES
    cute-debinstaller.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
