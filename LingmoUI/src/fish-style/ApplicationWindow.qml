import QtQuick 2.4
import QtQuick.Window 2.4
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import QtQuick.Templates 2.4 as T

T.ApplicationWindow {
    id: window

    color: palette.window

    overlay.modal: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.5)
    }

    overlay.modeless: Rectangle {
        color: Color.transparent(window.palette.shadow, 0.12)
    }
}
