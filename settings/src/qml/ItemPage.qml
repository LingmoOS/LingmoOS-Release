import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import CuteUI 1.0 as CuteUI

Page {
    id: page

    property string headerTitle

    background: Rectangle {
        color: rootWindow.background.color
    }

    header: Item {
        height: rootWindow.header.height

        Label {
            anchors.left: parent.left
            leftPadding: CuteUI.Units.largeSpacing * 3
            rightPadding: Qt.application.layoutDirection === Qt.RightToLeft ? CuteUI.Units.largeSpacing * 3 : 0
            topPadding: CuteUI.Units.largeSpacing
            bottomPadding: 0
            font.pointSize: 12
            text: page.headerTitle
            color: rootWindow.active ? CuteUI.Theme.textColor : CuteUI.Theme.disabledTextColor
        }
    }
}
