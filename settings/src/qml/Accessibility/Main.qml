import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import Cute.Accounts 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Accessibility")

    Accessibility {
        id: accessibility
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
                    text: qsTr("Appearance enhancement")
                    color: CuteUI.Theme.disabledTextColor
                    visible: _view.count > 0
                }

                RowLayout {
                    Label {
                        text: qsTr("Deform windows while they are moving")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: accessibility.wobblyWindows
                        Layout.fillHeight: true
                        onClicked: accessibility.wobblyWindows = checked
                    }
                }

                RowLayout {
                    Label {
                        text: qsTr("Display window thumbnails on the edge of the screen")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: accessibility.thumbnailaside
                        Layout.fillHeight: true
                        onClicked: accessibility.thumbnailaside = checked
                    }
                }

                RowLayout {
                    Label {
                        text: qsTr("Visualize touch points")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: accessibility.touchpoints
                        Layout.fillHeight: true
                        onClicked: accessibility.touchpoints = checked
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Barrier free function")
                    color: CuteUI.Theme.disabledTextColor
                    visible: _view.count > 0
                }

                RowLayout {
                    Label {
                        text: qsTr("Snap Helper")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: accessibility.snaphelper
                        Layout.fillHeight: true
                        onClicked: accessibility.snaphelper = checked
                    }
                }

                RowLayout {
                    Label {
                        text: qsTr("Dim Inactive")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        checked: accessibility.diminactive
                        Layout.fillHeight: true
                        onClicked: accessibility.diminactive = checked
                    }
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }
        }
    }
}
