import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Button{
    id: btnClose
    // CUSTOM PROPERTIES
    property url btnIconSource: "images/krest.png"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"
    property int roudRadius: 0
    font.capitalization: Font.Capitalize
    display: AbstractButton.TextBesideIcon
    focusPolicy: Qt.NoFocus

    Rectangle {
        id: rectangle1
        x: -8
        y: 44
        height: 10
        color: internal.dynamicColor
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnClose.down){
                                       btnClose.hovered ? btnColorClicked : btnColorDefault
                                   }
                                   else {
                                       btnClose.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    Rectangle {
        id: rectangle
        width: 10
        color: internal.dynamicColor
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }


    implicitWidth: 70
    implicitHeight: 70

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        radius: roudRadius

        Image {
            id: iconBtn
            source: btnIconSource
            anchors.fill: parent
            height: 25
            width: 25
            fillMode: Image.PreserveAspectFit
            visible: false
        }

        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: "#ababab"
            antialiasing: false
        }
    }
}

