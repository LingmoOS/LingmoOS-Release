/*
 * Copyright (C) 2023 CuteOS Team.
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
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import Cute.NetworkManagement 1.0 as NM

Item {
    implicitWidth: 230

    property int itemRadiusV: 8

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.backgroundColor, 1.5)
                                     : Qt.darker(CuteUI.Theme.backgroundColor, 1.05)
        opacity: rootWindow.compositing ? 0.7 : 1.0

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
            title: qsTr("WLAN")
            name: "wlan"
            page: "qrc:/qml/WLAN/Main.qml"
            iconSource: "wlan.svg"
            iconColor: "#46C8FF"
            category: qsTr("Network and connection")
        }

        ListElement {
            title: qsTr("Ethernet")
            name: "ethernet"
            page: "qrc:/qml/Wired/Main.qml"
            iconSource: "network.svg"
            iconColor: "#1B76FF"
            category: qsTr("Network and connection")
        }

//        ListElement {
//            title: qsTr("Hotspot")
//            name: "hotspot"
//            page: "qrc:/qml/Hotspot/Main.qml"
//            iconSource: "hotspot.svg"
//            iconColor: "#0067FF"
//            category: qsTr("Network and connection")
//        }

        ListElement {
            title: qsTr("Bluetooth")
            name: "bluetooth"
            page: "qrc:/qml/Bluetooth/Main.qml"
            iconSource: "bluetooth.svg"
            iconColor: "#2AC9E6"
            category: qsTr("Network and connection")
        }

//        ListElement {
//            title: qsTr("VPN")
//            name: "vpn"
//            page: "qrc:/qml/VPN/Main.qml"
//            iconSource: "bluetooth.svg"
//            iconColor: "#0067FF"
//            category: qsTr("Network and connection")
//        }

        ListElement {
            title: qsTr("Proxy")
            name: "proxy"
            page: "qrc:/qml/Proxy/Main.qml"
            iconSource: "proxy.svg"
            iconColor: "#A670F0"
            category: qsTr("Network and connection")
        }

        ListElement {
            title: qsTr("Display")
            name: "display"
            page: "qrc:/qml/Display/Main.qml"
            iconSource: "display.svg"
            iconColor: "#0087ED"
            category: qsTr("Display and appearance")
        }

        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/Appearance/Main.qml"
            iconSource: "appearance.svg"
            iconColor: "#03B4CB"
            category: qsTr("Display and appearance")
        }

        ListElement {
            title: qsTr("Background")
            name: "background"
            page: "qrc:/qml/Wallpaper/Main.qml"
            iconSource: "wallpaper.svg"
            iconColor: "#34B4A7"
            category: qsTr("Display and appearance")
        }

        ListElement {
            title: qsTr("Dock")
            name: "dock"
            page: "qrc:/qml/Dock/Main.qml"
            iconSource: "dock.svg"
            iconColor: "#FC85EE"
            category: qsTr("Display and appearance")
        }

        ListElement {
            title: qsTr("User")
            name: "accounts"
            page: "qrc:/qml/User/Main.qml"
            iconSource: "accounts.svg"
            iconColor: "#4366DA"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Notifications")
            name: "notifications"
            page: "qrc:/qml/Notification/Main.qml"
            iconSource: "notifications.svg"
            iconColor: "#F16884"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Sound")
            name: "sound"
            page: "qrc:/qml/Sound/Main.qml"
            iconSource: "sound.svg"
            iconColor: "#F16884"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Mouse")
            name: "mouse"
            page: "qrc:/qml/Cursor/Main.qml"
            iconSource: "cursor.svg"
            iconColor: "#3385FF"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Touchpad")
            name: "touchpad"
            page: "qrc:/qml/Touchpad/Main.qml"
            iconSource: "touchpad.svg"
            iconColor: "#999999"
            category: qsTr("System")
        }

//        ListElement {
//            title: qsTr("Application")
//            name: "application"
//            page: "qrc:/qml/Application/Main.qml"
//            iconSource: "accounts.svg"
//            iconColor: "#DA7C43"
//            category: qsTr("System")
//        }

        ListElement {
            title: qsTr("Date & Time")
            name: "datetime"
            page: "qrc:/qml/DateTime/Main.qml"
            iconSource: "datetime.svg"
            iconColor: "#418CFF"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Accessibility")
            name: "accessibility"
            page: "qrc:/qml/Accessibility/Main.qml"
            iconSource: "accessibility.svg"
            iconColor: "#2EC347"
            category: qsTr("System")
        }
        
        ListElement {
            title: qsTr("Default Applications")
            name: "defaultapps"
            page: "qrc:/qml/DefaultApp/Main.qml"
            iconSource: "defaultapps.svg"
            iconColor: "#418CFF"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Language")
            name: "language"
            page: "qrc:/qml/LanguagePage.qml"
            iconSource: "language.svg"
            iconColor: "#20A7FF"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Battery")
            name: "battery"
            page: "qrc:/qml/Battery/Main.qml"
            iconSource: "battery.svg"
            iconColor: "#2EC347"
            category: qsTr("System")
        }

        ListElement {
            title: qsTr("Power")
            name: "power"
            page: "qrc:/qml/Power/Main.qml"
            iconColor: "#FE8433"
            iconSource: "power.svg"
            category: qsTr("System")
        }

        // ListElement {
        //     title: qsTr("Update")
        //     name: "Update"
        //     page: "qrc:/qml/Dev/Main.qml"
        //     iconSource: "about.svg"
        //     iconColor: "#FF56A5"
        //     category: qsTr("System")
        // }
        // ListElement {
        //     title: qsTr("About Dev")
        //     name: "Develop"
        //     page: "qrc:/qml/Dev/Main.qml"
        //     iconSource: "about.svg"
        //     iconColor: "#FF6BB7"
        //     category: qsTr("System")
        // }

        ListElement {
            title: qsTr("About LingmoOS")
            name: "about"
            page: "qrc:/qml/About/Main.qml"
            iconSource: "about.svg"
            iconColor: "#1ABAFF"
            category: qsTr("System")
        }

        // ListElement {
        //     title: qsTr("Update")
        //     name: "update"
        //     page: "qrc:/qml/Update/Main.qml"
        //     iconSource: "about.svg"
        //     iconColor: "#FF6BCF"
        //     category: qsTr("System")
        // }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Label {
            text: rootWindow.title
            color: rootWindow.active ? CuteUI.Theme.textColor : CuteUI.Theme.disabledTextColor
            Layout.preferredHeight: rootWindow.header.height
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
            topMargin: 0
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

            section.property: "category"
            section.delegate: Item {
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: CuteUI.Units.fontMetrics.height + CuteUI.Units.largeSpacing + CuteUI.Units.smallSpacing

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: Qt.application.layoutDirection === Qt.RightToLeft ? 0 : CuteUI.Units.smallSpacing
                    anchors.rightMargin: CuteUI.Units.smallSpacing
                    anchors.topMargin: CuteUI.Units.largeSpacing
                    anchors.bottomMargin: CuteUI.Units.smallSpacing
                    color: CuteUI.Theme.disabledTextColor
                    font.pointSize: 8
                    text: section
                }
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
                        width: 24
                        height: 24
                        Layout.alignment: Qt.AlignVCenter
                        radius: 6
                        color: model.iconColor

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(model.iconColor, 1.15) }
                            GradientStop { position: 1.0; color: model.iconColor }
                        }

                        Image {
                            id: icon
                            anchors.centerIn: parent
                            width: 16
                            height: width
                            source: "qrc:/images/sidebar/dark/" + model.iconSource
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

    function removeItem(name) {
        for (var i = 0; i < listModel.count; ++i) {
            if (name === listModel.get(i).name) {
                listModel.remove(i)
                break
            }
        }
    }

    Battery {
        id: _battery

        // Component.onCompleted: {
        //     if (!_battery.available)
        //         removeItem("battery")
        // }
    }

    NM.EnabledConnections {
        id: nmEnabledConnections

        Component.onCompleted: {
            if (!nmEnabledConnections.wirelessHwEnabled)
                removeItem("wlan")
        }
    }

    Touchpad {
        id: _touchPad

        Component.onCompleted: {
            if (!_touchPad.available)
                removeItem("touchpad")
        }
    }
}
