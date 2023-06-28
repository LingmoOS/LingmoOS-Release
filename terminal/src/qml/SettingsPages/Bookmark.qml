import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import CuteUI 1.0 as CuteUI
ItemPage {
    headerTitle: qsTr("Bookmark")
    ScrollView {
        anchors.fill: parent
        anchors.margins: CuteUI.Units.largeSpacing
    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.bottomMargin: CuteUI.Units.largeSpacing
        RoundedItem {
            Label {
                text: qsTr("Bookmark")
                color: CuteUI.Theme.disabledTextColor
            }
            ColumnLayout{
                spacing: CuteUI.Units.smallSpacing
                Repeater {
                    model: settings.bookmark
                    delegate: RowLayout{
                        Label {
                            text: settings.bookmark[index]
                        }

                        Item{
                            Layout.fillWidth: true
                        }

                        Button{
                            flat: true
                            width: height
                            implicitWidth: height
                            icon.source: CuteUI.Theme.darkMode ? "qrc:/images/light/close.svg" : "qrc:/images/dark/close.svg"
                            onClicked: {
                                var mbm = settings.bookmark;
                                mbm.splice(index, 1)
                                settings.bookmark = mbm
                            }
                        }
                    }
                }
                RowLayout{
                    TextField{
                        id:_dirurl
                        Layout.fillWidth: true
                        placeholderText: qsTr("Directory address")
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Button{
                        flat: true
                        width: height
                        implicitWidth: height
                        icon.source: CuteUI.Theme.darkMode ? "qrc:/images/light/add.svg" : "qrc:/images/dark/add.svg"
                        onClicked: {
                            var mbm = settings.bookmark;
                            mbm.push(_dirurl.text)
                            settings.bookmark = mbm
                        }
                    }

                }
            }
        }
    }
    }
}
