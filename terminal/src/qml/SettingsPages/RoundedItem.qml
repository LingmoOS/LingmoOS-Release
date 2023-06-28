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

import QtQuick 2.12
import QtQuick.Layouts 1.12
import CuteUI 1.0 as CuteUI

Rectangle {
    Layout.fillWidth: true

    default property alias content : _mainLayout.data
    property alias spacing: _mainLayout.spacing
    property alias layout: _mainLayout

    color: CuteUI.Theme.secondBackgroundColor
    radius: CuteUI.Theme.mediumRadius

    Behavior on color {
        ColorAnimation {
            duration: 200
            easing.type: Easing.Linear
        }
    }

    implicitHeight: _mainLayout.implicitHeight +
                    _mainLayout.anchors.topMargin +
                    _mainLayout.anchors.bottomMargin

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.leftMargin: CuteUI.Units.largeSpacing * 1.5
        anchors.rightMargin: CuteUI.Units.largeSpacing * 1.5
        anchors.topMargin: CuteUI.Units.largeSpacing
        anchors.bottomMargin: CuteUI.Units.largeSpacing
        spacing: CuteUI.Units.largeSpacing
    }
}
