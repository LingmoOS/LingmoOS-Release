import QtQuick 2.9
import QtQuick.Templates 2.2 as T
import CuteUI 1.0 as CuteUI

T.TabButton {
    id: control

    property int standardHeight: CuteUI.Units.iconSizes.medium + CuteUI.Units.smallSpacing
    property color pressedColor: Qt.rgba(CuteUI.Theme.textColor.r, CuteUI.Theme.textColor.g, CuteUI.Theme.textColor.b, 0.5)

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             standardHeight)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 0
    spacing: 0

    contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        text: control.text
        font: control.font
        color: !control.enabled ? CuteUI.Theme.disabledTextColor : control.pressed ? pressedColor : control.checked ? CuteUI.Theme.textColor : CuteUI.Theme.textColor
    }
}
