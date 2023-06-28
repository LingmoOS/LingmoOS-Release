import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import CuteUI 1.0 as CuteUI

Item {
    id: control

    height: mainLayout.implicitHeight + 8 * 2

    property alias key: keyLabel.text
    property alias value: valueLabel.text

    Layout.fillWidth: true

    Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        radius: CuteUI.Theme.smallRadius
    }

    RowLayout {
        id: mainLayout
        anchors.fill: parent

        Label {
            id: keyLabel
            color: CuteUI.Theme.textColor
        }

        Item {
            Layout.fillWidth: true
        }

        Label {
            id: valueLabel
            color: CuteUI.Theme.disabledTextColor
        }
    }
}
