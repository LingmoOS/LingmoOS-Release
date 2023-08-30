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

    property bool success: rootWindow.updateSuccess

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: CuteUI.Units.largeSpacing

        Image {
            width: 64
            height: 64
            sourceSize: Qt.size(width, height)
            source: "image://icontheme/" + (control.success ? "process-completed-symbolic" : "process-error-symbolic")
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            visible: success
            topPadding: CuteUI.Units.largeSpacing
            text: qsTr("The update is complete and we recommend that you restart your computer.")
            Layout.alignment: Qt.AlignHCenter
        }

        Label {
            visible: !success
            topPadding: CuteUI.Units.largeSpacing
            text: qsTr("Update failed")
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            spacing: CuteUI.Units.largeSpacing

            Button {
                text: qsTr("Exit")
                Layout.fillWidth: true
                onClicked: Qt.quit()
            }

            Button {
                visible: success
                text: qsTr("Reboot")
                Layout.fillWidth: true
                flat: true
                onClicked: updator.reboot()
            }
        }
    }
}
