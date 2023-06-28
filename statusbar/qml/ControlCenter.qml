import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import Cute.Accounts 1.0 as Accounts
import Cute.Bluez 1.0 as Bluez
import Cute.StatusBar 1.0
import Cute.Audio 1.0
import CuteUI 1.0 as CuteUI

ControlCenterDialog {
    id: control

    width: 450
    height: _mainLayout.implicitHeight + CuteUI.Units.largeSpacing * 2

    property var margin: 4 * Screen.devicePixelRatio
    property point position: Qt.point(0, 0)
    property var defaultSink: paSinkModel.defaultSink

    property bool bluetoothDisConnected: Bluez.Manager.bluetoothBlocked
    property var defaultSinkValue: defaultSink ? defaultSink.volume / PulseAudio.NormalVolume * 100.0 : -1

    property var borderColor: windowHelper.compositing ? CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.3)
                                                                  : Qt.rgba(0, 0, 0, 0.2) : CuteUI.Theme.darkMode ? Qt.rgba(255, 255, 255, 0.15)
                                                                                                                  : Qt.rgba(0, 0, 0, 0.15)

    property var volumeIconName: {
        if (defaultSinkValue <= 0)
            return "audio-volume-muted-symbolic"
        else if (defaultSinkValue <= 25)
            return "audio-volume-low-symbolic"
        else if (defaultSinkValue <= 75)
            return "audio-volume-medium-symbolic"
        else
            return "audio-volume-high-symbolic"
    }

    onBluetoothDisConnectedChanged: {
        bluetoothItem.checked = !bluetoothDisConnected
    }

    onWidthChanged: adjustCorrectLocation()
    onHeightChanged: adjustCorrectLocation()
    onPositionChanged: adjustCorrectLocation()

    color: "transparent"

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Appearance {
        id: appearance
    }

    Notifications {
        id: notifications
    }

    SinkModel {
        id: paSinkModel

        onDefaultSinkChanged: {
            if (!defaultSink) {
                return
            }
        }
    }

    function toggleBluetooth() {
        const enable = !control.bluetoothDisConnected
        Bluez.Manager.bluetoothBlocked = enable

        for (var i = 0; i < Bluez.Manager.adapters.length; ++i) {
            var adapter = Bluez.Manager.adapters[i]
            adapter.powered = enable
        }
    }

    function adjustCorrectLocation() {
        var posX = control.position.x
        var posY = control.position.y

        if (posX + control.width >= StatusBar.screenRect.x + StatusBar.screenRect.width)
            posX = StatusBar.screenRect.x + StatusBar.screenRect.width - control.width - control.margin

        posY = rootItem.y + rootItem.height + control.margin

        control.x = posX
        control.y = posY
    }

    Brightness {
        id: brightness
    }

    Accounts.UserAccount {
        id: currentUser
    }

    CuteUI.WindowBlur {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        windowRadius: _background.radius
        enabled: true
    }

    CuteUI.WindowShadow {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        radius: _background.radius
    }

    Rectangle {
        id: _background
        anchors.fill: parent
        radius: windowHelper.compositing ? CuteUI.Theme.bigRadius * 1.5 : 0
        color: CuteUI.Theme.darkMode ? "#4D4D4D" : "#F0F0F0"
        // opacity: windowHelper.compositing ? CuteUI.Theme.darkMode ? 0.6 : 0.8 : 1.0
        opacity: 0.5
        antialiasing: true
        border.width: 1 / Screen.devicePixelRatio
        border.pixelAligned: Screen.devicePixelRatio > 1 ? false : true
        border.color: control.borderColor

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.Linear
            }
        }
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.margins: CuteUI.Units.largeSpacing
        spacing: CuteUI.Units.largeSpacing

        Item {
            id: topItem
            Layout.fillWidth: true
            height: 32

            RowLayout {
                id: topItemLayout
                anchors.fill: parent
                anchors.rightMargin: CuteUI.Units.largeSpacing
                spacing: CuteUI.Units.largeSpacing

                Label {
                    leftPadding: CuteUI.Units.largeSpacing
                    text: qsTr("Control Center")
                    font.bold: true
                    font.pointSize: 14
                    Layout.fillWidth: true
                }

                IconButton {
                    id: settingsButton
                    implicitWidth: topItem.height
                    implicitHeight: topItem.height
                    Layout.alignment: Qt.AlignTop
                    source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark/" : "light/") + "settings.svg"
                    onLeftButtonClicked: {
                        control.visible = false
                        process.startDetached("ling-settings")
                    }
                }

//                IconButton {
//                    id: shutdownButton
//                    implicitWidth: topItem.height
//                    implicitHeight: topItem.height
//                    Layout.alignment: Qt.AlignTop
//                    source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark/" : "light/") + "system-shutdown-symbolic.svg"
//                    onLeftButtonClicked: {
//                        control.visible = false
//                        process.startDetached("cute-shutdown")
//                    }
//                }
            }
        }

        Item {
            id: cardItems
            Layout.fillWidth: true
            Layout.preferredHeight: Math.ceil(cardLayout.count / 4) * 110

            property var cellWidth: cardItems.width / 4

            Rectangle {
                anchors.fill: parent
                color: "white"
                radius: CuteUI.Theme.bigRadius
                opacity: CuteUI.Theme.darkMode ? 0.2 : 0.7
            }

            GridLayout {
                id: cardLayout
                anchors.fill: parent
                columnSpacing: 0
                columns: 4

                property int count: {
                    var count = 0

                    for (var i in cardLayout.children) {
                        if (cardLayout.children[i].visible)
                            ++count
                    }

                    return count
                }

                CardItem {
                    id: wirelessItem
                    Layout.fillHeight: true
                    Layout.preferredWidth: cardItems.cellWidth
                    icon: CuteUI.Theme.darkMode || checked ? "qrc:/images/dark/network-wireless-connected-100.svg"
                                                           : "qrc:/images/light/network-wireless-connected-100.svg"
                    visible: enabledConnections.wirelessHwEnabled
                    checked: enabledConnections.wirelessEnabled
                    label: activeConnection.wirelessName ? activeConnection.wirelessName : qsTr("Wi-Fi")
                    onClicked: nmHandler.enableWireless(!checked)
                    onPressAndHold: {
                        control.visible = false
                        process.startDetached("ling-settings", ["-m", "wlan"])
                    }
                }

                CardItem {
                    id: bluetoothItem
                    Layout.fillHeight: true
                    Layout.preferredWidth: cardItems.cellWidth
                    icon: CuteUI.Theme.darkMode || checked ? "qrc:/images/dark/bluetooth-symbolic.svg"
                                                           : "qrc:/images/light/bluetooth-symbolic.svg"
                    checked: !control.bluetoothDisConnected
                    label: qsTr("Bluetooth")
                    visible: Bluez.Manager.adapters.length
                    onClicked: control.toggleBluetooth()
                    onPressAndHold: {
                        control.visible = false
                        process.startDetached("ling-settings", ["-m", "bluetooth"])
                    }
                }

                CardItem {
                    id: darkModeItem
                    Layout.fillHeight: true
                    Layout.preferredWidth: cardItems.cellWidth
                    icon: CuteUI.Theme.darkMode || checked ? "qrc:/images/dark/dark-mode.svg"
                                                           : "qrc:/images/light/dark-mode.svg"
                    checked: CuteUI.Theme.darkMode
                    label: qsTr("Dark Mode")
                    onClicked: appearance.switchDarkMode(!CuteUI.Theme.darkMode)
                }

                CardItem {
                    Layout.fillHeight: true
                    Layout.preferredWidth: cardItems.cellWidth
                    icon: CuteUI.Theme.darkMode || checked ? "qrc:/images/dark/do-not-disturb.svg"
                                                           : "qrc:/images/light/do-not-disturb.svg"
                    checked: notifications.doNotDisturb
                    label: qsTr("Do Not Disturb")
                    onClicked: notifications.doNotDisturb = !notifications.doNotDisturb
                }

                CardItem {
                    Layout.fillHeight: true
                    Layout.preferredWidth: cardItems.cellWidth
                    icon: CuteUI.Theme.darkMode || checked ? "qrc:/images/dark/screenshot.svg"
                                                           : "qrc:/images/light/screenshot.svg"
                    checked: false
                    label: qsTr("Screenshot")
                    onClicked: {
                        control.visible = false
                        process.startDetached("cute-screenshot", ["-d", "500"])
                    }
                }
            }
        }

        MprisItem {
            height: 96
            Layout.fillWidth: true
        }

        Item {
            id: brightnessItem
            Layout.fillWidth: true
            height: 40
            visible: brightness.enabled

            Rectangle {
                id: brightnessItemBg
                anchors.fill: parent
                color: "white"
                radius: CuteUI.Theme.bigRadius
                opacity: CuteUI.Theme.darkMode ? 0.2 : 0.7
            }

            RowLayout {
                anchors.fill: brightnessItemBg
                anchors.leftMargin: CuteUI.Units.largeSpacing
                anchors.rightMargin: CuteUI.Units.largeSpacing
                anchors.topMargin: CuteUI.Units.smallSpacing
                anchors.bottomMargin: CuteUI.Units.smallSpacing
                spacing: CuteUI.Units.largeSpacing

                Image {
                    height: 16
                    width: height
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark" : "light") + "/brightness.svg"
                    smooth: false
                    antialiasing: true
                }

                Timer {
                    id: brightnessTimer
                    interval: 100
                    repeat: false
                    onTriggered: brightness.setValue(brightnessSlider.value)
                }

                Slider {
                    id: brightnessSlider
                    from: 1
                    to: 100
                    stepSize: 1
                    value: brightness.value
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    onMoved: brightnessTimer.start()
                }

//                Label {
//                    text: brightnessSlider.value + "%"
//                    color: CuteUI.Theme.disabledTextColor
//                    Layout.preferredWidth: _fontMetrics.advanceWidth("100%")
//                }
            }
        }

        Item {
            id: volumeItem
            Layout.fillWidth: true
            height: 40
            visible: defaultSink

            Rectangle {
                id: volumeItemBg
                anchors.fill: parent
                color: "white"
                radius: CuteUI.Theme.bigRadius
                opacity: CuteUI.Theme.darkMode ? 0.2 : 0.7
            }

            RowLayout {
                anchors.fill: volumeItemBg
                anchors.leftMargin: CuteUI.Units.largeSpacing
                anchors.rightMargin: CuteUI.Units.largeSpacing
                anchors.topMargin: CuteUI.Units.smallSpacing
                anchors.bottomMargin: CuteUI.Units.smallSpacing
                spacing: CuteUI.Units.largeSpacing

                Image {
                    height: 16
                    width: height
                    sourceSize: Qt.size(width, height)
                    source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark" : "light") + "/" + control.volumeIconName + ".svg"
                    smooth: false
                    antialiasing: true
                }

                Slider {
                    id: volumeSlider

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    from: PulseAudio.MinimalVolume
                    to: PulseAudio.NormalVolume

                    stepSize: to / (to / PulseAudio.NormalVolume * 100.0)

                    value: defaultSink ? defaultSink.volume : 0

                    onValueChanged: {
                        if (!defaultSink)
                            return

                        defaultSink.volume = value
                        defaultSink.muted = (value === 0)
                    }
                }

//                Label {
//                    text: parseInt(volumeSlider.value / PulseAudio.NormalVolume * 100.0) + "%"
//                    Layout.preferredWidth: _fontMetrics.advanceWidth("100%")
//                    color: CuteUI.Theme.disabledTextColor
//                }
            }
        }

        FontMetrics {
            id: _fontMetrics
        }

        RowLayout {
            Layout.leftMargin: CuteUI.Units.smallSpacing
            Layout.rightMargin: CuteUI.Units.smallSpacing
            spacing: 0

            Label {
                id: timeLabel
                leftPadding: CuteUI.Units.smallSpacing / 2
                color: CuteUI.Theme.textColor

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    triggeredOnStart: true
                    onTriggered: {
                        timeLabel.text = new Date().toLocaleDateString(Qt.locale(), Locale.LongFormat)
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            StandardItem {
                width: batteryLayout.implicitWidth + CuteUI.Units.largeSpacing
                height: batteryLayout.implicitHeight + CuteUI.Units.largeSpacing

                onClicked: {
                    control.visible = false
                    process.startDetached("ling-settings", ["-m", "battery"])
                }

                RowLayout {
                    id: batteryLayout
                    anchors.fill: parent
                    visible: battery.available
                    spacing: 0

                    Image {
                        id: batteryIcon
                        width: 22
                        height: 16
                        sourceSize: Qt.size(width, height)
                        source: "qrc:/images/" + (CuteUI.Theme.darkMode ? "dark/" : "light/") + battery.iconSource
                        asynchronous: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        antialiasing: true
                        smooth: false
                    }

                    Label {
                        text: battery.chargePercent + "%"
                        color: CuteUI.Theme.textColor
                        rightPadding: CuteUI.Units.smallSpacing / 2
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }
    }

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
}
