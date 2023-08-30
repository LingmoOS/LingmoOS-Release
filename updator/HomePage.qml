/*
 * Copyright (C) 2021 CuteOS Team.
 *
 * Author:     Kate Leet <kate@cuteos.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CuteUI 1.0 as CuteUI
import Cute.Updator 1.0

Item {
    id: control

    property bool error: false

    Connections {
        target: updator

        function onCheckError(details) {
            control.error = true
            _textArea.text = details
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: CuteUI.Units.largeSpacing * 2

        Item {
            Layout.fillHeight: true
        }

        Image {
            width: 64
            height: 64
            sourceSize: Qt.size(width, height)
            source: "qrc:/images/check_failed.svg"
            Layout.alignment: Qt.AlignHCenter
            visible: control.error
        }

        CuteUI.BusyIndicator {
            width: 64
            height: 64
            Layout.alignment: Qt.AlignHCenter
            visible: !control.error
        }

        Label {
            text: qsTr("Checking for updates...")
            Layout.alignment: Qt.AlignHCenter
            visible: !control.error
        }

        Label {
            text: updator.checkProgress + "%"
            Layout.alignment: Qt.AlignHCenter
            color: CuteUI.Theme.disabledTextColor
            visible: !control.error
        }

        // Error

        Label {
            text: qsTr("Check for update failure")
            Layout.alignment: Qt.AlignHCenter
            color: CuteUI.Theme.disabledTextColor
            visible: control.error
        }

        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: _textArea.text != "" && control.error
            clip: true

            TextArea {
                id: _textArea
                enabled: false
                selectByMouse: true

                implicitWidth: 0

                background: Item {
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: CuteUI.Units.smallSpacing
                        anchors.leftMargin: CuteUI.Units.largeSpacing
                        anchors.rightMargin: CuteUI.Units.largeSpacing
                        radius: CuteUI.Theme.smallRadius
                        color: CuteUI.Theme.secondBackgroundColor
                    }
                }

                leftPadding: CuteUI.Units.largeSpacing * 2
                rightPadding: CuteUI.Units.largeSpacing * 2
                topPadding: CuteUI.Units.largeSpacing * 2
                bottomPadding: CuteUI.Units.largeSpacing * 2

                // Auto scroll to bottom.
                onTextChanged: {
                    _textArea.cursorPosition = _textArea.text.length - 1
                }
            }
        }

        Button {
            text: qsTr("Recheck")
            flat: true
            Layout.alignment: Qt.AlignHCenter
            visible: control.error
            onClicked: {
                control.error = false
                _textArea.clear()
                updator.checkUpdates()
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
