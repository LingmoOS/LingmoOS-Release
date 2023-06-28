/*
 * Copyright (C) 2021 CuteOS Team.
 *
 * Author:     revenmartin <revenmartin@gmail.com>
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

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Cute.Settings 1.0
import CuteUI 1.0 as CuteUI
import org.kde.bluezqt 1.0 as BluezQt
import org.kde.plasma.private.bluetooth 1.0

ItemPage {
    headerTitle: qsTr("Bluetooth")

    function setBluetoothEnabled(enabled) {
        BluezQt.Manager.bluetoothBlocked = !enabled

        for (var i = 0; i < BluezQt.Manager.adapters.length; ++i) {
            var adapter = BluezQt.Manager.adapters[i];
            adapter.powered = enabled;
        }
    }

//    Label {
//        id: noBluetoothMessage
//        anchors.centerIn: parent
//        visible: BluezQt.Manager.rfkill.state === BluezQt.Rfkill.Unknown
//        text: qsTr("No Bluetooth adapters found")
//    }

    Label {
        anchors.centerIn: parent
        text: qsTr("Bluetooth is disabled")
        visible: BluezQt.Manager.operational && !BluezQt.Manager.bluetoothOperational // && !noBluetoothMessage.visible
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            anchors.bottomMargin: CuteUI.Units.largeSpacing

            Switch {
                id: bluetoothSwitch
                height: 50
                onCheckedChanged: setBluetoothEnabled(checked)
                Component.onCompleted: bluetoothSwitch.checked = BluezQt.Manager.operational
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                DevicesProxyModel {
                    id: devicesModel
                    sourceModel: BluezQt.DevicesModel { }
                }

                model: BluezQt.Manager.bluetoothOperational ? devicesModel : []

                delegate: Item {
                    width: ListView.view.width
                    height: 50

                    Rectangle {
                        anchors.fill: parent
                        color: "red"
                    }

                    ColumnLayout {
                        anchors.fill: parent

                        Label {
                            text: model.name
                        }
                    }
                }
            }
        }
    }
}
