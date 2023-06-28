/*
 * Copyright (C) 2021 CuteOS Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
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
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI

Item {
    id: control

    property int size: 32
    height: size
    width: size

    property color hoveredColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.backgroundColor, 1.5)
                                                       : Qt.darker(CuteUI.Theme.backgroundColor, 1.2)
    property color pressedColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.backgroundColor, 1.3)
                                                       : Qt.darker(CuteUI.Theme.backgroundColor, 1.3)
    property alias source: image.source
    signal clicked()

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: control.clicked()
    }

    Image {
        id: image
        objectName: "image"
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        sourceSize: Qt.size(width, height)
        cache: true
        asynchronous: false
    }
}
