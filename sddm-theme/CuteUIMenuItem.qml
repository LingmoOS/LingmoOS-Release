/*
 * Copyright (C) 2021 CuteOS.
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
import QtQuick.Templates 2.12 as T
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import CuteUI 1.0 as CuteUI

T.MenuItem
{
    id: control

    property color hoveredColor: CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.2)
                                                       : Qt.rgba(0, 0, 0, 0.1)
    property color pressedColor: CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.1)
                                                       : Qt.rgba(0, 0, 0, 0.2)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: visible ? Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                       implicitContentHeight + topPadding + bottomPadding,
                                       implicitIndicatorHeight + topPadding + bottomPadding) : 0
    verticalPadding: CuteUI.Units.smallSpacing
    hoverEnabled: true
    topPadding: CuteUI.Units.smallSpacing
    bottomPadding: CuteUI.Units.smallSpacing

    icon.width: CuteUI.Units.iconSizes.medium
    icon.height: CuteUI.Units.iconSizes.medium

    icon.color: control.enabled ? (control.highlighted ? control.CuteUI.Theme.highlightColor : control.CuteUI.Theme.textColor) :
                             control.CuteUI.Theme.disabledTextColor

    contentItem: IconLabel {
        readonly property real arrowPadding: control.subMenu && control.arrow ? control.arrow.width + control.spacing : 0
        readonly property real indicatorPadding: control.checkable && control.indicator ? control.indicator.width + control.spacing : 0
        leftPadding: !control.mirrored ? indicatorPadding + CuteUI.Units.smallSpacing * 2 : arrowPadding
        rightPadding: control.mirrored ? indicatorPadding : arrowPadding + CuteUI.Units.smallSpacing * 2

        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignLeft

        icon: control.icon
        text: control.text
        font: control.font
        color: control.enabled ? control.pressed || control.hovered ? control.CuteUI.Theme.textColor : 
               CuteUI.Theme.textColor : control.CuteUI.Theme.disabledTextColor
    }

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: control.visible ? CuteUI.Units.rowHeightAlt : 0
        radius: CuteUI.Theme.mediumRadius
        opacity: 1

        anchors {
            fill: parent
            leftMargin: CuteUI.Units.smallSpacing
            rightMargin: CuteUI.Units.smallSpacing
        }

        color: control.pressed || highlighted ? control.pressedColor : control.hovered ? control.hoveredColor : "transparent"
    }
}
