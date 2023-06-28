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
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: _root
    implicitHeight: shown ? _contentLayout.implicitHeight : 0
    Layout.fillWidth: true
    clip: true

    default property alias content: _contentLayout.data
    property bool shown: false
    property alias spacing: _contentLayout.spacing

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutSine
        }
    }

    ColumnLayout {
        id: _contentLayout
        anchors.fill: parent
    }

    function show() {
        shown = true
    }

    function hide() {
        shown = false
    }

    function toggle() {
        shown = !shown
    }
}
