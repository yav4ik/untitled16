import QtQuick 2.12
import QtQuick.Controls 2.5

Button {
    id: btnNonVis

    // CUSTOM PROPERTIES
    property color btnColorDefault: "#adadad"
    property color btnColorMouseOver: "#cdcdcd"
    property color btnColorClicked: "#ebebeb"
    property int backRadius: 10

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnNonVis.down){
                                       if(btnNonVis.hovered){
                                           btnNonVis.down ? btnColorClicked : btnColorDefault
                                       }
                                       else{
                                           btnColorDefault
                                       }
                                   } else {
                                       btnNonVis.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    text: qsTr("btnNonVis")
    font.pixelSize: 20
    implicitHeight: 100
    implicitWidth: 200

    background: Rectangle{
        color: internal.dynamicColor
        radius: backRadius
    }
}
