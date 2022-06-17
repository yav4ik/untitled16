import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Item {
    width: 1040
    height: 465
    implicitWidth: 1280
    implicitHeight: 620

//    Connections {
//        target: motorQML
//        onPositionToLabelText: {
//            manContrPositionInfo1.text = var1
//            manContrPositionInfo2.text = var2
//            manContrPositionInfo3.text = var3
//            manContrPositionInfo4.text = var4
//        }
//    }

    Rectangle {
        id: manualControlBG
        implicitWidth: 1080
        implicitHeight: 620
        color: "#36393f"
        radius: 0
        anchors.fill: parent

        Text {
            id: textCoordinatesMove
            width: 750
            height: 40
            color: "#ababab"
            text: qsTr("Установка координаты перемещения")
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 25
            style: Text.Normal
            font.capitalization: Font.MixedCase
            font.pixelSize: 24

            Rectangle {
                id: coordinateMovePlace1
                x: 0
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText1
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("1 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText1
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    font.family: "MS Shell Dlg 2"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: coordinateMovePlace2
                x: 205
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText2
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("2 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText2
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}

                }
            }

            Rectangle {
                id: coordinateMovePlace3
                x: 410
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText3
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("3 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText3
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: coordinateMovePlace4
                x: 615
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: coordinateMoveText4
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("4 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: coordinateMoveEnterText4
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            BtnCustom {
                id: btnCoordinateMoveTo
                x: 820
                y: 20
                width: 160
                height: 40
                text: "переместить к"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: motorQML.getRotorValue(coordinateMoveEnterText1.text, coordinateMoveEnterText2.text,
                                                  coordinateMoveEnterText3.text, coordinateMoveEnterText4.text, 5)
            }

            BtnCustom {
                id: btnCoordinateMoveTrought
                x: 820
                y: 80
                width: 160
                height: 40
                text: "переместить на"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: motorQML.getRotorValue(coordinateMoveEnterText1.text, coordinateMoveEnterText2.text,
                                                  coordinateMoveEnterText3.text, coordinateMoveEnterText4.text, 4)
            }

            font.bold: true
            font.weight: Font.Normal
        }



        Rectangle {
            id: line
            y: 155
            width: 1230
            height: 2
            color: "#adadad"
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.left: parent.left
            anchors.leftMargin: 25
        }

        Text {
            id: textMove
            width: 365
            height: 40
            color: "#ababab"
            text: qsTr("Запуск двигателей по скоростям")
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.top: parent.top
            anchors.topMargin: 170
            font.capitalization: Font.MixedCase
            style: Text.Normal
            font.pixelSize: 24

            Rectangle {
                id: setMovePlace1
                x: 0
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: setMoveText1
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("1 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setMoveEnterText1
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    font.family: "MS Shell Dlg 2"
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: setMovePlace2
                x: 205
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10
                anchors.top: parent.top
                anchors.topMargin: 80
                anchors.left: parent.left
                anchors.leftMargin: 205

                Text {
                    id: setMoveText2
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("2 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setMoveEnterText2
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: setMovePlace3
                x: 410
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: setMoveText3
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("3 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setMoveEnterText3
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            Rectangle {
                id: setMovePlace4
                x: 615
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10

                Text {
                    id: setMoveText4
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("4 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setMoveEnterText4
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    selectionColor: "#6495ED"
                    maximumLength: 10
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }

            }

            BtnCustom {
                id: btnSetMoveStart
                x: 820
                y: 20
                width: 160
                height: 40
                text: "старт"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: motorQML.getRotorValue(setMoveEnterText1.text, setMoveEnterText2.text,
                                                  setMoveEnterText3.text, setMoveEnterText4.text, 2)
            }


            BtnCustom {
                id: btnSetMoveStop
                x: 820
                y: 80
                width: 160
                height: 40
                text: "стоп"
                font.pixelSize: 20
                spacing: 4
                focusPolicy: Qt.NoFocus
                onClicked: motorQML.btnStop()
            }

            Text {
                id: startDescr
                x: 425
                y: 6
                width: 411
                height: 40
                color: "#ababab"
                text: qsTr("(Для инверсии вводить отрицательные значения)")
                font.pixelSize: 16
            }
            font.bold: true
            font.weight: Font.Normal
        }

        Rectangle {
            id: line1
            y: 310
            width: 1230
            height: 2
            color: "#adadad"
            anchors.right: parent.right
            anchors.rightMargin: 25
            anchors.left: parent.left
            anchors.leftMargin: 25
        }

        Text {
            id: textSetPosition
            x: 25
            y: 325
            width: 750
            height: 40
            color: "#ababab"
            text: qsTr("Ручная установка позиций двигателей в градусах")
            Rectangle {
                id: setPositionPlace1
                x: 0
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10
                Text {
                    id: setPositionTextRotor1
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("1 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setPositionEnterText1
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    selectionColor: "#6495ed"
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                    font.family: "MS Shell Dlg 2"
                    maximumLength: 10
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                }
            }

            Rectangle {
                id: setPositionPlace2
                x: 205
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10
                Text {
                    id: setPositionTextRotor2
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("2 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setPositionEnterText2
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    selectionColor: "#6495ed"
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                    maximumLength: 10
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                }
            }

            Rectangle {
                id: setPositionPlace3
                x: 410
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10
                Text {
                    id: setPositionTextRotor3
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("3 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setPositionEnterText3
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    selectionColor: "#6495ed"
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                    maximumLength: 10
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                }
            }

            Rectangle {
                id: setPositionPlace4
                x: 615
                y: 80
                width: 165
                height: 40
                color: "#6e6e6e"
                radius: 10
                Text {
                    id: setPositionTextRotor4
                    x: 0
                    y: -30
                    width: 165
                    height: 30
                    color: "#ababab"
                    text: qsTr("4 двигатель")
                    font.pixelSize: 20
                }

                TextInput {
                    id: setPositionEnterText4
                    x: 8
                    y: 5
                    width: 150
                    height: 30
                    color: "#ebebeb"
                    selectionColor: "#6495ed"
                    maximumLength: 10
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignLeft
                    selectByMouse: true
                    validator: RegExpValidator{regExp: /(-?)(\d{1,10})([.,]\d{1,2})?$/}
                }
            }

            BtnCustom {
                id: btnSetPosition
                x: 820
                y: 80
                width: 160
                height: 40
                text: "установить"
                font.pixelSize: 20
                onClicked: motorQML.getRotorValue(setPositionEnterText1.text, setPositionEnterText2.text,
                                                  setPositionEnterText3.text, setPositionEnterText4.text, 7)
            }
            font.bold: true
            font.capitalization: Font.MixedCase
            style: Text.Normal
            font.pixelSize: 24
            font.weight: Font.Normal
        }
    }
}








