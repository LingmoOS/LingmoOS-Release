/*
 * Copyright (C) 2023 CuteOS Team.
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import Qt.labs.platform 1.0

import Cute.FileManager 1.0 as FM
import CuteUI 1.0 as CuteUI
import "./"

Item {
    id: rootItem
    opacity: 0.99
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    GlobalSettings {
        id: globalSettings
    }

    Wallpaper {
        anchors.fill: parent
    }

    FM.FolderModel {
        id: dirModel
        url: desktopPath()
        isDesktop: true
        sortMode: -1
        viewAdapter: viewAdapter

        onCurrentIndexChanged: {
            _folderView.currentIndex = dirModel.currentIndex
        }
    }

    FM.ItemViewAdapter {
        id: viewAdapter
        adapterView: _folderView
        adapterModel: dirModel
        adapterIconSize: 40
        adapterVisibleArea: Qt.rect(_folderView.contentX, _folderView.contentY,
                                    _folderView.contentWidth, _folderView.contentHeight)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: _folderView.forceActiveFocus()
    }

    FolderGridView {
        id: _folderView
        anchors.fill: parent

        isDesktopView: true
        iconSize: globalSettings.desktopIconSize
        maximumIconSize: globalSettings.maximumIconSize
        minimumIconSize: 22
        focus: true
        model: dirModel

        // Label {
        //     text: qsTr("-\nOpenSwift Linux \nOS Type: GNU/Linux \nOpenSwift Version: 8.62.2.235-Release  \nType: Release  \nKernel Version: 5.15.0-67-generic \nUpstream Release: Debian 11.2 \nCompile time: 2023-05-13 \nhttps://swifts.org.cn/openswift \nhttps://bbs.swifts.org.cn \nhttps://gitee.com/open-swift")
        //     Layout.fillWidth: true
        //     wrapMode: Text.Wrap
        //     color: "#FFFFFF"
        //     width: parent.width
        //     height: parent.height
        //     font.pixelSize: 20
        //     font.bold: false
        //     font.family: "Ubuntu"
        //     verticalAlignment: Text.AlignButton
        //     horizontalAlignment: Text.AlignRight
        // }

        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

        // Handle for topbar
        topMargin: 28

        // From dock
        leftMargin: Dock.leftMargin
        rightMargin: Dock.rightMargin
        bottomMargin: Dock.bottomMargin

        flow: GridView.FlowTopToBottom

        delegate: FolderGridItem {}

        onIconSizeChanged: {
            globalSettings.desktopIconSize = _folderView.iconSize
        }

        onActiveFocusChanged: {
            if (!activeFocus) {
                _folderView.cancelRename()
                dirModel.clearSelection()
            }
        }

        Component.onCompleted: {
            dirModel.requestRename.connect(rename)
        }
    }

    FM.ShortCut {
        id: shortCut

        Component.onCompleted: {
            shortCut.install(_folderView)
        }

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
        onDeleteFile: {
            dirModel.keyDeletePress()
        }
        onKeyPressed: {
            dirModel.keyboardSearch(text)
        }
        onShowHidden: {
            dirModel.showHiddenFiles = !dirModel.showHiddenFiles
        }
        onUndo: {
            dirModel.undo()
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
}
