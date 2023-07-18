import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import Cute.Settings 1.0
import CuteUI 1.0 as CuteUI
import "../"

ItemPage {
    headerTitle: qsTr("Dock")

    Appearance {
        id: appearance
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: CuteUI.Units.largeSpacing * 2

            RoundedItem {
                Label {
                    text: qsTr("Style")
                    color: CuteUI.Theme.disabledTextColor
                }

                RowLayout {
                    spacing: CuteUI.Units.largeSpacing * 2

                    IconCheckBox {
                        source: "qrc:/images/dock_straight.svg"
                        text: qsTr("Full")
                        checked: appearance.dockStyle === 1
                        onClicked: appearance.setDockStyle(1)
                    }

                    IconCheckBox {
                        source: "qrc:/images/dock_bottom.svg"
                        text: qsTr("Center")
                        checked: appearance.dockStyle === 0
                        onClicked: appearance.setDockStyle(0)
                    }
                }
            }

            // position
           RoundedItem {
               Label {
                   text: qsTr("Position on screen")
                   color: CuteUI.Theme.disabledTextColor
               }

               RowLayout {
                   spacing: CuteUI.Units.largeSpacing * 2

                   IconCheckBox {
                       source: "qrc:/images/dock_left.svg"
                       text: qsTr("Left")
                       checked: appearance.dockDirection === 0
                       onClicked: appearance.setDockDirection(0)
                   }

                   IconCheckBox {
                       source: "qrc:/images/dock_bottom.svg"
                       text: qsTr("Bottom")
                       checked: appearance.dockDirection === 1
                       onClicked: appearance.setDockDirection(1)
                   }

                   IconCheckBox {
                       source: "qrc:/images/dock_right.svg"
                       text: qsTr("Right")
                       checked: appearance.dockDirection === 2
                       onClicked: appearance.setDockDirection(2)
                   }
               }
           }

            // Dock Size
            RoundedItem {
                Label {
                    text: qsTr("Size")
                    color: CuteUI.Theme.disabledTextColor
                }

                TabBar {
                    id: dockSizeTabbar
                    Layout.fillWidth: true
                    bottomPadding: CuteUI.Units.smallSpacing

                    TabButton {
                        text: qsTr("Small")
                    }

                    TabButton {
                        text: qsTr("Medium")
                    }

                    TabButton {
                        text: qsTr("Large")
                    }

                    TabButton {
                        text: qsTr("Huge")
                    }

                    currentIndex: {
                        var index = 0

                        if (appearance.dockIconSize <= 45)
                            index = 0
                        else if (appearance.dockIconSize <= 53)
                            index = 1
                        else if (appearance.dockIconSize <= 63)
                            index = 2
                        else if (appearance.dockIconSize <= 72)
                            index = 3

                        return index
                    }

                    onCurrentIndexChanged: {
                        var iconSize = 0

                        switch (currentIndex) {
                        case 0:
                            iconSize = 45
                            break;
                        case 1:
                            iconSize = 53
                            break;
                        case 2:
                            iconSize = 63
                            break;
                        case 3:
                            iconSize = 72
                            break;
                        }

                        appearance.setDockIconSize(iconSize)
                    }
                }
            }

            // Visibility
            RoundedItem {
                Label {
                    text: qsTr("Display mode")
                    color: CuteUI.Theme.disabledTextColor
                }

                TabBar {
                    Layout.fillWidth: true
                    currentIndex: appearance.dockVisibility
                    onCurrentIndexChanged: appearance.setDockVisibility(currentIndex)

                    TabButton {
                        text: qsTr("Always show")
                    }

                    TabButton {
                        text: qsTr("Always hide")
                    }

                    TabButton {
                        text: qsTr("Smart hide")
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
