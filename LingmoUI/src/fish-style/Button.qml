// //CuteOS - Button
// import QtQuick 2.12
// import QtQuick.Controls 2.12
// import QtQuick.Templates 2.12 as T
// import QtGraphicalEffects 1.0
// import CuteUI 1.0 as CuteUI
// import QtQuick.Controls.impl 2.12
import QtQuick 2.4
import QtQuick.Templates 2.4 as T
import CuteUI 1.0 as CuteUI
import QtQuick.Controls.impl 2.4

T.Button
{
    id: control
    implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + CuteUI.Units.largeSpacing)
    implicitHeight: background.implicitHeight
    hoverEnabled: true

    property color hoveredColor: Qt.tint(CuteUI.Theme.textColor, Qt.rgba(CuteUI.Theme.backgroundColor.r,
                                                                       CuteUI.Theme.backgroundColor.g,
                                                                       CuteUI.Theme.backgroundColor.b, 0.9))
    property color pressedColor: Qt.tint(CuteUI.Theme.textColor, Qt.rgba(CuteUI.Theme.backgroundColor.r,
                                                                       CuteUI.Theme.backgroundColor.g,
                                                                       CuteUI.Theme.backgroundColor.b, 0.8))

    property color flatHoveredColor: Qt.lighter(CuteUI.Theme.highlightColor, 1.1)
    property color flatPressedColor: Qt.darker(CuteUI.Theme.highlightColor, 1.1)

    icon.width: CuteUI.Units.iconSizes.small
    icon.height: CuteUI.Units.iconSizes.small

    icon.color: control.enabled ? (control.highlighted ? control.CuteUI.Theme.highlightColor : control.CuteUI.Theme.textColor) : control.CuteUI.Theme.disabledTextColor
    spacing: CuteUI.Units.smallSpacing

    contentItem: IconLabel {
        text: control.text
        font: control.font
        icon: control.icon
        color: !control.enabled ? control.CuteUI.Theme.disabledTextColor : control.flat ? CuteUI.Theme.highlightedTextColor : CuteUI.Theme.textColor
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display
        alignment: Qt.AlignCenter
    }

    background: Item {
        implicitWidth:  (CuteUI.Units.iconSizes.medium * 3) + CuteUI.Units.largeSpacing
        implicitHeight: CuteUI.Units.iconSizes.medium + CuteUI.Units.smallSpacing

        Rectangle {
            id: _border
            anchors.fill: parent
            radius: CuteUI.Theme.mediumRadius
            border.width: 1
            border.color: control.flat && control.enabled ? CuteUI.Theme.highlightColor : control.activeFocus || control.pressed ? CuteUI.Theme.highlightColor : 
                          Qt.tint(CuteUI.Theme.textColor, Qt.rgba(CuteUI.Theme.backgroundColor.r, CuteUI.Theme.backgroundColor.g, CuteUI.Theme.backgroundColor.b, 0.7))
            color: control.flat && control.enabled ? control.pressed ? control.flatPressedColor : control.hovered ? control.flatHoveredColor : CuteUI.Theme.highlightColor
                                                   : control.pressed ? control.pressedColor : control.hovered ? control.hoveredColor : CuteUI.Theme.backgroundColor
        }
    }
}
// T.Button {
//     id: control
//     implicitWidth: Math.max(background.implicitWidth, contentItem.implicitWidth + CuteUI.Units.largeSpacing)
//     implicitHeight: background.implicitHeight
//     hoverEnabled: true

//     icon.width: CuteUI.Units.iconSizes.small
//     icon.height: CuteUI.Units.iconSizes.small

//     icon.color: control.enabled ? (control.highlighted ? control.CuteUI.Theme.highlightColor : control.CuteUI.Theme.textColor) : control.CuteUI.Theme.disabledTextColor
//     spacing: CuteUI.Units.smallSpacing

//     // property color hoveredColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.alternateBackgroundColor, 1.2)
//     //                                                    : Qt.darker(CuteUI.Theme.alternateBackgroundColor, 1.1)

