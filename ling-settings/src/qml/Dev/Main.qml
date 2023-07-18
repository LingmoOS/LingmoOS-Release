//demo
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI
import "../"

ItemPage {
    headerTitle: qsTr("About Developers")

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent
            
            Item {
                height: CuteUI.Units.largeSpacing
            }

            Image {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                width: 400
                height: 87
                sourceSize: Qt.size(width, height)
                source: CuteUI.Theme.darkMode ? "qrc:/images/dark/devlogo3.png" : "qrc:/images/light/devlogo3.png"
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            RoundedItem {
                StandardItem {
                    Label {
                        text: qsTr("Developers")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: qsTr("Swift Software")
                    }
                }
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("Update Push")
                }

                StandardItem {
                    key: qsTr("[内测软件更新方式]\n1.您可以向开发者发送邮件以获取最新可用的Cute软件包\n2.您还可以从以下链接前往网站进行下载")
                }
            }

            RoundedItem {
                StandardItem {
                    key: qsTr("Contributor List")
                }

                StandardItem {
                    key: qsTr("Floating dream(cuteos@foxmail.com)")
                }
            }

            Item {
                height: CuteUI.Units.smallSpacing
            }

            Button {
                text: qsTr("Cute software updates available")
                flat: true
                Layout.alignment: Qt.AlignHCenter
                visible: control.error
                onClicked: {
                Qt.openUrlExternally("https://www.cuteos.cn/update_cute/")
                }
            }
        }
    }
}
