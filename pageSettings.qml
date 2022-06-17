import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Item {
    id: element
    width: 1040
    height: 465
    implicitWidth: 1280
    implicitHeight: 620
    Rectangle {
        id: rotorpage
        color: "#36393f"
        radius: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0


        Text {
            id: textCoordinatesMove1
            x: 50
            width: 580
            height: 40
            color: "#ababab"
            text: qsTr("Параметры двигателей")
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            font.pixelSize: 24
            anchors.leftMargin: 420
            anchors.topMargin: 120
            anchors.left: parent.left
            anchors.top: parent.top

            Rectangle {
                id: coordinateMovePlace5
                x: -395
                y: -80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText5
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("1 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText5
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    font.family: "MS Shell Dlg 2"
                    selectionColor: "#6495ed"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: coordinateMovePlace6
                x: -205
                y: -80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText6
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("2 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText6
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    selectionColor: "#6495ed"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: coordinateMovePlace7
                x: -15
                y: -80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText7
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("3 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText7
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    selectionColor: "#6495ed"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(\d{1,10})([.,]\d{1,2})?$/}
                }
            }


            Rectangle {
                id: coordinateMovePlace8
                x: 175
                y: -80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText8
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("4 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText8
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    selectionColor: "#6495ed"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            BtnCustom {
                id: btnDelitel
                x: -202
                y: -5
                width: 160
                height: 40
                text: "делитель"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: {
                    motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                           coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 91)
                }
            }

            BtnCustom {
                id: btnСurrent
                x: -392
                y: -5
                width: 160
                height: 40
                text: "ток"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: {
                    motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                           coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 92)
                }
            }

            Text {
                id: textCoordinatesMove2
                x: 640
                y: 272
                width: 334
                height: 40
                color: "#ababab"
                text: qsTr("Пересчет шагов в градусы")
                font.bold: true
                font.pixelSize: 24
                anchors.leftMargin: 0
                anchors.topMargin: 60
                anchors.top: parent.top
                anchors.left: parent.left

                Text {
                    id: element1
                    x: 340
                    y: 3
                    width: 234
                    height: 31
                    color: "#ababab"
                    text: qsTr("(кол-во шагов в 1 градусе)")
                    font.bold: false
                    font.pixelSize: 20
                }

                BtnCustom {
                    id: btnSetToAngle
                    x: -202
                    y: -5
                    width: 160
                    height: 40
                    text: "Установить"
                    font.pixelSize: 20
                    spacing: 4
                    focusPolicy: Qt.NoFocus
                    onClicked: {
                        motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                               coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 100)
                    }
                }
            }

            Text {
                id: textCoordinatesMove3
                x: 0
                y: 116
                width: 233
                height: 40
                color: "#ababab"
                text: qsTr("Предельные углы")
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                font.pixelSize: 24
                anchors.top: parent.top
                font.bold: true
                anchors.leftMargin: 0
                anchors.topMargin: 120

                BtnCustom {
                    id: btnMaxAngle
                    x: -202
                    y: -5
                    width: 160
                    height: 40
                    text: "Максимальные"
                    font.pixelSize: 20
                    focusPolicy: Qt.NoFocus
                    spacing: 4
                    onClicked: {
                        motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                               coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 102)
                    }
                }

                BtnCustom {
                    id: btnMinAngle
                    x: -392
                    y: -5
                    width: 160
                    height: 40
                    text: "Минимальные"
                    font.pixelSize: 20
                    focusPolicy: Qt.NoFocus
                    spacing: 4
                    onClicked: {
                        motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                               coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 101)
                    }
                }

                Text {
                    id: element2
                    x: 235
                    y: 5
                    width: 234
                    height: 31
                    color: "#ababab"
                    text: qsTr("(0 - нет ограничений)")
                    font.bold: false
                    font.pixelSize: 20
                }
            }

            Text {
                id: textCoordinatesMove4
                x: 0
                y: 117
                width: 580
                height: 40
                color: "#ababab"
                text: qsTr("Параметры для перемещений по координатам")
                horizontalAlignment: Text.AlignLeft
                anchors.left: parent.left
                font.pixelSize: 24
                anchors.top: parent.top
                font.bold: true
                anchors.leftMargin: 0
                anchors.topMargin: 180
                BtnCustom {
                    id: btnCustmSpeed
                    x: -202
                    y: -5
                    width: 160
                    height: 40
                    text: "Скорость"
                    font.pixelSize: 20
                    focusPolicy: Qt.NoFocus
                    spacing: 4
                    onClicked: {
                        motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                               coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 104)
                    }
                }

                BtnCustom {
                    id: btnCustmAccel
                    x: -392
                    y: -5
                    width: 160
                    height: 40
                    text: "Ускорение"
                    font.pixelSize: 20
                    focusPolicy: Qt.NoFocus
                    spacing: 4
                    onClicked: {
                        motorQML.getRotorValue(coordinateMoveEnterText5.text, coordinateMoveEnterText6.text,
                                               coordinateMoveEnterText7.text, coordinateMoveEnterText8.text, 103)
                    }
                }
            }
        }
    }
}














































/*##^## Designer {
    D{i:4;anchors_x:50;anchors_y:30}D{i:6;anchors_x:0;anchors_y:"-40"}D{i:5;anchors_x:0;anchors_y:"-40"}
D{i:3;anchors_x:25;anchors_y:30}D{i:21;anchors_x:25}D{i:24;anchors_x:25}D{i:27;anchors_x:25}
D{i:2;anchors_width:1280;anchors_x:0;anchors_y:0}D{i:1;anchors_height:620;anchors_width:1280}
}
 ##^##*/
