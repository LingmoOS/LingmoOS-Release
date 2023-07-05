/*
 * Copyright (C) 2021 CutefishOS Team.
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
import QtQuick.Window 2.3
import QtQuick.Controls 2.4
import CuteUI 1.0 as CuteUI

Window {
    id: control
    visible: false
    color: "transparent"

    property string popupText
    property point position: Qt.point(0, 0)
    property alias backgroundOpacity: _background.opacity
    property alias backgroundColor: _background.color
    property alias blurEnabled: windowBlur.enabled
    property var borderColor: windowHelper.compositing ? CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.3)
                                                                  : Qt.rgba(0, 0, 0, 0.2) : CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.1)
                                                                                                                  : Qt.rgba(0, 0, 0, 0.05)
    flags: Qt.WindowStaysOnTopHint | Qt.WindowDoesNotAcceptFocus | Qt.ToolTip
    width: label.implicitWidth + CuteUI.Units.largeSpacing * 1.5
    height: label.implicitHeight + CuteUI.Units.largeSpacing * 1.5

    CuteUI.WindowHelper {
        id: windowHelper
    }

    CuteUI.WindowShadow {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        radius: _background.radius
    }

    CuteUI.WindowBlur {
        id: windowBlur
        view: control
        enabled: true
        windowRadius: _background.radius
        geometry: Qt.rect(_background.x, _background.y, _background.width, _background.height)
    }

    Rectangle {
        id: _background
        anchors.fill: parent
        color: CuteUI.Theme.secondBackgroundColor
        radius: windowHelper.compositing ? CuteUI.Theme.mediumRadius : 0
        border.color: control.borderColor
        border.width: 1 / Screen.devicePixelRatio
        border.pixelAligned: Screen.devicePixelRatio > 1 ? false : true

        Behavior on color {
            ColorAnimation {
                duration: control.animationEnabled ? 200 : 0
                easing.type: Easing.Linear
            }
        }
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: control.popupText
        color: CuteUI.Theme.textColor
    }

    onPositionChanged: adjustCorrectLocation()

    function adjustCorrectLocation() {
        var posX = control.position.x
        var posY = control.position.y

        // left
        if (posX <= Screen.virtualX)
            posX = Screen.virtualX + CuteUI.Units.smallSpacing

        // top
        if (posY <= Screen.virtualY)
            posY = Screen.virtualY + CuteUI.Units.smallSpacing

        // right
        if (posX + control.width > Screen.virtualX + Screen.width)
            posX = Screen.virtualX + Screen.width - control.width - 1

        // bottom
        if (posY > control.height > Screen.virtualY + Screen.width)
            posY = Screen.virtualY + Screen.width - control.width - 1

        control.x = posX
        control.y = posY
    }

    function show() {
        if (control.popupText)
            control.visible = true
    }

    function hide() {
        control.visible = false
    }
}