//     // property color pressedColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.alternateBackgroundColor, 1.1)
//     //                                                    : Qt.darker(CuteUI.Theme.alternateBackgroundColor, 1.2)
//     property color hoveredColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.wBoColor, 1.2)
//                                                        : Qt.darker(CuteUI.Theme.wBoColor, 1.1)

//     property color pressedColor: CuteUI.Theme.darkMode ? Qt.lighter(CuteUI.Theme.wBoColor, 1.1)
//                                                        : Qt.darker(CuteUI.Theme.wBoColor, 1.2)

//     property color borderColor: Qt.rgba(CuteUI.Theme.highlightColor.r,
//                                         CuteUI.Theme.highlightColor.g,
//                                         CuteUI.Theme.highlightColor.b, 0.5)

//     property color flatHoveredColor: Qt.rgba(CuteUI.Theme.highlightColor.r,
//                                              CuteUI.Theme.highlightColor.g,
//                                              CuteUI.Theme.highlightColor.b, 0.2)
//     property color flatPressedColor: Qt.rgba(CuteUI.Theme.highlightColor.r,
//                                              CuteUI.Theme.highlightColor.g,
//                                              CuteUI.Theme.highlightColor.b, 0.25)

//     contentItem: IconLabel {
//         text: control.text
//         font: control.font
//         icon: control.icon
//         // color: !control.enabled ? control.CuteUI.Theme.disabledTextColor : control.flat ? CuteUI.Theme.highlightColor : CuteUI.Theme.textColor
//         // color: CuteUI.Theme.textColor
//         color: !control.flat ? control.CuteUI.Theme.nflatBoColor : control.flat ? CuteUI.Theme.linesColor : CuteUI.Theme.textColor
//         spacing: control.spacing
//         mirrored: control.mirrored
//         display: control.display
//         alignment: Qt.AlignCenter
//     }

//     background: Item {
//         implicitWidth: (CuteUI.Units.iconSizes.medium * 3) + CuteUI.Units.largeSpacing
//         implicitHeight: CuteUI.Units.iconSizes.medium + CuteUI.Units.smallSpacing

//         Rectangle {
//             id: _flatBackground
//             anchors.fill: parent
//             radius: 20
//             border.width: 2
//             border.color: CuteUI.Theme.linesColor
//             visible: control.flat

//             color: {
//                 if (!control.enabled)
//                     // return CuteUI.Theme.alternateBackgroundColor
//                     return "transparent"

//                 if (control.pressed)
//                     return control.flatPressedColor

//                 if (control.hovered)
//                     return control.flatHoveredColor
//                     // return CuteUI.Theme.hoColor

//                 return "transparent"
//                 // return Qt.rgba(CuteUI.Theme.highlightColor.r,
//                 //                CuteUI.Theme.highlightColor.g,
//                 //                CuteUI.Theme.highlightColor.b, 0.1)
//             }
//         }

//         Rectangle {
//             id: _background
//             anchors.fill: parent
//             radius: 20
//             border.width: 2
//             visible: !control.flat
//             // border.color: control.enabled ? control.activeFocus ? CuteUI.Theme.highlightColor : "transparent"
//             //                               : "transparent"
//             border.color: CuteUI.Theme.nflatBoColor

//             color: {
//                 if (!control.enabled)
//                     return "transparent"

//                 if (control.pressed)
//                     return control.pressedColor

//                 if (control.hovered)
//                     return control.hoveredColor

//                 // return CuteUI.Theme.alternateBackgroundColor
//                 return "transparent"
//             }
//         }

//         // Rectangle {
//         //     id: _background
//         //     anchors.fill: parent
//         //     radius: 20
//         //     border.width: 0
//         //     visible: !control.flat
//         //     border.color: control.enabled ? control.activeFocus ? CuteUI.Theme.highlightColor : "transparent"
//         //                                   : "transparent"

//         //     color: {
//         //         if (!control.enabled)
//         //             return CuteUI.Theme.alternateBackgroundColor

//         //         if (control.pressed)
//         //             return control.pressedColor

//         //         if (control.hovered)
//         //             return control.hoveredColor

//         //         return CuteUI.Theme.alternateBackgroundColor
//         //     }
//         // }
//     }
// }