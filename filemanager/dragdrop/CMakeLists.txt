set(SCREEN_SRCS
    draganddrop/declarativedroparea.cpp
    draganddrop/declarativedragdropevent.cpp
    draganddrop/declarativemimedata.cpp
    plugin.cpp
)

find_package(Qt5 COMPONENTS Core DBus Quick LinguistTools REQUIRED)

add_library(cutedragdrop_qmlplugins SHARED ${SCREEN_SRCS})

target_link_libraries (cutedragdrop_qmlplugins
    Qt5::Core
    Qt5::Quick
    Qt5::Gui
    Qt5::DBus
)

install(TARGETS cutedragdrop_qmlplugins DESTINATION ${INSTALL_QMLDIR}/Cute/DragDrop)
install(FILES qmldir DESTINATION ${INSTALL_QMLDIR}/Cute/DragDrop)