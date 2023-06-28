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
import CuteUI 1.0 as CuteUI
import Cute.DebInstaller 1.0

CuteUI.Window {
    id: control
    width: 480
    height: 400
    minimumWidth: 480
    minimumHeight: 400
    maximumWidth: 480
    maximumHeight: 400
    title: qsTr("Package Installer")
    visible: true

    background.color: CuteUI.Theme.secondBackgroundColor

    headerItem: Label {
        text: control.title
        leftPadding: CuteUI.Units.largeSpacing
    }

    DragHandler {
        target: null
        acceptedDevices: PointerDevice.GenericPointer
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { control.helper.startSystemMove(control) }
    }

    DropArea {
        id: _dropArea
        anchors.fill: parent

        onDropped: {
            if (drop.hasUrls)
                Installer.fileName = drop.urls[0]
        }
    }

    Component {
        id: _homePage

        HomePage { }
    }

    Component {
        id: _appPage

        AppPage { }
    }

    Component {
        id: _installPage

        InstallPage { }
    }

    StackView {
        id: _stackView
        anchors.fill: parent
        initialItem: _homePage
    }

    Connections {
        target: Installer

        function onValidChanged() {
            if (Installer.valid)
                _stackView.push(_appPage)
        }

        function onStatusChanged() {
            if (Installer.status == DebInstaller.Installing)
                _stackView.push(_installPage)
        }

//        function onRequestSwitchToInstallPage() {
//            _stackView.push(_installPage)
//        }
    }
}
