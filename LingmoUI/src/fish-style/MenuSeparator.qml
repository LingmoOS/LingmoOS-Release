import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T
import CuteUI 1.0 as CuteUI

T.MenuSeparator {
    id: control

    implicitHeight: CuteUI.Units.largeSpacing + separator.height
    width: parent.width

    background: Rectangle {
        id: separator
        anchors.centerIn: control
        width: control.width - CuteUI.Units.largeSpacing * 2
        height: 1
        color: CuteUI.Theme.textColor
        opacity: 0.3
    }
}