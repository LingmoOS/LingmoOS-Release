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
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import Cute.FileManager 1.0
import CuteUI 1.0 as CuteUI

Item {
    id: control

    property string url: ""

    signal itemClicked(string path)
    signal editorAccepted(string path)

    Rectangle {
        anchors.fill: parent
        color: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.secondBackgroundColor, 1.3)
                                     : CuteUI.Theme.secondBackgroundColor
        radius: CuteUI.Theme.smallRadius
        z: -1
    }

    ListView {
        id: _pathView
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        model: _pathBarModel
        orientation: Qt.Horizontal
        layoutDirection: Qt.LeftToRight
        clip: true

        leftMargin: 3
        rightMargin: 3
        spacing: CuteUI.Units.smallSpacing

        onCountChanged: {
            _pathView.currentIndex = _pathView.count - 1
            _pathView.positionViewAtEnd()
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            onClicked: openEditor()
            z: -1
        }

        highlight: Rectangle {
            radius: CuteUI.Theme.smallRadius
            color: Qt.rgba(CuteUI.Theme.highlightColor.r,
                           CuteUI.Theme.highlightColor.g,
                           CuteUI.Theme.highlightColor.b, CuteUI.Theme.darkMode ? 0.3 : 0.1)
            smooth: true
        }

        delegate: MouseArea {
            id: _item
            height: ListView.view.height - ListView.view.topMargin - ListView.view.bottomMargin
            width: _name.width + CuteUI.Units.largeSpacing
            hoverEnabled: true
            z: -1

            property bool selected: index === _pathView.count - 1

            onClicked: control.itemClicked(model.path)

            Rectangle {
                anchors.fill: parent
                radius: CuteUI.Theme.smallRadius
                color: _item.pressed ? Qt.rgba(CuteUI.Theme.textColor.r,
                                                   CuteUI.Theme.textColor.g,
                                                   CuteUI.Theme.textColor.b, CuteUI.Theme.darkMode ? 0.05 : 0.1) :
                       _item.containsMouse ? Qt.rgba(CuteUI.Theme.textColor.r,
                                                     CuteUI.Theme.textColor.g,
                                                     CuteUI.Theme.textColor.b, CuteUI.Theme.darkMode ? 0.1 : 0.05) :
                                                              "transparent"

                smooth: true
            }

            Label {
                id: _name
                text: model.name
                anchors.centerIn: parent
                color: selected ? CuteUI.Theme.highlightColor : CuteUI.Theme.textColor
            }
        }
    }

    TextField {
        id: _pathEditor
        anchors.fill: parent
        visible: false
        selectByMouse: true
        inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhNoAutoUppercase

        text: _pathBarModel.url
        color: CuteUI.Theme.darkMode ? "white" : "black"

        background: Rectangle {
            radius: CuteUI.Theme.smallRadius
            color: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.secondBackgroundColor, 1.7)
                                         : CuteUI.Theme.secondBackgroundColor
            border.width: 1
            border.color: CuteUI.Theme.highlightColor
        }

        onAccepted: {
            control.editorAccepted(text)
            closeEditor()
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Escape)
                focus = false
        }

        onActiveFocusChanged: {
            if (!activeFocus) {
                closeEditor()
            }
        }
    }

    PathBarModel {
        id: _pathBarModel
    }

    function updateUrl(url) {
        control.url = url
        _pathBarModel.url = url
    }

    function openEditor() {
        _pathEditor.text = _pathBarModel.url
        _pathEditor.visible = true
        _pathEditor.forceActiveFocus()
        _pathEditor.selectAll()
        _pathView.visible = false
    }

    function closeEditor() {
        _pathEditor.visible = false
        _pathView.visible = true
    }
}
