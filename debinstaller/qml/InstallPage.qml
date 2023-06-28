/*
 * Copyright (C) 2021 Cute Technology Co., Ltd.
 *
 * Author:     Reion Wong <reion@cuteos.com>
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
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import CuteUI 1.0 as CuteUI
import Cute.DebInstaller 1.0

Item {
    id: control

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: CuteUI.Units.largeSpacing
        anchors.rightMargin: CuteUI.Units.largeSpacing
        anchors.bottomMargin: CuteUI.Units.largeSpacing

        RowLayout {
            Item { Layout.fillWidth: true }

            Item {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30

                Image {
                    anchors.fill: parent
                    sourceSize: Qt.size(width, height)
                    source: Installer.status === DebInstaller.Succeeded ? "qrc:/images/success.svg"
                                                                        : "qrc:/images/error.svg"
                    visible: Installer.status != DebInstaller.Installing
                }

                CuteUI.BusyIndicator {
                    anchors.fill: parent
                    width: 30
                    height: 30
                    visible: Installer.status == DebInstaller.Installing
                }
            }

            Label {
                text: Installer.statusMessage
            }

            Item { Layout.fillWidth: true }
        }

        Item {
            height: CuteUI.Units.largeSpacing
        }

        ScrollView {
            Layout.fillHeight: true
            Layout.fillWidth: true

            TextArea {
                id: _textArea
                text: Installer.statusDetails
                enabled: false

                // Auto scroll to bottom.
                onTextChanged: {
                    _textArea.cursorPosition = _textArea.text.length - 1
                }
            }
        }

        Button {
            Layout.fillWidth: true
            flat: true
            text: qsTr("Quit")
            enabled: Installer.status == DebInstaller.Succeeded
            onClicked: Qt.quit()
        }
    }
}
