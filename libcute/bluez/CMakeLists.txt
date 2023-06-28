set(bluezqtextensionplugin_SRCS
    declarativemanager.cpp
    declarativeadapter.cpp
    # declarativebattery.cpp
    declarativedevice.cpp
    declarativeinput.cpp
    declarativemediaplayer.cpp
    declarativedevicesmodel.cpp
    bluezqtextensionplugin.cpp
    applet/devicesproxymodel.cpp
    applet/bluetoothagent.cpp
    applet/bluetoothmanager.cpp
)

add_library(cutebluez_qmlplugins SHARED ${bluezqtextensionplugin_SRCS})

find_package(KF5BluezQt REQUIRED)

target_link_libraries(cutebluez_qmlplugins
    Qt5::Core
    Qt5::Qml
    Qt5::DBus
    KF5::BluezQt
)

install(TARGETS cutebluez_qmlplugins DESTINATION ${INSTALL_QMLDIR}/Cute/Bluez)
install(FILES DevicesModel.qml DESTINATION ${INSTALL_QMLDIR}/Cute/Bluez)
install(FILES qmldir DESTINATION ${INSTALL_QMLDIR}/Cute/Bluez)
