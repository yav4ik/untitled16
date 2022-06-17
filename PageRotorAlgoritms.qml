import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Item {
    width: 1040
    height: 465
    implicitWidth: 1280
    implicitHeight: 620

    Rectangle {
        id: rectangle
        height: 465
        implicitWidth: 1080
        implicitHeight: 620
        color: "#36393f"
        radius: 5
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            height: 20
            color: "#36393f"
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        TextEdit {
            id: textEdit
            x: 418
            y: 90
            width: 224
            height: 106
            color: "#0d62e9"
            text: qsTr("Text Edit")
            anchors.horizontalCenter: parent.horizontalCenter
            renderType: Text.QtRendering
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 42
        }

        Text {
            id: element
            x: 413
            y: 208
            width: 234
            height: 132
            color: "#0d62e9"
            text: "алгоритмы"
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 42
        }

        TextInput {
            id: textInput
            x: 413
            y: 396
            width: 256
            height: 130
            color: "#0d62e9"
            text: qsTr("Text Input")
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 42
        }

    }
}
