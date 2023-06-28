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
import Cute.Screen 1.0 as CS
import CuteUI 1.0 as CuteUI
import "../"

ItemPage {
    headerTitle: qsTr("Display")

    Appearance {
        id: appearance
    }

    Brightness {
        id: brightness
    }

    CS.Screen {
        id: screen
    }

    Timer {
        id: brightnessTimer
        interval: 100
        repeat: false

        onTriggered: {
            brightness.setValue(brightnessSlider.value)
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: CuteUI.Units.largeSpacing * 2

            RoundedItem {
                Layout.fillWidth: true
                visible: brightness.enabled

                Label {
                    text: qsTr("Brightness")
                    color: CuteUI.Theme.disabledTextColor
                    visible: brightness.enabled
                }

                Item {
                    height: CuteUI.Units.smallSpacing / 2
                }

                RowLayout {
                    spacing: CuteUI.Units.largeSpacing

                    Image {
                        width: 16
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        Layout.alignment: Qt.AlignVCenter
                        source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-low-symbolic.svg"
                    }

                    Slider {
                        id: brightnessSlider
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        value: brightness.value
                        from: 1
                        to: 100
                        stepSize: 1
                        onMoved: brightnessTimer.start()

                        ToolTip {
                            parent: brightnessSlider.handle
                            visible: brightnessSlider.pressed
                            text: brightnessSlider.value.toFixed(0)
                        }
                    }

                    Image {
                        width: 16
                        height: width
                        sourceSize.width: width
                        sourceSize.height: height
                        Layout.alignment: Qt.AlignVCenter
                        source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark" : "light") + "/display-brightness-symbolic.svg"
                    }
                }

                Item {
                    height: CuteUI.Units.smallSpacing / 2
                }
            }

            RoundedItem {
                visible: _screenView.count > 0

                Label {
                    text: qsTr("Screen")
                    color: CuteUI.Theme.disabledTextColor
                    visible: _screenView.count > 0
                }

                ListView {
                    id: _screenView
                    Layout.fillWidth: true
                    model: screen.outputModel
                    orientation: ListView.Horizontal
                    interactive: false
                    clip: true

                    Layout.preferredHeight: currentItem ? currentItem.layout.implicitHeight + CuteUI.Units.largeSpacing : 0

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutSine
                        }
                    }

                    delegate: Item {
                        id: screenItem
                        height: ListView.view.height
                        width: ListView.view.width

                        property var element: model
                        property var layout: _mainLayout

                        ColumnLayout {
                            id: _mainLayout
                            anchors.fill: parent

                            GridLayout {
                                columns: 2
                                columnSpacing: CuteUI.Units.largeSpacing * 1.5
                                rowSpacing: CuteUI.Units.largeSpacing * 1.5

                                Label {
                                    text: qsTr("Screen Name")
                                    visible: _screenView.count > 1
                                }

                                Label {
                                    text: element.display
                                    color: CuteUI.Theme.disabledTextColor
                                    visible: _screenView.count > 1
                                }

                                Label {
                                    text: qsTr("Resolution")
                                }

                                ComboBox {
                                    Layout.fillWidth: true
                                    model: element.resolutions
                                    leftPadding: CuteUI.Units.largeSpacing
                                    rightPadding: CuteUI.Units.largeSpacing
                                    topInset: 0
                                    bottomInset: 0
                                    currentIndex: element.resolutionIndex !== undefined ?
                                                      element.resolutionIndex : -1
                                    onActivated: {
                                        element.resolutionIndex = currentIndex
                                        screen.save()
                                    }
                                }

                                Label {
                                    text: qsTr("Refresh rate")
                                }

                                ComboBox {
                                    id: refreshRate
                                    Layout.fillWidth: true
                                    model: element.refreshRates
                                    leftPadding: CuteUI.Units.largeSpacing
                                    rightPadding: CuteUI.Units.largeSpacing
                                    topInset: 0
                                    bottomInset: 0
                                    currentIndex: element.refreshRateIndex ?
                                                      element.refreshRateIndex : 0
                                    onActivated: {
                                        element.refreshRateIndex = currentIndex
                                        screen.save()
                                    }
                                }

                                Label {
                                    text: qsTr("Rotation")
                                }

                                Item {
                                    id: rotationItem
                                    Layout.fillWidth: true
                                    height: rotationLayout.implicitHeight

                                    RowLayout {
                                        id: rotationLayout
                                        anchors.fill: parent
                                        spacing: 0

                                        RotationButton {
                                            value: 0
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        RotationButton {
                                            value: 90
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        RotationButton {
                                            value: 180
                                        }

                                        Item {
                                            Layout.fillWidth: true
                                        }

                                        RotationButton {
                                            value: 270
                                        }
                                    }
                                }

                                Label {
                                    text: qsTr("Enabled")
                                    visible: enabledBox.visible
                                }

                                CheckBox {
                                    id: enabledBox
                                    checked: element.enabled
                                    visible: _screenView.count > 1
                                    onClicked: {
                                        element.enabled = checked
                                        screen.save()
                                    }
                                }
                            }
                        }
                    }
                }

                PageIndicator {
                    id: screenPageIndicator
                    Layout.alignment: Qt.AlignHCenter
                    count: _screenView.count
                    currentIndex: _screenView.currentIndex
                    onCurrentIndexChanged: _screenView.currentIndex = currentIndex
                    interactive: true
                    visible: count > 1
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Scale")
                    color: CuteUI.Theme.disabledTextColor
                }

                TabBar {
                    id: dockSizeTabbar
                    Layout.fillWidth: true

                    TabButton {
                        text: "100%"
                    }

                    TabButton {
                        text: "125%"
                    }

                    TabButton {
                        text: "150%"
                    }

                    TabButton {
                        text: "175%"
                    }

                    TabButton {
                        text: "200%"
                    }

                    currentIndex: {
                        var index = 0

                        if (appearance.devicePixelRatio <= 1.0)
                            index = 0
                        else if (appearance.devicePixelRatio <= 1.25)
                            index = 1
                        else if (appearance.devicePixelRatio <= 1.50)
                            index = 2
                        else if (appearance.devicePixelRatio <= 1.75)
                            index = 3
                        else if (appearance.devicePixelRatio <= 2.0)
                            index = 4

                        return index
                    }

                    onCurrentIndexChanged: {
                        var value = 1.0

                        switch (currentIndex) {
                        case 0:
                            value = 1.0
                            break;
                        case 1:
                            value = 1.25
                            break;
                        case 2:
                            value = 1.50
                            break;
                        case 3:
                            value = 1.75
                            break;
                        case 4:
                            value = 2.0
                            break;
                        }

                        if (appearance.devicePixelRatio !== value) {
                            appearance.setDevicePixelRatio(value)
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
