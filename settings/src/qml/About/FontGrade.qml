import QtQuick 2.14
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CuteUI 1.0 as CuteUI
import Cute.Settings 1.0
import QtGraphicalEffects 1.14

Rectangle {
    id: fontGrade
    width: 325
    height: 75
    color: CuteUI.Theme.backgroundColor
    property string info: "Swift GNU/Linux"
    property int idxx: 1
    Text {
        id: name
        visible: !about.isCuteOS
        leftPadding: CuteUI.Units.largeSpacing * 2
        rightPadding: CuteUI.Units.largeSpacing * 2
        text: info
        anchors.fill: parent
        font.pointSize: 26
        font.family: "Ubuntu Light"
        font.bold: false
    }
    LinearGradient  {
        anchors.fill: name
        source: name
        start: Qt.point(0, 0)  // start 和 end主要作用是从左往右
        end: Qt.point(fontGrade.width, 0)
        gradient: Gradient {
        //    GradientStop { position: 0.0; color: Qt.hsva((15 - (((idxx + 30) > 15) ? idxx - 15 + 30:idxx + 30)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.1; color: Qt.hsva((15 - (((idxx + 29) > 15) ? idxx - 15 + 29:idxx + 29)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.2; color: Qt.hsva((15 - (((idxx + 28) > 15) ? idxx - 15 + 28:idxx + 28)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.3; color: Qt.hsva((15 - (((idxx + 27) > 15) ? idxx - 15 + 27:idxx + 27)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.4; color: Qt.hsva((15 - (((idxx + 26) > 15) ? idxx - 15 + 26:idxx + 26)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.5; color: Qt.hsva((15 - (((idxx + 25) > 15) ? idxx - 15 + 25:idxx + 25)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.6; color: Qt.hsva((15 - (((idxx + 24) > 15) ? idxx - 15 + 24:idxx + 24)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.7; color: Qt.hsva((15 - (((idxx + 23) > 15) ? idxx - 15 + 23:idxx + 23)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.8; color: Qt.hsva((15 - (((idxx + 22) > 15) ? idxx - 15 + 22:idxx + 22)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 0.9; color: Qt.hsva((15 - (((idxx + 21) > 15) ? idxx - 15 + 21:idxx + 21)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.0; color: Qt.hsva((15 - (((idxx + 20) > 15) ? idxx - 15 + 20:idxx + 20)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.1; color: Qt.hsva((15 - (((idxx + 19) > 15) ? idxx - 15 + 19:idxx + 19)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.2; color: Qt.hsva((15 - (((idxx + 18) > 15) ? idxx - 15 + 18:idxx + 18)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.3; color: Qt.hsva((15 - (((idxx + 17) > 15) ? idxx - 15 + 17:idxx + 17)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.4; color: Qt.hsva((15 - (((idxx + 16) > 15) ? idxx - 15 + 16:idxx + 16)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.5; color: Qt.hsva((15 - (((idxx + 15) > 15) ? idxx - 15 + 15:idxx + 15)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.6; color: Qt.hsva((15 - (((idxx + 14) > 15) ? idxx - 15 + 14:idxx + 14)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.7; color: Qt.hsva((15 - (((idxx + 13) > 15) ? idxx - 15 + 13:idxx + 13)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.8; color: Qt.hsva((15 - (((idxx + 12) > 15) ? idxx - 15 + 12:idxx + 12)) * 16/255, 1, 1,1) }
        //    GradientStop { position: 1.9; color: Qt.hsva((15 - (((idxx + 11) > 15) ? idxx - 15 + 11:idxx + 11)) * 16/255, 1, 1,1) } 

            GradientStop { position: 0.0; color: Qt.hsva((15 - (((idxx + 10) > 15) ? idxx - 15 + 10:idxx + 10)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.1; color: Qt.hsva((15 - (((idxx + 9) > 15) ? idxx - 15 + 9:idxx + 9)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.2; color: Qt.hsva((15 - (((idxx + 8) > 15) ? idxx - 15 + 8:idxx + 8)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.3; color: Qt.hsva((15 - (((idxx + 7) > 15) ? idxx - 15 + 7:idxx + 7)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.4; color: Qt.hsva((15 - (((idxx + 6) > 15) ? idxx - 15 + 6:idxx + 6)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.5; color: Qt.hsva((15 - (((idxx + 5) > 15) ? idxx - 15 + 5:idxx + 5)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.6; color: Qt.hsva((15 - (((idxx + 4) > 15) ? idxx - 15 + 4:idxx + 4)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.7; color: Qt.hsva((15 - (((idxx + 3) > 15) ? idxx - 15 + 3:idxx + 3)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.8; color: Qt.hsva((15 - (((idxx + 2) > 15) ? idxx - 15 + 2:idxx + 2)) * 16/255, 1, 1,1) }
            GradientStop { position: 0.9; color: Qt.hsva((15 - (((idxx + 1) > 15) ? idxx - 15 + 1:idxx + 1)) * 16/255, 1, 1,1) }
            GradientStop { position: 1.0; color: Qt.hsva((15 - (((idxx) > 15) ? idxx - 15:idxx)) * 16/255, 1, 1,1) }
        }
    }

    SequentialAnimation {
        running: true  // 默认启动
        loops:Animation.Infinite  // 无限循环
        NumberAnimation {
            target: fontGrade  // 目标对象
            property: "idxx"  // 目标对象中的属性
            duration: 900 // 变化时间
            to: 15  // 目标值
        }
    }
}
