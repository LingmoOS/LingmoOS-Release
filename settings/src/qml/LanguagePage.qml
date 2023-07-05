import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0 as Settings

ItemPage {
    headerTitle: qsTr("Language")

    Settings.Language {
        id: language
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: CuteUI.Units.smallSpacing

        ListView {
            id: listView

            CuteUI.WheelHandler {
                target: listView
            }

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: language.languages
            clip: true

            topMargin: CuteUI.Units.largeSpacing
            leftMargin: CuteUI.Units.largeSpacing * 2
            rightMargin: CuteUI.Units.largeSpacing * 2
            bottomMargin: CuteUI.Units.largeSpacing
            spacing: CuteUI.Units.largeSpacing

            currentIndex: language.currentLanguage

            ScrollBar.vertical: ScrollBar {
                bottomPadding: CuteUI.Theme.smallRadius
            }

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration : 0
            highlight: Rectangle {
                color: CuteUI.Theme.highlightColor
                radius: CuteUI.Theme.smallRadius
            }

            delegate: MouseArea {
                property bool isSelected: index == listView.currentIndex

                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: 36
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    language.setCurrentLanguage(index)
                }

                Rectangle {
                    anchors.fill: parent
                    color: isSelected ? "transparent" : item.containsMouse ? CuteUI.Theme.disabledTextColor : "transparent"
                    opacity: isSelected ? 1 : 0.1
                    radius: CuteUI.Theme.smallRadius
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: CuteUI.Units.smallSpacing
                    anchors.rightMargin: CuteUI.Units.largeSpacing

                    Label {
                        color: isSelected ? CuteUI.Theme.highlightedTextColor : CuteUI.Theme.textColor
                        text: modelData
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Image {
                        width: item.height * 0.45
                        height: width
                        sourceSize: Qt.size(width, height)
                        source: "qrc:/images/dark/checked.svg"
                        visible: isSelected
                        smooth: false
                    }
                }
            }
        }
    }
}
