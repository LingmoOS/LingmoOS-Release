import QtQuick 2.1
import QtQuick.Window 2.2
import QtQuick.Templates 2.3 as T
import CuteUI 1.0 as CuteUI

T.Label {
    id: control

    verticalAlignment: lineCount > 1 ? Text.AlignTop : Text.AlignVCenter

    activeFocusOnTab: false
    // Text.NativeRendering is broken on non integer pixel ratios
    // renderType: Window.devicePixelRatio % 1 !== 0 ? Text.QtRendering : Text.NativeRendering

    renderType: CuteUI.Theme.renderType

    font.capitalization: CuteUI.Theme.defaultFont.capitalization
    font.family: CuteUI.Theme.fontFamily
    font.italic: CuteUI.Theme.defaultFont.italic
    font.letterSpacing: CuteUI.Theme.defaultFont.letterSpacing
    font.pointSize: CuteUI.Theme.fontSize
    font.strikeout: CuteUI.Theme.defaultFont.strikeout
    font.underline: CuteUI.Theme.defaultFont.underline
    font.weight: CuteUI.Theme.defaultFont.weight
    font.wordSpacing: CuteUI.Theme.defaultFont.wordSpacing
    color: CuteUI.Theme.textColor
    linkColor: CuteUI.Theme.linkColor

    opacity: enabled ? 1 : 0.6

    Accessible.role: Accessible.StaticText
    Accessible.name: text
}
