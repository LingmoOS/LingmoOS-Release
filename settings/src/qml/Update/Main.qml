import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.0
import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import "../"

ItemPage {
    headerTitle: qsTr("Update")

    About {
        id: update
    }

    Rectangle {
    width: 640
    height: 480

    Video {
        id: video
        source: "qrc:/images/video.mp4"
        autoPlay: true
        fillMode: VideoOutput.Stretch
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        focus: false
        visible: false
    }

    Component.onCompleted: {
        video.visible = true
    }
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
                width: 450
                height: 137
                sourceSize: Qt.size(width, height)
                source: CuteUI.Theme.darkMode ? "qrc:/images/dark/logo.png" : "qrc:/images/light/logo.png"
            }

            // Item {
            //     height: CuteUI.Units.smallSpacing
            // }
            
            // Item {
            //     height: CuteUI.Units.smallSpacing
            // }

            Label {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                // text: qsTr("SwiftOS")
                // FontGrade {
                //     id: bgagardad
                //     anchors.centerIn: parent
                // }
                visible: !about.isCuteOS
                // font.pointSize: 22
                // color: "#3385FF"
                leftPadding: CuteUI.Units.largeSpacing * 2
                rightPadding: CuteUI.Units.largeSpacing * 2
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            Item {
                height: CuteUI.Units.largeSpacing * 2
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("OS Version")
                    
                    value: about.version
                }

                // StandardItem {
                //     key: qsTr("openCute Version")
                //     value: about.openCuteversion
                // }

                StandardItem {
                    key: qsTr("Debian Version")
                    
                    value: about.debianversion
                }

                StandardItem {
                    key: qsTr("System Type")
                    
                    value: about.architecture
                }

                StandardItem {
                    key: qsTr("Kernel Version")
                    
                    value: about.kernelVersion
                }

                StandardItem {
                    key: qsTr("Processor")
                    
                    value: about.cpuInfo
                }

                StandardItem {
                    key: qsTr("RAM")
                    
                    value: about.memorySize
                }

                StandardItem {
                    key: qsTr("Internal Storage")
                    
                    value: about.internalStorage
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            StandardButton {
                text: ""
                Layout.fillWidth: true
                // visible: about.isCuteOS
                onClicked: {
                    process.startDetached("cute-settings", ["-m", "bluetooth"])
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: CuteUI.Units.largeSpacing * 1.5
                    anchors.rightMargin: CuteUI.Units.largeSpacing * 1.5

                    Label {
                        text: qsTr("Agreement")
                        font.family: "Ubuntu Light"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: qsTr("View→")
                    }
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }
        }
    }
}
