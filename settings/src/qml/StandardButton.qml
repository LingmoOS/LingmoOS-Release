/*
 * Copyright (C) 2023 CuteOS Team.
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
import CuteUI 1.0 as CuteUI

Button {
    id: control

    property color backgroundColor: CuteUI.Theme.darkMode ? "#363636" : "#FFFFFF"
    property color hoveredColor: CuteUI.Theme.darkMode ? Qt.lighter(backgroundColor, 1.3)
                                                       : Qt.darker(backgroundColor, 1.1)
    property color pressedColor: CuteUI.Theme.darkMode ? Qt.lighter(backgroundColor, 1.1)
                                                       : Qt.darker(backgroundColor, 1.2)

    scale: 1

    background: Rectangle {
        radius: CuteUI.Theme.mediumRadius
        color: control.pressed ? control.pressedColor : control.hovered ? control.hoveredColor : control.backgroundColor
    }
}
