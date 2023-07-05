import QtQuick 2.4
import QtQuick.Layouts 1.3
import CuteUI 1.0 as CuteUI

Item {
    id: control
    height: CuteUI.Units.largeSpacing * 2

    Layout.fillWidth: true

    Rectangle {
        anchors.centerIn: parent
        height: 1
        width: control.width
        color: CuteUI.Theme.disabledTextColor
        opacity: CuteUI.Theme.darkMode ? 0.3 : 0.1
    }
}
