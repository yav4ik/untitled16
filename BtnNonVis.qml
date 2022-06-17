import QtQuick 2.12
import QtQuick.Controls 2.5

Button {
    id: btnNonVis

    // CUSTOM PROPERTIES
    property color btnColorDefault: "#adadad"
    property color btnColorMouseOver: "#cdcdcd"
    property color btnColorClicked: "#ebebeb"
    property int pixelTextSize: 28

    QtObject{
        id: internal

        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: if(btnNonVis.down){
                                       btnNonVis.down ? btnColorClicked : btnColorDefault
                                   } else {
                                       btnNonVis.hovered ? btnColorMouseOver : btnColorDefault
                                   }

    }

    text: qsTr("btnNonVis")
    //font.pixelSize: 20
    implicitHeight: 100
    implicitWidth: 200

    background: Rectangle{
        color: "#00000000"
        radius: 10
    }
    contentItem: Item {
        id: element
        Text {
            id: textBtn
            width: 200
            height: 100
            color: internal.dynamicColor
            text: btnNonVis.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            lineHeight: 1.5
            font.family: "Arial"
            font.pixelSize: pixelTextSize
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
