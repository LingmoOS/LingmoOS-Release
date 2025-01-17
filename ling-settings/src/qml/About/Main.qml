import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import "../"

ItemPage {
    id: control
    headerTitle: qsTr("About LingmoOS")

    About {
        id: about
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            // Item {
            //     height: CuteUI.Units.largeSpacing
            // }

            Image {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                width: 463
                height: 230
                sourceSize: Qt.size(width, height)
                source: CuteUI.Theme.darkMode ? "qrc:/images/dark/LingmoOS-500.png" : "qrc:/images/light/LingmoOS-500.png"
            }

            // Label {
            //     Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            //     // text: qsTr("SwiftOS")
            //     // FontGrade {
            //     //     id: bgagardad
            //     //     anchors.centerIn: parent
            //     // }
            //     visible: !about.isCuteOS
            //     // font.pointSize: 22
            //     // color: "#3385FF"
            //     leftPadding: CuteUI.Units.largeSpacing * 2
            //     rightPadding: CuteUI.Units.largeSpacing * 2
            // }

            // Item {
            //     height: CuteUI.Units.smallSpacing
            // }
            Item {
                height: CuteUI.Units.smallSpacing
            }

            // Item {
            //     height: CuteUI.Units.largeSpacing * 2
            // }

            RoundedItem {
                StandardItem {
                    key: qsTr("LingmoOS Version")
                    value: about.version
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("OpenLingmo Version")
                    value: about.OpenLingmoVersion
                }
            }

                Item {
                height: CuteUI.Units.smallSpacing
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("Lingmo Desktop Version")
                    value: about.desktopversion
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("UI Version")
                    value: about.uiversion
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("Update Time")
                    value: about.updateversion
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("System Type")
                    value: about.architecture
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("Kernel Version")
                    value: about.kernelVersion
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("Processor")
                    value: about.cpuInfo
                }

                Rectangle {
                    // anchors.fill: parent
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("RAM")
                    value: about.memorySize
                }

                Rectangle {
                    // anchors.fill: 
                    Layout.fillWidth: true
                    width: 20
                    height: 1
                    color: CuteUI.Theme.settingsTextColor
                }

                StandardItem {
                    key: qsTr("Internal Storage")
                    value: about.internalStorage
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            // Button {
            //     // text: qsTr("System Community")
            //     flat: true
            //     Layout.alignment: Qt.AlignHCenter
            //     // visible: control.error
            //     // onClicked: {
            //     //     Qt.openUrlExternally("https://bbs.swifts.org.cn")
            //     // }
            //     text: ""
            //     Layout.fillWidth: true
            //     // visible: about.isCuteOS
            //     onClicked: moreInfoDialog.show()

            //     RowLayout {
            //         anchors.fill: parent
            //         anchors.leftMargin: CuteUI.Units.largeSpacing * 1.5
            //         anchors.rightMargin: CuteUI.Units.largeSpacing * 1.5

            //         Label {
            //             text: qsTr("Agreement")
            //             font.family: "Ubuntu Light"
            //         }

            //         Item {
            //             Layout.fillWidth: true
            //         }

            //         Label {
            //             text: qsTr("View→")
            //         }
            //     }
            // }
            StandardButton {
                Layout.fillWidth: true
                // visible: about.isCutefishOS
                text: qsTr("Software Update")
                onClicked: {
                    about.openUpdator()
                }
            }

            // StandardButton {
            //     Layout.fillWidth: true
            //     text: ""
            //     // onClicked: timeZoneDialog.visibility = "Maximized"
            //     onClicked: {
            //         about.openUpdator()
            //     }

            //     RowLayout {
            //         anchors.fill: parent
            //         anchors.leftMargin: CuteUI.Units.largeSpacing * 1.5
            //         anchors.rightMargin: CuteUI.Units.largeSpacing * 1.5

            //         Label {
            //             text: qsTr("System Update")
            //         }

            //         Item {
            //             Layout.fillWidth: true
            //         }

            //         Label {
            //             text: qsTr("→")
            //         }
            //     }
            // }

            // CuteUI.InfoDialog {
            //     id: infoDialog
            //     name: qsTr("Lingmo OS")
            //     version: about.version
            //     description: qsTr("Built on Debian 12")
            //     ver1: qsTr("OpenLingmo Server 1.0.2")
            //     ver2: about.buildversion
            //     ver3: qsTr("Pro_Beta")
            //     kernel: about.kernelVersion
            //     buildtime: about.buildtime
            //     iconSource: "qrc:/images/dark/LingmoOS-64.png"
            //     // RowLayout {
            //     //     spacing: CuteUI.Units.largeSpacing
            //     //     Item {
            //     //         Layout.fillWidth: true
            //     //     }
            //     // }
            // }

            Item {
                height: CuteUI.Units.smallSpacing
            }
        }
    }
}
