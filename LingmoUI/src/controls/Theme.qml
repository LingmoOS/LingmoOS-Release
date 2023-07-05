pragma Singleton

import QtQuick 2.4
import CuteUI.Core 1.0 as CuteUICore

QtObject {
    id: theme

    property real devicePixelRatio: CuteUICore.ThemeManager.devicePixelRatio

    property bool darkMode: CuteUICore.ThemeManager.darkMode

    property color blueColor: CuteUICore.ThemeManager.blueColor
    property color redColor: CuteUICore.ThemeManager.redColor
    property color greenColor: CuteUICore.ThemeManager.greenColor
    property color purpleColor: CuteUICore.ThemeManager.purpleColor
    property color pinkColor: CuteUICore.ThemeManager.pinkColor
    property color orangeColor: CuteUICore.ThemeManager.orangeColor
    property color greyColor: CuteUICore.ThemeManager.greyColor

    property color backgroundColor: darkMode ? "#1C1C1D" : "#F3F4F9"
    property color secondBackgroundColor: darkMode ? "#2C2C2D" : "#FFFFFF"
    property color alternateBackgroundColor: darkMode ? "#3C3C3D" : "#F2F4F5"

    property color textColor: darkMode ? "#FFFFFF" : "#323238"
    property color disabledTextColor: darkMode ? "#888888" : "#64646E"

    property color settingsTextColor: darkMode ? "#787575" : "#C1C1CE"

    property color highlightColor: CuteUICore.ThemeManager.accentColor
    property color highlightedTextColor: darkMode ? "#FFFFFF" : "#FFFFFF"

    property color activeTextColor: "#0176D3"
    property color activeBackgroundColor: "#0176D3"
    
    property color linesColor: "#0059FF"
    property color hoColor: "#B8B8B8"
    property color bcXColor: darkMode ? "#000000" : "#FFFFFF"
    property color fabcXColor: darkMode ? "#3C3C3D" : "#E2E3E4"
    property color nflatBoColor: "#FF5787"
    property color winMaxColor: "#1EC700"
    property color winMinColor: "#D5E400"
    property color wBoColor: darkMode ? "#FF618E" : "#FFBCCF"

    property color linkColor: "#2196F3"
    property color linkBackgroundColor: "#2196F3"
    property color visitedLinkColor: "#2196F3"
    property color visitedLinkBackgroundColor: "#2196F3"

    property real fontSize: CuteUICore.ThemeManager.fontSize
    property string fontFamily: CuteUICore.ThemeManager.fontFamily

    property real smallRadius: 20.0 // 8.0
    property real mediumRadius: 20.0 // 10.0
    property real bigRadius: 20.0 // 12.0
    property real hugeRadius: 20.0 // 14.0
    property real windowRadius: 20.0

    property var renderType: Text.QtRendering

    property font defaultFont: fontMetrics.font
    property font smallFont: {
        let font = fontMetrics.font
        if (!!font.pixelSize) {
            font.pixelSize =- 2
        } else {
            font.pointSize =- 2
        }
        return font
    }

    property list<QtObject> children: [
        TextMetrics {
            id: fontMetrics
        }
    ]
}
