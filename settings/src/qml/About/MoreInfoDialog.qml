import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

import CuteUI 1.0 as CuteUI

CuteUI.Window {
    id: control

    title: qsTr("Lingmo OS info")

    width: 300
    height: 320
    minimumWidth: 300
    minimumHeight: 320
    // maximumWidth: 300
    // maximumHeight: 320
    visible: false
    // modality: Qt.WindowModal

    // property int contentWidth: _mainLayout.implicitWidth + header.height + CuteUI.Units.largeSpacing * 2
    // property int contentHeight: _mainLayout.implicitHeight + header.height + CuteUI.Units.largeSpacing * 2

    // visible: false
    // minimizeButtonVisible: false

    background.color: CuteUI.Theme.secondBackgroundColor
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    contentTopMargin: 0

    ColumnLayout {
        // id: id: _mainLayout
        anchors.fill: parent
        anchors.margins: CuteUI.Units.largeSpacing
        // anchors.topMargin: 0
        // spacing: CuteUI.Units.largeSpacing

        RoundedItem {
            StandardItem {
                key: qsTr("LingmoOS Version")
                value: about.version
            }
        }

        RowLayout {
            spacing: CuteUI.Units.largeSpacing

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Cancel")
                onClicked: control.close()
            }

            Button {
                text: qsTr("OK")
                flat: true
                // enabled: popupText.text
                onClicked: control.close()
                // onClicked: {
                //     timeZoneMap.setTimeZone(timeZoneMap.availableList[0])
                //     control.close()
                // }
            }

            Item {
                Layout.fillWidth: true
            }
        }

    }
}