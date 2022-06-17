import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Button{
    id: btnImageDynamic
    // CUSTOM PROPERTIES
    property url btnIconSource: "images/krest.png"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#00a1f1"
    property int roudRadius: 0
    display: AbstractButton.IconOnly
    focusPolicy: Qt.TabFocus


    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnImageDynamic.down){
                                       if(btnImageDynamic.hovered){
                                           btnImageDynamic.down ? btnColorClicked : btnColorDefault
                                       }
                                       else{
                                           btnColorDefault
                                       }
                                   } else {
                                       btnImageDynamic.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    implicitWidth: 40
    implicitHeight: 40

    background: Rectangle{
        id: bgBtn
        color: internal.dynamicColor
        radius: roudRadius

        Image {
            id: iconBtn
            anchors.fill: parent
            source: btnIconSource
            sourceSize.height: 40
            sourceSize.width: 40
            fillMode: Image.PreserveAspectFit
            visible: true
        }
    }
}



/*##^## Designer {
    D{i:3;anchors_width:70;anchors_x:0;anchors_y:0}
}
 ##^##*/
