import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

import Cute.FileManager 1.0 as FM
import CuteUI 1.0 as CuteUI

import "./Dialogs"

Item {
    id: folderPage

    property alias currentUrl: dirModel.url
    property alias model: dirModel
    property Item currentView: _viewLoader.item
    property int statusBarHeight: 22

    signal requestPathEditor()

    onCurrentUrlChanged: {
        if (!_viewLoader.item)
            return

        _viewLoader.item.reset()
        _viewLoader.item.forceActiveFocus()
    }

    // Global Menu
    MenuBar {
        id: appMenu

        Menu {
            title: qsTr("File")

            MenuItem {
                text: qsTr("New Folder")
                onTriggered: dirModel.newFolder()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Properties")
                onTriggered: dirModel.openPropertiesDialog()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Quit")
                onTriggered: root.close()
            }
        }

        Menu {
            title: qsTr("Edit")

            MenuItem {
                text: qsTr("Select All")
                onTriggered: dirModel.selectAll()
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Cut")
                onTriggered: dirModel.cut()
            }

            MenuItem {
                text: qsTr("Copy")
                onTriggered: dirModel.copy()
            }

            MenuItem {
                text: qsTr("Paste")
                onTriggered: dirModel.paste()
            }
        }

        Menu {
            title: qsTr("Help")

            MenuItem {
                text: qsTr("About")
                onTriggered: _aboutDialog.show()
            }
        }
    }

    CuteUI.AboutDialog {
        id: _aboutDialog
        name: qsTr("File Manager")
        description: qsTr("A file manager designed for Lingmo OS.")
        iconSource: "image://icontheme/file-system-manager"
    }

    Rectangle {
        id: _background
        anchors.fill: parent
        anchors.rightMargin: 1
        radius: CuteUI.Theme.mediumRadius
        color: CuteUI.Theme.secondBackgroundColor

        Rectangle {
            id: _topRightRect
            anchors.right: parent.right
            anchors.top: parent.top
            height: CuteUI.Theme.mediumRadius
            width: CuteUI.Theme.mediumRadius
            color: CuteUI.Theme.secondBackgroundColor
        }

        Rectangle {
            id: _bottomLeftRect
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            height: CuteUI.Theme.mediumRadius
            width: CuteUI.Theme.mediumRadius
            color: CuteUI.Theme.secondBackgroundColor
        }
    }

    Label {
        id: _fileTips
        text: qsTr("Empty folder")
        font.pointSize: 15
        anchors.centerIn: parent
        visible: dirModel.status === FM.FolderModel.Ready
                 && _viewLoader.status === Loader.Ready
                 && _viewLoader.item.count === 0
    }

    FM.FolderModel {
        id: dirModel
        viewAdapter: viewAdapter
        sortMode: settings.sortMode
        // showHiddenFiles: settings.showHiddenFiles

        Component.onCompleted: {
            if (arg)
                dirModel.url = arg
            else
                dirModel.url = dirModel.homePath()
        }

        // For new folder rename.
        onCurrentIndexChanged: {
            _viewLoader.item.currentIndex = dirModel.currentIndex
        }
    }

    Connections {
        target: dirModel

        function onNotification(text) {
            root.showPassiveNotification(text, 3000)
        }

        // Scroll to item.
        function onScrollToItem(index) {
            _viewLoader.item.currentIndex = index
        }
    }

    FM.ItemViewAdapter {
        id: viewAdapter
        adapterView: _viewLoader.item
        adapterModel: _viewLoader.item.positioner ? _viewLoader.item.positioner : dirModel
        adapterIconSize: 40
        adapterVisibleArea: Qt.rect(_viewLoader.item.contentX, _viewLoader.item.contentY,
                                    _viewLoader.item.contentWidth, _viewLoader.item.contentHeight)
    }

    CuteUI.DesktopMenu {
        id: folderMenu

        MenuItem {
            text: qsTr("Open")
            onTriggered: dirModel.openSelected()
        }

        MenuItem {
            text: qsTr("Properties")
            onTriggered: dirModel.openPropertiesDialog()
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.bottomMargin: 2
        spacing: 0

        Loader {
            id: _viewLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            asynchronous: true
            sourceComponent: switch (settings.viewMethod) {
                             case 0: return _listViewComponent
                             case 1: return _gridViewComponent
                             }

            onSourceComponentChanged: {
                // Focus
                _viewLoader.item.forceActiveFocus()

                // ShortCut
                shortCut.install(_viewLoader.item)
            }
        }

        Item {
            visible: true
            height: statusBarHeight
        }
    }

    Item {
        id: _statusBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: statusBarHeight
        z: 999

//        Rectangle {
//            anchors.fill: parent
//            color: CuteUI.Theme.backgroundColor
//            opacity: 0.7
//        }

        MouseArea {
            anchors.fill: parent
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: CuteUI.Units.smallSpacing
            anchors.rightMargin: CuteUI.Units.smallSpacing
            // anchors.bottomMargin: 1
            spacing: CuteUI.Units.largeSpacing

            Label {
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 10
                text: dirModel.count === 1 ? qsTr("%1 item").arg(dirModel.count)
                                           : qsTr("%1 items").arg(dirModel.count)
            }

            Label {
                Layout.alignment: Qt.AlignLeft
                font.pointSize: 10
                text: qsTr("%1 selected").arg(dirModel.selectionCount)
                visible: dirModel.selectionCount >= 1
            }

            CuteUI.BusyIndicator {
                id: _busyIndicator
                Layout.alignment: Qt.AlignLeft
                height: statusBarHeight
                width: height
                running: visible
                visible: dirModel.status === FM.FolderModel.Listing
            }

            Label {
                text: dirModel.selectedItemSize
                visible: dirModel.url !== "trash:///"
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                id: _emptyTrashBtn
                implicitHeight: statusBarHeight
                text: qsTr("Empty Trash")
                font.pointSize: 10
                onClicked: dirModel.emptyTrash()
                visible: dirModel.url === "trash:///"
                         && _viewLoader.item
                         && _viewLoader.item.count > 0
                focusPolicy: Qt.NoFocus
            }
        }
    }

    function rename() {
        _viewLoader.item.rename()
    }

    Component.onCompleted: {
        dirModel.requestRename.connect(rename)
    }

    Component {
        id: _gridViewComponent

        FolderGridView {
            id: _gridView
            model: dirModel
            delegate: FolderGridItem {}

            leftMargin: CuteUI.Units.smallSpacing
            rightMargin: CuteUI.Units.largeSpacing
            topMargin: 0
            bottomMargin: CuteUI.Units.smallSpacing

            onIconSizeChanged: {
                // Save
                settings.gridIconSize = _gridView.iconSize
            }

            onCountChanged: {
                _fileTips.visible = count === 0
            }
        }
    }

    Component {
        id: _listViewComponent

        FolderListView {
            id: _folderListView
            model: dirModel

            topMargin: CuteUI.Units.smallSpacing
            leftMargin: CuteUI.Units.largeSpacing
            rightMargin: CuteUI.Units.largeSpacing
            bottomMargin: CuteUI.Units.smallSpacing
            spacing: CuteUI.Units.largeSpacing

            onCountChanged: {
                _fileTips.visible = count === 0
            }

            delegate: FolderListItem {}
        }
    }

    Component {
        id: rubberBandObject

        FM.RubberBand {
            id: rubberBand

            width: 0
            height: 0
            z: 99999
            color: CuteUI.Theme.highlightColor

            function close() {
                opacityAnimation.restart()
            }

            OpacityAnimator {
                id: opacityAnimation
                target: rubberBand
                to: 0
                from: 1
                duration: 150

                easing {
                    bezierCurve: [0.4, 0.0, 1, 1]
                    type: Easing.Bezier
                }

                onFinished: {
                    rubberBand.visible = false
                    rubberBand.enabled = false
                    rubberBand.destroy()
                }
            }
        }
    }

    FM.ShortCut {
        id: shortCut

        onOpen: {
            dirModel.openSelected()
        }
        onCopy: {
            dirModel.copy()
        }
        onCut: {
            dirModel.cut()
        }
        onPaste: {
            dirModel.paste()
        }
        onRename: {
            dirModel.requestRename()
        }
        onOpenPathEditor: {
            folderPage.requestPathEditor()
        }
        onSelectAll: {
            dirModel.selectAll()
        }
        onBackspace: {
            dirModel.up()
        }
        onDeleteFile: {
            dirModel.keyDeletePress()
        }
        onRefresh: {
            dirModel.refresh()
        }
        onKeyPressed: {
            dirModel.keyboardSearch(text)
        }
        onShowHidden: {
            dirModel.showHiddenFiles = !dirModel.showHiddenFiles
        }
        onClose: {
            root.close()
        }
        onUndo: {
            dirModel.undo()
        }
    }

    function openUrl(url) {
        dirModel.url = url
        _viewLoader.item.forceActiveFocus()
    }

    function search(text) {

    }

    function goBack() {
        dirModel.goBack()
    }

    function goForward() {
        dirModel.goForward()
    }
}
