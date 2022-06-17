import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Button{
    id: btnToggle
    // CUSTOM PROPERTIES
    property url btnIconSource: "images/krest.png"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"
    property color overlayColor: "#ababab"
    property int roudRadius: 0

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnToggle.pressed){
                                       btnToggle.hovered ? btnColorClicked : btnColorDefault
                                   }
                                   else {
                                       btnToggle.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    implicitWidth: 70
    implicitHeight: 60

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
            color: overlayColor
            antialiasing: false
        }
    }
}


/*##^## Designer {
    D{i:3;anchors_height:25;anchors_width:25}
}
 ##^##*/
