import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Dialogs 1.3

Window {
    id: window
    width: 1280
    height: 720
    color: "#00000000"
    opacity: 1
    title: ""
    visible: true

    // Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Properties
    property int windowStatus: 0
    property int roundRadius: 10
    property bool statusRotorMove1: false
    property bool statusRotorMove2: false
    property bool statusRotorMove3: false
    property bool statusRotorMove4: false
    property bool statusAllRotorMove: false
    property bool statusRototrConnection: false
    property bool logAndList: false
    property int contentY1: 0
    property int textflickHeight: 0
    property bool loadFlag: true


    // Internal functions
    QtObject {
        id: internal

        function maximizeRestore() {
            if (windowStatus == 0) {
                windowStatus = 1
                window.showMaximized()
                roundRadius = 0
            }
            else {
                windowStatus = 0
                window.showNormal()
                roundRadius = 10
            }
        }

        function maximizeWindowRestore() {
            if(windowStatus == 1) {
                windowStatus = 0
            }
        }

        function statusRotorsAndConnection() {
            if (statusRototrConnection == true){
                textConnect.color = "#3fff55"
                textConnect.text = "Подключено"
                rectangle1.color = "#3fff55"

                if(statusRotorMove1 == false) {showPosText1.color = "#ababab"}
                else {showPosText1.color = "#ebebeb"}

                if(statusRotorMove2 == false) {showPosText2.color = "#ababab"}
                else {showPosText2.color = "#ebebeb"}

                if(statusRotorMove3 == false) {showPosText3.color = "#ababab"}
                else {showPosText3.color = "#ebebeb"}

                if(statusRotorMove4 == false) {showPosText4.color = "#ababab"}
                else {showPosText4.color = "#ebebeb"}

                if(statusAllRotorMove == false) {
                    textWork.text = "Готов"
                    textWork.color = "#3fff55"
                    animatedImage.paused = true
                }
                else {
                    textWork.text = "Перемещение"
                    textWork.color = "#ff8000"
                    animatedImage.paused = false
                }
            }

            else{
                textConnect.color = "#e20606"
                textConnect.text = "Отключено"
                rectangle1.color = "#e20606"

                showPosInfo1.color = "#ababab"
                showPosInfo2.color = "#ababab"
                showPosInfo3.color = "#ababab"
                showPosInfo4.color = "#ababab"

                textWork.text = "Нет информации"
                textWork.color = "#ababab"
                animatedImage.paused = true
            }
        }
    }

    Connections {
        target: motorQML
        onConnectRotors: {
            statusRototrConnection = conStatus
            internal.statusRotorsAndConnection()
        }
        onRotorsRotation: {
            statusRotorMove1 = rotorStatus1
            statusRotorMove2 = rotorStatus2
            statusRotorMove3 = rotorStatus3
            statusRotorMove4 = rotorStatus4
            statusAllRotorMove = allStatusIcon
            internal.statusRotorsAndConnection()
        }
        onPositionToLabelText: {
            showPosInfo1.text = var1
            showPosInfo2.text = var2
            showPosInfo3.text = var3
            showPosInfo4.text = var4
        }

        onCommandListToGUI: {
            contentY1 = flickableCommandList.contentY
            textflickHeight = textAreaCommandList.height
            if (activeCommand !=""){
                textAreaCommandList.text = "<font color=\"#ebebeb\">ACTIVE " + activeCommand + "</font><br><br>" + message
            }

            else {
                textAreaCommandList.text = message
            }

            if (contentY1 != 0)
            {
                flickableCommandList.contentY = contentY1 + (textAreaCommandList.height - textflickHeight)
            }
        }

        onMessageToGUI: {
            contentY1 = flickableLogs.contentY
            textflickHeight = textAreaLogs.height
            textAreaLogs.text = message
            if (contentY1 != 0)
            {
                flickableLogs.contentY = contentY1 + (textAreaLogs.height - textflickHeight)
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file or directory"
        selectExisting: loadFlag
        nameFilters: [ "Text files (*.txt)", "All files (*)" ]
        onAccepted: {
            if(!loadFlag)
            {
                motorQML.btnSaveCommandList(fileDialog.fileUrls)
                motorQML.setPathToSave(fileDialog.folder)
            }
            else{
                motorQML.btnLoadCommandList(fileDialog.fileUrls)
                motorQML.setPathToSave(fileDialog.folder)
            }
        }
    }

    //    Loader {
    //        id: pageSettingsLoaded
    //        anchors.fill: parent
    //        source: Qt.resolvedUrl("pageSettings.qml")

    //    }

    Rectangle {
        id: rectangle
        height: 360
        color: "#36393f"
        radius: roundRadius
        border.color: "#00000000"
        anchors.fill: parent

        MouseArea {
            id: mouseAreaIconRight
            x: 1278
            y: 10
            width: 2
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 0
        }

        MouseArea {
            id: mouseAreaIconTop
            x: 1042
            y: 0
            width: 109
            height: 2
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: -1
            cursorShape: Qt.SizeVerCursor
        }

        MouseArea {
            id: mouseAreaTop
            width: 1151
            height: 4
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
            cursorShape: Qt.SizeVerCursor

        }

        MouseArea {
            id: mouseAreaBotton
            x: 20
            y: 716
            height: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        MouseArea {
            id: mouseAreaRight
            x: 1276
            y: 39
            width: 4
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 40
        }

        MouseArea {
            id: mouseAreaLeft
            x: 9
            y: 9
            width: 4
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            //            DragHandler {
            //                target: null
            //                onActiveChanged: if (active) { window.start
            //            }

        }



        Rectangle {
            id: tooolBar
            height: 100
            color: "#2f3136"
            radius: roundRadius
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Rectangle {
                id: tollBarHelper
                x: 0
                y: 41
                width: 1280
                height: 59
                color: "#2f3136"
            }

            Rectangle {
                id: line
                x: 1250
                y: 40
                height: 1
                color: "#adadad"
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
            }

            DragHandler {
                onActiveChanged: if(active) {
                                     internal.maximizeWindowRestore()
                                 }
            }


            BtnClose {
                id: btnClose
                x: 1240
                width: 40
                height: 40
                wheelEnabled: false
                focusPolicy: Qt.StrongFocus
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                btnColorMouseOver: "#c94132"
                btnColorDefault: "#2f3136"
                btnColorClicked: "#c42b1c"
                roudRadius: roundRadius
                btnIconSource: "images/krest.png"
                onClicked: {
                    motorQML.btnQuit()
                    window.close()
                }
            }

            BtnToggle {
                id: iconMinimazeBtn
                x: 1160
                width: 40
                height: 40
                focusPolicy: Qt.StrongFocus
                anchors.right: parent.right
                anchors.rightMargin: 80
                anchors.top: parent.top
                anchors.topMargin: 0
                btnColorMouseOver: "#23272e"
                btnColorDefault: "#2f3136"
                btnColorClicked: "#2f3136"
                btnIconSource: "images/palka.png"
                onClicked: window.showMinimized()
            }


            BtnToggle {
                id: iconFullBtn
                x: 1200
                width: 40
                height: 40
                hoverEnabled: true
                btnColorMouseOver: "#23272e"
                focusPolicy: Qt.StrongFocus
                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.top: parent.top
                anchors.topMargin: 0
                btnColorDefault: "#2f3136"
                btnColorClicked: "#2f3136"
                btnIconSource: "images/kvadrat.png"
                onClicked: internal.maximizeRestore()
            }


            //            BtnNonVis {
            //                id: positionBtn
            //                x: 20
            //                y: 50
            //                width: 180
            //                height: 40
            //                text: "ПОЗИЦИИ"
            //                font.capitalization: Font.MixedCase
            //                focusPolicy: Qt.NoFocus

            //                btnColorDefault: "#ebebeb"
            //                btnColorMouseOver: "#ebebeb"
            //                onPressed: {
            //                    positionBtn.btnColorDefault = "#ebebeb"
            //                    positionBtn.btnColorMouseOver = "#ebebeb"
            //                    algoritmsBtn.btnColorDefault = "#adadad"
            //                    algoritmsBtn.btnColorMouseOver = "#cdcdcd"
            //                    manualControlBtn.btnColorDefault = "#adadad"
            //                    manualControlBtn.btnColorMouseOver = "#cdcdcd"
            //                    settingsBtn.btnColorDefault = "#adadad"
            //                    settingsBtn.btnColorMouseOver = "#cdcdcd"
            //                    pageRotorAlgoritmsView.visible = false
            //                    pageRotorManualControlView.visible = false
            //                    pageSettingsView.visible = false
            //                    //stackView.push(pageRotorLoaded, StackView.Immediate)
            //                    //pageView.setSource(Qt.resolvedUrl("pageRotor.qml"))
            //                    //pageRotorSetPosView.visible = true
            //                }
            //            }

            BtnNonVis {
                id: manualControlBtn
                x: 15
                y: 50
                width: 340
                height: 40
                text: "РУЧНОЕ УПРАВЛЕНИЕ"

                btnColorDefault: "#ebebeb"
                btnColorMouseOver: "#ebebeb"
                onPressed: {
                    manualControlBtn.btnColorDefault = "#ebebeb"
                    manualControlBtn.btnColorMouseOver = "#ebebeb"
                    settingsBtn.btnColorDefault = "#adadad"
                    settingsBtn.btnColorMouseOver = "#cdcdcd"
                    pageRotorManualControlView.visible = true
                    pageSettingsView.visible = false
                    //stackView.push(pageRotorLoaded, StackView.Immediate)
                    //pageView.setSource(Qt.resolvedUrl("pageRotor.qml"))
                    //pageRotorSetPosView.visible = false
                }
            }

            BtnNonVis {
                id: settingsBtn
                x: 370
                y: 50
                width: 180
                height: 40
                text: "НАСТРОЙКИ"
                onPressed: {
                    manualControlBtn.btnColorDefault = "#adadad"
                    manualControlBtn.btnColorMouseOver = "#cdcdcd"
                    settingsBtn.btnColorDefault = "#ebebeb"
                    settingsBtn.btnColorMouseOver = "#ebebeb"
                    pageRotorManualControlView.visible = false
                    pageSettingsView.visible = true
                    //stackView.push(pageRotorLoaded, StackView.Immediate)
                    //pageView.setSource(Qt.resolvedUrl("pageRotor.qml"))
                    //pageRotorSetPosView.visible = false
                }
            }

            Text {
                id: textConnect
                x: 1027
                width: 116
                height: 24
                color: "#e20606"
                text: qsTr("Отключено")
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 137
                font.pixelSize: 20

                Rectangle {
                    id: rectangle1
                    x: -22
                    y: 6
                    width: 14
                    height: 14
                    color: "#e20606"
                    radius: 7
                }
            }

            Text {
                id: textWork
                x: 835
                width: 137
                height: 27
                color: "#adadad"
                text: qsTr("Нет информации")
                anchors.right: parent.right
                anchors.rightMargin: 308
                anchors.top: parent.top
                anchors.topMargin: 7
                font.pixelSize: 20

                AnimatedImage {
                    id: animatedImage
                    x: -31
                    y: 2
                    width: 24
                    height: 24
                    source: "images/Gear_Animated.gif"
                    paused: true
                }
            }



            Text {
                id: appTextName
                width: 696
                height: 27
                color: "#adadad"
                text: qsTr("Приложение по управлению двигателями рентгеновского гониометра")
                anchors.top: parent.top
                anchors.topMargin: 7
                anchors.left: parent.left
                anchors.leftMargin: 20
                font.weight: Font.Normal
                font.capitalization: Font.MixedCase
                style: Text.Normal
                font.pixelSize: 20
            }
        }


        Rectangle {
            id: contentPage
            x: 240
            width: 1040
            color: "#00000000"
            radius: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 100
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 155


            //            StackView {
            //                id: stackView
            //                anchors.fill: parent
            //                initialItem: Qt.resolvedUrl("pageRotor.qml")
            //            }

            //            Loader {
            //                id: pageRotorSetPosView
            //                anchors.fill: parent
            //                source: Qt.resolvedUrl("pageRotorSetPos.qml")
            //                visible: false
            //            }

            Loader {
                id: pageRotorAlgoritmsView
                width: 1040
                anchors.fill: parent
                source: Qt.resolvedUrl("pageRotorAlgoritms.qml")
                visible: false
            }

            Loader {
                id: pageRotorManualControlView
                width: 1040
                anchors.fill: parent
                source: Qt.resolvedUrl("pageRotorManualControl.qml")
                visible: true
            }

            Loader {
                id: pageSettingsView
                x: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.bottomMargin: 0
                source: Qt.resolvedUrl("pageSettings.qml")
                visible: false
            }
        }

        Rectangle {
            id: lowerInfo
            x: 240
            y: 565
            width: 1040
            height: 155
            color: "#2f3136"
            radius: 10
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            Rectangle {
                id: lowerInfo1
                x: 0
                y: 0
                height: 20
                color: "#2f3136"
                radius: 0
                anchors.bottomMargin: 135
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Rectangle {
                id: lowerInfo2
                y: 107
                width: 20
                height: 48
                color: "#2f3136"
                radius: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Text {
                id: showPosition
                x: 25
                y: 15
                width: 750
                height: 40
                color: "#ababab"
                text: qsTr("Текущая позиция")

                Rectangle {
                    id: showPosPlace1
                    x: 0
                    y: 80
                    width: 165
                    height: 40
                    color: "#2f3136"
                    radius: 1

                    Text {
                        id: showPosInfo1
                        x: 8
                        y: 5
                        width: 150
                        height: 30
                        color: "#ebebeb"
                        text: "0"
                        font.pixelSize: 24
                    }

                    Text {
                        id: showPosText1
                        x: 0
                        y: -30
                        width: 165
                        height: 30
                        color: "#ababab"
                        text: qsTr("1 двигатель")
                        font.pixelSize: 20
                    }
                }

                Rectangle {
                    id: showPosPlace2
                    x: 215
                    y: 80
                    width: 165
                    height: 40
                    color: "#2f3136"
                    radius: 1

                    Text {
                        id: showPosText2
                        x: 0
                        y: -30
                        width: 165
                        height: 30
                        color: "#ababab"
                        text: qsTr("2 двигатель")
                        font.pixelSize: 20
                    }

                    Text {
                        id: showPosInfo2
                        x: 8
                        y: 5
                        width: 150
                        height: 30
                        color: "#ebebeb"
                        text: "0"
                        font.pixelSize: 24
                    }
                }

                Rectangle {
                    id: showPosPlace3
                    x: 430
                    y: 80
                    width: 165
                    height: 40
                    color: "#2f3136"
                    radius: 1

                    Text {
                        id: showPosText3
                        x: 0
                        y: -30
                        width: 165
                        height: 30
                        color: "#ababab"
                        text: qsTr("3 двигатель")
                        font.pixelSize: 20
                    }

                    Text {
                        id: showPosInfo3
                        x: 8
                        y: 5
                        width: 150
                        height: 30
                        color: "#ebebeb"
                        text: "0"
                        font.pixelSize: 24
                    }
                }

                Rectangle {
                    id: showPosPlace4
                    x: 645
                    y: 80
                    width: 165
                    height: 40
                    color: "#2f3136"
                    radius: 1

                    Text {
                        id: showPosText4
                        x: 0
                        y: -30
                        width: 165
                        height: 30
                        color: "#ababab"
                        text: qsTr("4 двигатель")
                        font.pixelSize: 20
                    }

                    Text {
                        id: showPosInfo4
                        x: 8
                        y: 5
                        width: 150
                        height: 30
                        color: "#ebebeb"
                        text: "0"
                        font.pixelSize: 24
                    }
                }
                font.bold: true
                font.capitalization: Font.MixedCase
                style: Text.Normal
                font.pixelSize: 24
                font.weight: Font.Normal
            }

            BorderImage {
                id: borderImage
                x: 836
                y: 25
                width: 154
                height: 120
                source: "images/Goniometr.png"

                Text {
                    id: textimage1
                    x: 12
                    y: -20
                    color: "#ababab"
                    text: qsTr("4")
                    font.pixelSize: 20
                }

                Text {
                    id: textimage2
                    x: 42
                    y: -20
                    color: "#ababab"
                    text: qsTr("2")
                    font.pixelSize: 20
                }

                Text {
                    id: textimage3
                    x: 112
                    y: -20
                    color: "#ababab"
                    text: qsTr("1")
                    font.pixelSize: 20
                }

                Text {
                    id: textimage4
                    x: 139
                    y: -20
                    color: "#ababab"
                    text: qsTr("3")
                    font.pixelSize: 20
                }
            }

        }

        Rectangle {
            id: rightLog
            color: "#2f3136"
            radius: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 1040
            anchors.top: parent.top
            anchors.topMargin: 100





            Rectangle {
                id: rectangle3
                width: 240
                color: "#2f3136"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 605
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            FontMetrics {
                id: fontMetricsLogs
                font: textAreaLogs.font
            }


            BtnNonVis {
                id: btnLogsAndList
                x: 0
                y: 0
                width: 240
                height: 50
                text: "Очередь команд"
                anchors.horizontalCenter: parent.horizontalCenter
                pixelTextSize: 24
                onPressed: {
                    if(logAndList == false){
                        btnLogsAndList.text = "События"
                        logAndList = true
                        flickableCommandList.visible = false
                        btnSaveCommand1.visible = false
                        btnLoadCommand2.visible = false
                        btnStartCommand3.visible = false
                        btnStopCommand4.visible = false
                        btnDeleteLastCommand5.visible = false
                        btnDeleteAllCommand6.visible = false
                        flickableLogs.visible = true
                        rectangleTopLogs.visible = true
                    }
                    else {
                        btnLogsAndList.text = "Очередь команд"
                        logAndList = false
                        flickableCommandList.visible = true
                        btnSaveCommand1.visible = true
                        btnLoadCommand2.visible = true
                        btnStartCommand3.visible = true
                        btnStopCommand4.visible = true
                        btnDeleteLastCommand5.visible = true
                        btnDeleteAllCommand6.visible = true
                        flickableLogs.visible = false
                        rectangleTopLogs.visible = false
                    }
                }

            }

            Rectangle {
                id: rectangle2
                y: 90
                height: 20
                color: "#232529"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                border.width: 0
            }

            FontMetrics {
                id: fontMetricsCommandList
                font: textAreaCommandList.font
            }


            Rectangle {
                id: rectangleTopLogs
                y: 50
                width: 240
                height: 20
                color: "#232529"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                visible: false
            }

            Rectangle {
                id: rectangle5
                x: 0
                color: "#232529"
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 90
            }


            Rectangle {
                id: rectangle4
                x: 224
                y: 568
                width: 15
                height: 52
                color: "#232529"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 1
            }



            Flickable {
                id: flickableCommandList
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 90
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds
                contentY: 0
                visible: true
                //Math.min(contentHeight, fontMetrics.height * 15)
                //contentWidth: 200
                //contentHeight: height
                clip: true
                //flickDeceleration: 10000

                TextArea.flickable: TextArea {
                    id: textAreaCommandList
                    textFormat: TextEdit.RichText
                    text: ""
                    wrapMode: Text.Wrap
                    rightPadding: 10
                    color: "#adadad"
                    font.pixelSize: 18
                    readOnly: true
                    selectByMouse: true
                    selectedTextColor: "#DCDCDC"
                    selectionColor: "#6495ed"

                    background: Rectangle {
                        color: "#232529"
                        radius: 10
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    snapMode: ScrollBar.SnapAlways
                    minimumSize: 0.05
                }
            }


            Flickable {
                id: flickableLogs
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 50
                boundsBehavior: Flickable.StopAtBounds
                boundsMovement: Flickable.StopAtBounds
                contentY: 0
                visible: false
                //Math.min(contentHeight, fontMetrics.height * 15)
                //contentWidth: 200
                //contentHeight: height
                clip: true
                //flickDeceleration: 10000

                TextArea.flickable: TextArea {
                    id: textAreaLogs
                    text: ""
                    wrapMode: Text.Wrap
                    rightPadding: 10
                    color: "#adadad"
                    font.pixelSize: 18
                    readOnly: true
                    selectByMouse: true
                    selectedTextColor: "#DCDCDC"
                    selectionColor: "#6495ed"

                    background: Rectangle {
                        color: "#232529"
                        radius: 10
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                    snapMode: ScrollBar.SnapAlways
                    minimumSize: 0.05
                }
            }


            BtnToggle {
                id: btnSaveCommand1
                x: 0
                y: 50
                width: 40
                height: 40
                btnColorClicked: "#2f3136"
                btnColorMouseOver: "#23272e"
                btnColorDefault: "#2f3136"
                btnIconSource: "images/save.png"
                visible: true
                onClicked:
                {
                    loadFlag = false
                    fileDialog.open()
                }
            }

            BtnToggle {
                id: btnLoadCommand2
                x: 40
                y: 50
                width: 40
                height: 40
                btnColorClicked: "#2f3136"
                btnColorMouseOver: "#23272e"
                btnColorDefault: "#2f3136"
                btnIconSource: "images/load.png"
                visible: true
                onClicked: {
                    loadFlag = true
                    fileDialog.open()
                }

            }


            BtnToggle {
                id: btnStartCommand3
                x: 80
                y: 50
                width: 40
                height: 40
                btnColorClicked: "#2f3136"
                btnColorDefault: "#2f3136"
                overlayColor: "#59ae62"
                btnIconSource: "images/start.png"
                visible: true
                onClicked:
                {
                    btnStartCommand3.btnColorDefault = "#4E5766"
                    btnStartCommand3.btnColorMouseOver = "#4E5766"
                    btnStopCommand4.btnColorDefault = "#2f3136"
                    btnStopCommand4.btnColorMouseOver = "#23272E"
                    motorQML.btnStartCommandList(true)
                }
            }

            BtnToggle {
                id: btnStopCommand4
                x: 120
                y: 50
                width: 40
                height: 40
                btnColorClicked: "#4E5766"
                btnColorDefault: "#4E5766"
                btnColorMouseOver: "#4E5766"
                overlayColor: "#d24a43"
                btnIconSource: "images/stop.png"
                visible: true
                onClicked: {
                    btnStopCommand4.btnColorDefault = "#4E5766"
                    btnStopCommand4.btnColorMouseOver = "#4E5766"
                    btnStartCommand3.btnColorDefault = "#2f3136"
                    btnStartCommand3.btnColorMouseOver = "#23272E"
                    motorQML.btnStartCommandList(false)
                }
            }

            BtnImageDynamic {
                id: btnDeleteLastCommand5
                x: 160
                y: 50
                btnColorDefault: "#2f3136"
                btnColorClicked: "#2f3136"
                btnIconSource: "images/deleteLast.png"
                visible: true
                onClicked: motorQML.btnRemoveLastCommand()
            }

            BtnToggle {
                id: btnDeleteAllCommand6
                x: 200
                y: 50
                width: 40
                height: 40
                btnColorMouseOver: "#23272e"
                btnColorClicked: "#2f3136"
                btnColorDefault: "#2f3136"
                overlayColor: "#d24a43"
                btnIconSource: "images/delete.png"
                visible: true
                onClicked: motorQML.btnDeleteAllCommands()
            }

        }
    }
}



















































































/*##^## Designer {
    D{i:1;anchors_height:200;anchors_width:200;anchors_x:0;anchors_y:0}D{i:2;anchors_height:480;anchors_width:640;anchors_x:0;anchors_y:0}
D{i:3;anchors_y:10}D{i:5;anchors_x:10;anchors_y:0}D{i:6;anchors_width:1260;anchors_x:10}
D{i:7;anchors_height:670;anchors_y:40}D{i:8;anchors_height:700;anchors_x:0;anchors_y:10}
D{i:14;anchors_width:137;anchors_x:828;anchors_y:7}D{i:15;anchors_width:137;anchors_x:828;anchors_y:7}
D{i:16;anchors_height:480;anchors_width:40;anchors_x:1201;anchors_y:0}D{i:17;anchors_height:480;anchors_width:40;anchors_x:1201;anchors_y:0}
D{i:18;anchors_height:480;anchors_width:40;anchors_x:1201;anchors_y:0}D{i:20;anchors_width:39;anchors_x:1241;anchors_y:0}
D{i:22;anchors_width:39;anchors_x:1241;anchors_y:0}D{i:26;anchors_width:1040;anchors_x:1241;anchors_y:0}
D{i:27;anchors_width:1040;anchors_x:1241;anchors_y:0}D{i:28;anchors_height:155;anchors_width:1040;anchors_y:610}
D{i:25;anchors_width:1040;anchors_x:1241;anchors_y:0}D{i:30;anchors_height:155;anchors_width:1040;anchors_x:0;anchors_y:610}
D{i:31;anchors_height:155;anchors_width:1040;anchors_x:0;anchors_y:610}D{i:33;anchors_x:0}
D{i:32;anchors_x:0}D{i:29;anchors_height:155;anchors_width:1040;anchors_y:610}D{i:53;anchors_width:240;anchors_x:0}
D{i:54;anchors_width:240;anchors_x:0}D{i:55;anchors_x:0}D{i:56;anchors_x:0}D{i:4;anchors_y:0}
}
 ##^##*/
