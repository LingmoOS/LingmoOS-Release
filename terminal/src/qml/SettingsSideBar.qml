import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI

Item {
    implicitWidth: 150

    property int itemRadiusV: 8

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.backgroundColor, 1.5)
                                     : Qt.darker(CuteUI.Theme.backgroundColor, 1.05)
        opacity: control.compositing ? 0.7 : 1.0

        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.Linear
            }
        }
    }

    ListModel {
        id: listModel

        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/SettingsPages/Appearance.qml"
            iconSource: "qrc:/images/sidebar/appearance.svg"
        }
        ListElement {
            title: qsTr("Bookmark")
            name: "bookmark"
            page: "qrc:/qml/SettingsPages/Bookmark.qml"
            iconSource: "qrc:/images/sidebar/bookmark.svg"
        }
        ListElement {
            title: qsTr("Custom")
            name: "custom"
            page: "qrc:/qml/SettingsPages/Custom.qml"
            iconSource: "qrc:/images/sidebar/custom.svg"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Label {
            text: control.title
            color: control.active ? CuteUI.Theme.textColor : CuteUI.Theme.disabledTextColor
            Layout.preferredHeight: control.header.height
            leftPadding: CuteUI.Units.largeSpacing + CuteUI.Units.smallSpacing
            rightPadding: CuteUI.Units.largeSpacing + CuteUI.Units.smallSpacing
            topPadding: CuteUI.Units.smallSpacing
            bottomPadding: 0
            font.pointSize: 13
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel

            spacing: CuteUI.Units.smallSpacing
            leftMargin: CuteUI.Units.largeSpacing
            rightMargin: CuteUI.Units.largeSpacing
            topMargin: CuteUI.Units.largeSpacing
            bottomMargin: CuteUI.Units.largeSpacing

            ScrollBar.vertical: ScrollBar {}

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration : 0
            highlight: Rectangle {
                radius: CuteUI.Theme.mediumRadius
                color: Qt.rgba(CuteUI.Theme.textColor.r,
                               CuteUI.Theme.textColor.g,
                               CuteUI.Theme.textColor.b, 0.05)
                smooth: true
            }

            CuteUI.WheelHandler {
                target: listView
            }

            delegate: Item {
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: 35

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton
                        onClicked: listView.currentIndex = index
                    }

                    radius: CuteUI.Theme.mediumRadius
                    color: mouseArea.pressed ? Qt.rgba(CuteUI.Theme.textColor.r,
                                                       CuteUI.Theme.textColor.g,
                                                       CuteUI.Theme.textColor.b, CuteUI.Theme.darkMode ? 0.05 : 0.1) :
                           mouseArea.containsMouse || isCurrent ? Qt.rgba(CuteUI.Theme.textColor.r,
                                                                          CuteUI.Theme.textColor.g,
                                                                          CuteUI.Theme.textColor.b, CuteUI.Theme.darkMode ? 0.1 : 0.05) :
                                                                  "transparent"

                    smooth: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: CuteUI.Units.smallSpacing
                    spacing: CuteUI.Units.smallSpacing

                    Rectangle {
                        id: iconRect
                        width: 26
                        height: 26
                        Layout.alignment: Qt.AlignVCenter
                        radius: width /2
                        color: CuteUI.Theme.highlightColor


                        Image {
                            id: icon
                            anchors.centerIn: parent
                            width: 14
                            height: width
                            source: model.iconSource
                            sourceSize: Qt.size(width, height)
                            Layout.alignment: Qt.AlignVCenter
                            antialiasing: false
                            smooth: false
                        }
                    }

                    Label {
                        id: itemTitle
                        text: model.title
                        color: CuteUI.Theme.darkMode ? CuteUI.Theme.textColor : "#363636"
                        font.pointSize: 8
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
