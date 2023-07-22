import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import CuteUI 1.0 as CuteUI

CuteUI.Window {
    id: control

    title: qsTr("About")

    width: 400
    height: width
//    height: contentHeight

    maximumWidth: control.width
    minimumWidth: control.width

//    maximumHeight: contentHeight
//    minimumHeight: contentHeight

    maximumHeight: control.width
    minimumHeight: control.width

    modality: Qt.WindowModal
    flags: Qt.Dialog | Qt.FramelessWindowHint

    minimizeButtonVisible: false
    visible: false

    property var iconSource
    property string name
    property string description
    property string version
    property string ver1
    property string ver2
    property string ver3
    property string buildtime
    property string kernel
    property string link: "https://lingmo.org"
    property var contentHeight: _mainLayout.implicitHeight + control.header.height * 2

    // headerBackground.color: CuteUI.Theme.secondBackgroundColor
    background.opacity: control.compositing ? 0.6 : 1.0

    CuteUI.WindowBlur {
        view: control
        geometry: Qt.rect(control.x, control.y, control.width, control.height)
        windowRadius: control.windowRadius
        enabled: control.compositing
    }

    DragHandler {
        target: null
        acceptedDevices: PointerDevice.GenericPointer
        grabPermissions: PointerHandler.CanTakeOverFromItems | PointerHandler.CanTakeOverFromHandlersOfDifferentType | PointerHandler.ApprovesTakeOverByAnything
        onActiveChanged: if (active) { control.helper.startSystemMove(control) }
    }

    ColumnLayout {
        id: _mainLayout
        anchors.fill: parent
        anchors.bottomMargin: control.header.height

        Image {
            width: 82
            height: 82
            source: control.iconSource
            sourceSize: Qt.size(82, 82)
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            height: CuteUI.Units.largeSpacing
        }

        Label {
            text: control.name
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu"
            font.pointSize: 17
        }

        Label {
            text: control.description
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.version
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.ver1
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.ver2
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.ver3
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.kernel
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: control.buildtime
            Layout.alignment: Qt.AlignHCenter
            font.family: "Ubuntu light"
        }

        Label {
            text: "Web: <a href=\"%1\">%1</a>".arg(control.link)
            Layout.alignment: Qt.AlignHCenter
            linkColor: CuteUI.Theme.highlightColor

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Qt.openUrlExternally(control.link)
            }
        }

        RowLayout {
            spacing: CuteUI.Units.largeSpacing

            // Button {
            //     text: qsTr("Exit")
            //     Layout.fillWidth: true
            //     // focus: true
            //     flat: true
            //     onClicked: control.close()
            // }

            Button {
                text: qsTr("Document")
                Layout.fillWidth: true
                onClicked: {
                    Qt.openUrlExternally("https://lingmo.org/doc/")
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
