cmake_minimum_required(VERSION 3.5)

project(cute-sddm-theme)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

install(FILES Main.qml DESTINATION /usr/share/sddm/themes/cute)
install(FILES SessionMenu.qml DESTINATION /usr/share/sddm/themes/cute)
install(FILES UserView.qml DESTINATION /usr/share/sddm/themes/cute)
install(FILES CuteUIMenu.qml DESTINATION /usr/share/sddm/themes/cute)
install(FILES CuteUIMenuItem.qml DESTINATION /usr/share/sddm/themes/cute)
install(FILES system-shutdown-symbolic.svg DESTINATION /usr/share/sddm/themes/cute)

install(FILES theme.conf DESTINATION /usr/share/sddm/themes/cute)
install(FILES hidpi.conf DESTINATION /etc/sddm.conf.d/)
install(FILES sddm.conf DESTINATION /etc/)

# install(FILES "faces/.face.icon" DESTINATION /usr/share/sddm/faces/)
