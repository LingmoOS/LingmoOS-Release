import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import Cute.Accounts 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Mouse")

    CursorThemeModel {
        id: cursorModel
    }

    Mouse {
        id: mouse
    }

    function syncValues() {
        accelerationSlider.init()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: CuteUI.Units.largeSpacing * 2

            RoundedItem {
                GridLayout {
                    columns: 2
                    columnSpacing: CuteUI.Units.largeSpacing * 1.5
                    rowSpacing: CuteUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("Left hand")
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: mouse.leftHanded
                        rightPadding: 0
                        onCheckedChanged: mouse.leftHanded = checked
                    }

                    Label {
                        text: qsTr("Natural scrolling")
                    }

                    Switch {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight
                        checked: mouse.naturalScroll
                        onCheckedChanged: mouse.naturalScroll = checked
                        rightPadding: 0
                    }

//                    Label {
//                        text: qsTr("Mouse acceleration")
//                    }

//                    Switch {
//                        Layout.fillHeight: true
//                        Layout.alignment: Qt.AlignRight
//                        checked: mouse.acceleration
//                        onCheckableChanged: mouse.acceleration = checked
//                        rightPadding: 0
//                    }

//                    Label {
//                        text: qsTr("Disable touchpad when mouse is connected")
//                    }

//                    Switch {
//                        Layout.fillHeight: true
//                        Layout.alignment: Qt.AlignRight
//                        rightPadding: 0
//                    }
                }

                HorizontalDivider {}

                RowLayout {
                    spacing: CuteUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("Pointer speed")
                    }

                    Slider {
                        id: accelerationSlider
                        Layout.fillWidth: true
                        rightPadding: CuteUI.Units.largeSpacing
                        from: 1
                        to: 11
                        stepSize: 1

                        function init() {
                            accelerationSlider.value = 6 + mouse.pointerAcceleration / 0.2
                        }

                        Component.onCompleted: init()

                        onPressedChanged: {
                            mouse.pointerAcceleration = Math.round(((value - 6) * 0.2) * 10) / 10
                        }
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Theme")
                    color: CuteUI.Theme.disabledTextColor
                    visible: _view.count > 0
                }

                GridView {
                    id: _view
                    Layout.fillWidth: true
                    implicitHeight: Math.ceil(_view.count / rowCount) * cellHeight + CuteUI.Units.largeSpacing
                    model: cursorModel
                    interactive: false
                    visible: _view.count > 0

                    leftMargin: 0
                    rightMargin: 0

                    cellHeight: itemHeight
                    cellWidth: calcExtraSpacing(itemWidth, _view.width) + itemWidth

                    currentIndex: cursorModel.themeIndex(cursorModel.currentTheme)

                    property int rowCount: _view.width / itemWidth
                    property int itemWidth: 128
                    property int itemHeight: 128

                    function calcExtraSpacing(cellSize, containerSize) {
                        var availableColumns = Math.floor(containerSize / cellSize)
                        var extraSpacing = 0
                        if (availableColumns > 0) {
                            var allColumnSize = availableColumns * cellSize
                            var extraSpace = Math.max(containerSize - allColumnSize, 0)
                            extraSpacing = extraSpace / availableColumns
                        }
                        return Math.floor(extraSpacing)
                    }

                    delegate: Item {
                        width: GridView.view.cellWidth
                        height: GridView.view.cellHeight
                        scale: _mouseArea.pressed ? 0.95 : 1.0

                        property bool isCurrent: _view.currentIndex === index

                        Behavior on scale {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutSine
                            }
                        }

                        MouseArea {
                            id: _mouseArea
                            anchors.fill: parent
                            anchors.margins: CuteUI.Units.smallSpacing * 1.5
                            onClicked: {
                                _view.currentIndex = index
                                cursorModel.currentTheme = model.id
                                console.log(model.id)
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: CuteUI.Units.smallSpacing * 1.5
                            color: CuteUI.Theme.darkMode ? "#3C3C3C" : "#FAFAFA"
                            radius: CuteUI.Theme.mediumRadius
                            z: -1

                            border.width: isCurrent ? 3 : 0
                            border.color: CuteUI.Theme.highlightColor
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: CuteUI.Units.smallSpacing * 1.5

                            Item {
                                Layout.fillHeight: true
                            }

                            Item {
                                height: CuteUI.Units.largeSpacing
                            }

                            CuteUI.IconItem {
                                width: 22
                                height: 22
                                source: model.image
                                smooth: true
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Item {
                                Layout.fillHeight: true
                            }

                            Label {
                                text: model.name
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                                bottomPadding: CuteUI.Units.largeSpacing
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }
        }
    }
}
