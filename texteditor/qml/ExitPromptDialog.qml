/*
 * Copyright (C) 2023 CuteOS Team.
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import CuteUI 1.0 as CuteUI

CuteUI.Window {
    id: control

    property var contentWidth: _mainLayout.implicitWidth + CuteUI.Units.largeSpacing * 2
    property var contentHeight: _mainLayout.implicitHeight + header.height + CuteUI.Units.largeSpacing * 2

    flags: Qt.WindowStaysOnTopHint | Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.WindowModal
    visible: false

    width: contentWidth
    height: contentHeight
    minimumWidth: contentWidth
    minimumHeight: contentHeight
    maximumWidth: contentWidth
    maximumHeight: contentHeight
    minimizeButtonVisible: false

    background.color: CuteUI.Theme.secondBackgroundColor

    signal okBtnClicked

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        spacing: CuteUI.Units.largeSpacing
        anchors.margins: CuteUI.Units.largeSpacing

        Label {
            text: qsTr("文档未保存，您确定要关闭它吗？")
        }

        RowLayout {
            spacing: CuteUI.Units.largeSpacing

            Button {
                text: qsTr("取消")
                Layout.fillWidth: true
                onClicked: control.visible = false
            }

            Button {
                text: qsTr("确定")
                Layout.fillWidth: true
                flat: true
                onClicked: {
                    control.visible = false
                    control.okBtnClicked()
                }
            }
        }
    }
}
