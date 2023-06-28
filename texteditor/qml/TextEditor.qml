/*
 * Copyright (C) 2023 CuteOS Team.
 */

import QtQuick 2.15
import QtQml 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1
import QtQuick.Dialogs 1.3
import CuteUI 1.0 as CuteUI
import Cute.TextEditor 1.0

Item {
    id: control

    property var tabName: document.fileName + (document.modified ? " *" : "")
    property var documentModified: document.modified

    property alias fileUrl: document.fileUrl
    property alias fileName: document.fileName
    property bool newFile: false
    property bool showLineNumbers: true
    property int characterCount: body.text.length

    height: ListView.view ? ListView.view.height : 0
    width: ListView.view ? ListView.view.width : 0

    DocumentHandler {
        id: document
        document: body.textDocument
        cursorPosition: body.cursorPosition
        selectionStart: body.selectionStart
        selectionEnd: body.selectionEnd
        backgroundColor: CuteUI.Theme.backgroundColor
        enableSyntaxHighlighting: true
        theme: CuteUI.Theme.darkMode ? "Breeze Dark" : "Breeze Light"

        onSearchFound: {
            body.select(start, end)
        }

        onFileSaved: {
            root.showPassiveNotification(qsTr("Saved successfully"), 3000)
        }
    }

    // Global Menu
    MenuBar {
        id: appMenu

        Menu {
            title: qsTr("文件")

            MenuItem {
                text: qsTr("新建")
                onTriggered: root.addTab()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("打开...")
                onTriggered: root.open()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("保存")
                onTriggered: control.save()
                enabled: document.modified
            }
            MenuItem {
                text: qsTr("另存为...")
                onTriggered: control.saveas()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("退出")
                onTriggered: {
                    if (root.closeAll())
                        Qt.quit()
                }
            }
        }

        Menu {
            title: qsTr("编辑")

            MenuItem {
                text: qsTr("全选")
                onTriggered: body.selectAll()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("剪切")
                onTriggered: body.cut()
                enabled: !(body.selectedText === "")
            }
            MenuItem {
                text: qsTr("复制")
                onTriggered: body.copy()
                enabled: !(body.selectedText === "")
            }
            MenuItem {
                text: qsTr("粘贴")
                onTriggered: body.paste()
                enabled: body.canPaste
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("打开")
                onTriggered: body.undo()
                enabled: body.canUndo
            }
            MenuItem {
                text: qsTr("撤销")
                onTriggered: body.redo()
                enabled: body.canRedo
            }
        }

        Menu {
            title: qsTr("帮助")

            MenuItem {
                text: qsTr("关于LingmoOS文本编辑器")
                onTriggered: _aboutDialog.show()
            }
        }
    }

    CuteUI.AboutDialog {
        id: _aboutDialog
        name: qsTr("LingmoOS文本编辑器")
        description: qsTr("专门为LingmoOS设计的文本编辑器。\n版本：0.9_beta")
        iconSource: "image://icontheme/cute-texteditor"
    }

    ScrollView {
        id: _scrollView
        anchors.fill: parent

        Keys.enabled: true
        Keys.forwardTo: body

        contentWidth: availableWidth

        Flickable {
            id: _flickable

            CuteUI.WheelHandler {
                id: wheelHandler
                target: _flickable
            }

            boundsBehavior: Flickable.StopAtBounds
            boundsMovement: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AlwaysOff
            }

            TextArea.flickable: TextArea {
                id: body
                text: document.text
                selectByKeyboard: true
                selectByMouse: true
                persistentSelection: true
                textFormat: TextEdit.PlainText
                wrapMode: TextEdit.WrapAnywhere

                activeFocusOnPress: true
                activeFocusOnTab: true

                leftPadding: _linesCounter.width + CuteUI.Units.smallSpacing
                padding: CuteUI.Units.smallSpacing
                color: CuteUI.Theme.textColor

                font.family: "Noto Mono"

                background: Rectangle {
                    color: CuteUI.Theme.backgroundColor
                }

                Keys.enabled: true
                Keys.onPressed: {
                    if ((event.key === Qt.Key_S)
                            && (event.modifiers & Qt.ControlModifier)
                            && !(event.modifiers & Qt.ShiftModifier)) {
                        control.save()
                        event.accepted = true
                    }
                    if ((event.key === Qt.Key_S)
                            && (event.modifiers & Qt.ControlModifier)
                            && (event.modifiers & Qt.ShiftModifier)) {
                        control.saveas()
                        event.accepted = true
                    }
                    if (((event.key === Qt.Key_T) || (event.key === Qt.Key_N))
                            && (event.modifiers & Qt.ControlModifier)) {
                        root.addTab()
                        event.accepted = true
                    }
                    if ((event.key === Qt.Key_W)
                            && (event.modifiers & Qt.ControlModifier)) {
                        root.closeCurrentTab()
                        event.accepted = true
                    }
                    if((event.key === Qt.Key_O)
                            && (event.modifiers & Qt.ControlModifier)) {
                        root.open()
                        event.accepted = true
                    }
                    if ((event.key === Qt.Key_Tab) && (event.modifiers & Qt.ControlModifier)) {
                        root.toggleTab(1)
                        event.accepted = true
                    }
                    if ((event.key === Qt.Key_Backtab) && (event.modifiers & Qt.ControlModifier)) {
                        root.toggleTab(-1)
                        event.accepted = true
                    }
                }

                Loader {
                    id: _linesCounter
                    active: control.showLineNumbers && !document.isRich
                    asynchronous: true

                    anchors.left: body.left
                    anchors.top: body.top
                    anchors.topMargin: body.topPadding + body.textMargin

                    height: _flickable.contentHeight
                    width: active ? 32 : 0

                    sourceComponent: _linesCounterComponent
                }
            }
        }
    }

    Component {
        id: _linesCounterComponent

        ListView {
            id: _linesCounterList
            model: document.lineCount
            clip: true

            Binding on currentIndex {
                value: document.currentLineIndex
                restoreMode: Binding.RestoreBindingOrValue
            }

            Timer {
                id: _lineIndexTimer
                interval: 250
                onTriggered: _linesCounterList.currentIndex = document.currentLineIndex
            }

            Connections {
                target: document

                function onLineCountChanged() {
                    _lineIndexTimer.restart()
                }
            }

            orientation: ListView.Vertical
            interactive: false
            snapMode: ListView.NoSnap

            boundsBehavior: Flickable.StopAtBounds
            boundsMovement :Flickable.StopAtBounds

            preferredHighlightBegin: 0
            preferredHighlightEnd: width

            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightMoveDuration: 0
            highlightFollowsCurrentItem: false
            highlightResizeDuration: 0
            highlightMoveVelocity: -1
            highlightResizeVelocity: -1

            maximumFlickVelocity: 0

            delegate: Row {
                id: _delegate

                readonly property int line : index
                // property bool foldable : control.document.isFoldable(line)

                width:  ListView.view.width
                height: document.lineHeight(line)

                readonly property bool isCurrentItem: ListView.isCurrentItem

//                Connections {
//                    target: control.body

//                    function onContentHeightChanged() {
//                        if (_delegate.isCurrentItem) {
//                            console.log("Updating line height")
//                            _delegate.height = control.document.lineHeight(_delegate.line)
//                            _delegate.foldable = control.document.isFoldable(_delegate.line)
//                        }
//                    }
//                }

                Label {
                    width: 32
                    height: parent.height
                    opacity: isCurrentItem ? 1 : 0.7
                    color: isCurrentItem ? CuteUI.Theme.highlightColor
                                         : CuteUI.Theme.textColor
                    font.pointSize: body.font.pointSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: "Monospace"
                    text: index + 1
                }
            }
        }
    }

    function forceActiveFocus() {
        body.forceActiveFocus()
    }

    function goToLine(line) {
        if (line > 0 && line <= body.lineCount) {
            body.cursorPosition = document.goToLine(line - 1)
            body.forceActiveFocus()
        }
    }

    FileDialog {
        id: fileSaveAsDialog
        title: qsTr("另存为...")
        folder: shortcuts.home
        nameFilters: [ qsTr("全部类型 (*)") ]

        selectExisting: false
        selectFolder: false
        selectMultiple: false

        onAccepted: {
            document.fileUrl = fileSaveAsDialog.fileUrl.toString()
            newFile = false
            save()
        }
        Component.onCompleted: visible = false
    }

    function saveas() {
        fileSaveAsDialog.folder = (newFile
            ? fileSaveAsDialog.shortcuts.documents
            : document.fileUrl.toString().slice(0, -document.filename.length))
        fileSaveAsDialog.open()
    }

    function save() {
        if(newFile)
            saveas()
        else if(documentModified)
            document.saveAs(document.fileUrl) 
    }
}