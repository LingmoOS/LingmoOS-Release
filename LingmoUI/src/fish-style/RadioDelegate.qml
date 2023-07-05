import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Templates 2.4 as T
import CuteUI 1.0 as CuteUI

T.RadioDelegate {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight,
                                      indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    topPadding: control.CuteUI.Units.smallSpacing
    bottomPadding: control.CuteUI.Units.smallSpacing
    leftPadding: control.CuteUI.Units.smallSpacing
    rightPadding: control.CuteUI.Units.smallSpacing

    spacing: control.CuteUI.Units.smallSpacing

    opacity: control.enabled ? 1.0 : 0.5

    contentItem: Text {
        leftPadding: !control.mirrored ? 0 : control.indicator.width + control.spacing
        rightPadding: control.mirrored ? 0 : control.indicator.width + control.spacing

        text: control.text
        font: control.font
        color: CuteUI.Theme.textColor

        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: RadioIndicator {
        x: control.mirrored ? control.leftPadding : control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2

        control: control
    }

    background: Rectangle {
        implicitHeight: control.Suru.units.gu(7)
        color: control.Suru.backgroundColor

        HighlightFocusRectangle {
            control: control
            width: parent.width
            height: parent.height
        }

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: control.Suru.units.dp(1)
            color: control.Suru.neutralColor
        }
    }
}