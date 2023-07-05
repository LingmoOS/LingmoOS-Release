import QtQuick 2.12
import QtQuick.Controls 2.12
import CuteUI 1.0 as CuteUI

Button {
    id: control

    property color backgroundColor: CuteUI.Theme.darkMode ? "#363636" : "#FFFFFF"
    property color hoveredColor: CuteUI.Theme.darkMode ? Qt.lighter(backgroundColor, 1.3)
                                                       : Qt.darker(backgroundColor, 1.1)
    property color pressedColor: CuteUI.Theme.darkMode ? Qt.lighter(backgroundColor, 1.1)
                                                       : Qt.darker(backgroundColor, 1.2)

    scale: 1

    background: Rectangle {
        radius: CuteUI.Theme.mediumRadius
        color: control.pressed ? control.pressedColor : control.hovered ? control.hoveredColor : control.backgroundColor
    }
}
