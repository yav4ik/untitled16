#include "stepmotor.h"

stepmotor::stepmotor()
{
    loadParams();
    QList<QVariant> Fifo;
    QList<QString> commandShowList;
    QList<QString> commandActive;
    connectStatus = -1;
    checkConnect = new QTimer(this);
}

void stepmotor::setFilePath(QString path)
{
    filePath = path;
}

QString stepmotor::getFilePath()
{
    return filePath;
}

void stepmotor::setConnectParams(QHostAddress srcIP, QHostAddress dstIP,
                                 uint16_t srcPort, uint16_t dstPort){
    m_srcIP = srcIP;
    m_dstIP = dstIP;
    m_srcPort = srcPort;
    m_dstPort = dstPort;
}

// Функция для подключения к плате с проверкой 2,5 секунд состояния подключения
void stepmotor::initialization(QHostAddress srcIP, QHostAddress dstIP,
                              uint16_t srcPort, uint16_t dstPort)
{
    setConnectParams(srcIP, dstIP, srcPort, dstPort);
    if(!checkConnect->isActive()){
        checkConnect->start(2500);
        connect(checkConnect, SIGNAL(timeout()), this, SLOT(initialization()));
    }
}

// Функция по подключению к плате
int stepmotor::initialization()
{
    //если уже установлено подключение
    if(connectStatus == 0){
        return 0;
    }

    if(!p_Client) p_Client = new QTcpSocket(this);
    else{
        p_Client->close();
        delete  p_Client;
        p_Client = new QTcpSocket(this);
    }

    if(p_Client->bind(m_srcIP, m_srcPort)){
        listTimer = new QTimer(this);
        p_Client->connectToHost(m_dstIP, m_dstPort);
        if(p_Client->waitForConnected(2000)){
            connect(p_Client, SIGNAL(readyRead()), this, SLOT(onClientReadyRead()));
            connect(p_Client, SIGNAL(disconnected()), this, SLOT(disconnectSocket()));

            //связь 200 мс таймера с командой для получения позиции
            connect(listTimer, SIGNAL(timeout()), this, SLOT(checkPos()));
            listTimer->start(200);
            onConnected(true);
            connectStatus = 0;
            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") + " Succsess connection\n"
                    + "    from " + m_srcIP.toString() + ":" + QString::number(m_srcPort) + " to "
                    + m_dstIP.toString() + ":" + QString::number(m_dstPort);

            messageToQML(message);
            qDebug().noquote().nospace() << message;
            return 0;
        }
        else {
            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss")
                                 + " Connection Error\n" + "    Error with device or destination adress "
                                 + m_dstIP.toString() +":" + QString::number(m_dstPort) + "\n    retry";

            messageToQML(message);
            qDebug().noquote().nospace() << message;

            connectStatus = -1;
            onConnected(false);
            return -1;
        }
    }
    else{
        QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss")
                + " Connection Error\n" + "    Error with " + m_srcIP.toString()
                + ":" + QString::number(m_srcPort) + "\n    retry";

        qDebug().noquote().nospace() << message;
        messageToQML(message);

        connectStatus = -1;
        onConnected(false);
        return -1;
    }
}

// Функция получает сигнал отключения связи и снова запускает инициализацию
void stepmotor::disconnectSocket()
{
    connectStatus = -1;
    onConnected(false);
    QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss")
                      + " disconnected";

    messageToQML(message);
    qDebug().noquote().nospace() << message;
    initialization(m_srcIP, m_dstIP, m_srcPort, m_dstPort);
}

// Функция по приему ответа драйвера
void stepmotor::onClientReadyRead()
{
    QByteArray data = p_Client->readAll();
    //qDebug() << "stepmotor::onClientReadyRead() " << data;
    unsigned short * p_nCmd = (unsigned short*)data.data();
    //qDebug() << *p_nCmd;

    switch (*p_nCmd) {
    case STATUS:
    {
        ManualAnswerStatus *ans_st = (ManualAnswerStatus *)data.data();
        //qDebug() << ans_st->position[0] << " " << ans_st->positionEnc[0] << " " << ans_st->state[0];
        //qDebug() << ans_st->position[1] << " " << ans_st->positionEnc[1] << " " << ans_st->state[1];
        //qDebug() << ans_st->position[2] << " " << ans_st->positionEnc[2] << " " << ans_st->state[2];
        //qDebug() << ans_st->position[2] << " " << ans_st->positionEnc[3] << " " << ans_st->state[3];
        comparePos(ans_st->position[0] * DegreeToNumbers[0], ans_st->position[1]  * DegreeToNumbers[1],
                ans_st->position[2]  * DegreeToNumbers[2], ans_st->position[3] * DegreeToNumbers[3]);

        if (ans_st->position[0] != 0) {
            position0 = (double)ans_st->position[0] / (double)DegreeToNumbers[0];
        }
        else {position0 = 0;}

        if (ans_st->position[1] != 0) {
            position1 = (double)ans_st->position[1] / (double)DegreeToNumbers[1];
        }
        else {position1 = 0;}

        if (ans_st->position[2] != 0) {
            position2 = (double)ans_st->position[2] / (double)DegreeToNumbers[2];
        }
        else {position2 = 0;}

        if (ans_st->position[3] != 0) {
            position3 = (double)ans_st->position[3] / (double)DegreeToNumbers[3];
        }
        else {position3 = 0;}

        // если координаты двигателей больше или меньше передельных углов
        if((ans_st->position[0] > maxAngles[0] || ans_st->position[0] < minAngles[0]) && minAngles[0] != 0)
            {stopMove();}
        if((ans_st->position[1] > maxAngles[1] || ans_st->position[1] < minAngles[1]) && minAngles[1] != 0)
            {stopMove();}
        if((ans_st->position[2] > maxAngles[2] || ans_st->position[2] < minAngles[2]) && minAngles[2] != 0)
            {stopMove();}
        if((ans_st->position[3] > maxAngles[3] || ans_st->position[3] < minAngles[3]) && minAngles[3] != 0)
            {stopMove();}

        onAnswerPos(-position0, -position1, -position2, -position3);
        break;
    }
    default:
        break;
    }

}

void stepmotor::checkPos()
{
    status();
}

// Функция по сравнению новой позиции с позицией прошлого ответа драйвера
// если позиции 5 раз совпали, то программа считает, что перемещение окончено
// и запускает функцию по запуску следуйщей команде в списке команд
void stepmotor::comparePos(signed long position0, signed long position1,
                           signed long position2, signed long position3)
{
    if (longPositonsCoord[0] == position0 && longPositonsCoord[1] == position1 &&
            longPositonsCoord[2] == position2 && longPositonsCoord[3] == position3)
    {
        if (nComparePos < 16) {
            nComparePos = nComparePos + 1;
            if(nComparePos > 5){
                allMoveIcon = false;
            }
        }
    }

    else {nComparePos = 0; allMoveIcon = true;}

    if (nComparePos > 3 && !Fifo.isEmpty() && connectStatus == 0){
        listFifo();
        onChangeCommandList();
        nComparePos = 0;
    }

    if(nComparePos > 3 && Fifo.isEmpty() && !activeCommand.isEmpty()) {
        activeCommand = "";
        onChangeCommandList();
    }

    unsigned short a = 2, b = 2, c = 2, d = 2;
    if (longPositonsCoord[0] == position0 && a < 3) {a++;}
    else {a = 0;}

    if (longPositonsCoord[1] == position1 && b < 3) {b++;}
    else {b = 0;}

    if (longPositonsCoord[2] == position2 && c < 3) {c++;}
    else {c = 0;}

    if (longPositonsCoord[3] == position3 && d < 3) {d++;}
    else {d = 0;}

    if(a > 1) {rotorMove[0] = false;}
    else {rotorMove[0] = true;}
    if(b > 1) {rotorMove[1] = false;}
    else {rotorMove[1] = true;}
    if(c > 1) {rotorMove[2] = false;}
    else {rotorMove[2] = true;}
    if(d > 1) {rotorMove[3] = false;}
    else {rotorMove[3] = true;}

    rotorRorartion();
    longPositonsCoord[0] = position0;
    longPositonsCoord[1] = position1;
    longPositonsCoord[2] = position2;
    longPositonsCoord[3] = position3;
}

// Команда начинает перемещение двигателей по заданным скоростям
void stepmotor::startMove(quint16 rotor1, quint16 rotor2, quint16 rotor3, quint16 rotor4,
                          bool inv1, bool inv2, bool inv3, bool inv4, bool fromSave)
{
    ManualStart start;
    if (rotor1) {start.axes.a1 = 1;} else {start.axes.a1 = 0;}
    if (rotor2) {start.axes.a2 = 1;} else {start.axes.a2 = 0;}
    if (rotor3) {start.axes.a3 = 1;} else {start.axes.a3 = 0;}
    if (rotor4) {start.axes.a4 = 1;} else {start.axes.a4 = 0;}

    if (rotor1 > maxSpeed) {rotor1 = maxSpeed;}
    if (rotor2 > maxSpeed) {rotor2 = maxSpeed;}
    if (rotor3 > maxSpeed) {rotor3 = maxSpeed;}
    if (rotor4 > maxSpeed) {rotor4 = maxSpeed;}

    start.speed[0] = rotor1;
    start.speed[1] = rotor2;
    start.speed[2] = rotor3;
    start.speed[3] = rotor4;

    if(!fromSave){
        start.acceleration[0] = acceleration[0];
        start.acceleration[1] = acceleration[1];
        start.acceleration[2] = acceleration[2];
        start.acceleration[3] = acceleration[3];
    }
    else {
        start.acceleration[0] = accelerationFromSave[0];
        start.acceleration[1] = accelerationFromSave[1];
        start.acceleration[2] = accelerationFromSave[2];
        start.acceleration[3] = accelerationFromSave[3];
    }

    start.dir[0] = inv1;
    start.dir[1] = inv2;
    start.dir[2] = inv3;
    start.dir[3] = inv4;

    QVariant listTo;
    listTo.setValue(start);

    QString message = "command: 2 (moveBySpeed)\n    Active rotors: "
            + QString::number(start.axes.a1) + " " + QString::number(start.axes.a2) + " "
            + QString::number(start.axes.a3) + " " + QString::number(start.axes.a4) + " \n"
            + "    Speed: "
            + QString::number(start.speed[0]) + " " + QString::number(start.speed[1]) + " "
            + QString::number(start.speed[2]) + " " + QString::number(start.speed[3]) + " \n"
            + "    Acceleration: "
            + QString::number(start.acceleration[0]) + " " + QString::number(start.acceleration[1]) + " "
            + QString::number(start.acceleration[2]) + " " + QString::number(start.acceleration[3]) + " \n"
            + "    Inversion: "
            + QString::number(start.dir[0]) + " "  + QString::number(start.dir[1]) + " "
            + QString::number(start.dir[2]) + " "  + QString::number(start.dir[3]) + " \n";

    commandShowList.append(message);
    onChangeCommandList();
    Fifo.append(listTo);
}

// Команда стоп + очистка листа команд
void stepmotor::stopMove()
{

    ManualStop stop;
    stop.axes.a1 = 1;
    stop.axes.a2 = 1;
    stop.axes.a3 = 1;
    stop.axes.a4 = 1;

    stop.stopMode[0] = 0;
    stop.stopMode[1] = 0;
    stop.stopMode[2] = 0;
    stop.stopMode[3] = 0;

    QByteArray temp;
    temp.insert(0, (const char*) &stop, sizeof(stop));
    p_Client->write(temp);

    QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss")
            + " Sended command: 3 (stop)\n" + "  Command list clear";

    qDebug().noquote().nospace() << message;
    messageToQML(message);
}


void stepmotor::moveThrough(qint32 rotor1, qint32 rotor2, qint32 rotor3, qint32 rotor4, bool fromSave)
{
    goOn move;
    if (rotor1) {move.axes.a1 = 1;} else {move.axes.a1 = 0;}
    if (rotor2) {move.axes.a2 = 1;} else {move.axes.a2 = 0;}
    if (rotor3) {move.axes.a3 = 1;} else {move.axes.a3 = 0;}
    if (rotor4) {move.axes.a4 = 1;} else {move.axes.a4 = 0;}

    if(!fromSave){
        for(int j = 0; j < N; j++){
            move.speed[j] = speed[j];
            move.acceleration[j] = acceleration[j];
        }
    }
    else {
        for(int j = 0; j < N; j++){
            move.speed[j] = speedFromSave[j];
            move.acceleration[j] = accelerationFromSave[0];
        }
    }

    move.dist[0] = -rotor1;
    move.dist[1] = -rotor2;
    move.dist[2] = -rotor3;
    move.dist[3] = -rotor4;

    //double drotor1 = double(rotor1) * double(DegreeToNumbers[0]);
    //double drotor2 = double(rotor1) * double(DegreeToNumbers[1]);
    //double drotor3 = double(rotor2) * double(DegreeToNumbers[2]);
    //double drotor4 = double(rotor3) * double(DegreeToNumbers[3]);

    //qDebug() << drotor4;

    QVariant listTo;
    listTo.setValue(move);

    QString message = "command: 4 (moveThough)\n    Active rotors: "
            + QString::number(move.axes.a1) + " " + QString::number(move.axes.a2) + " "
            + QString::number(move.axes.a3) + " " + QString::number(move.axes.a4) + " \n"
            + "    Speed: "
            + QString::number(move.speed[0]) + " " + QString::number(move.speed[1]) + " "
            + QString::number(move.speed[2]) + " " + QString::number(move.speed[3]) + " \n"
            + "    Acceleration: "
            + QString::number(move.acceleration[0]) + " " + QString::number(move.acceleration[1]) + " "
            + QString::number(move.acceleration[2]) + " " + QString::number(move.acceleration[3]) + " \n"
            + "    Distance: "
            + QString::number(rotor1) + " "  + QString::number(rotor2) + " "
            + QString::number(rotor3) + " "  + QString::number(rotor4) + " \n";

    commandShowList.append(message);
    onChangeCommandList();
    Fifo.append(listTo);
}


void stepmotor::goTo(qint32 rotor1, qint32 rotor2, qint32 rotor3, qint32 rotor4, bool fromSave )
{
    ManualGoto go;
    //go.axes = setAxesMask(2);
    if (rotor1) {go.axes.a1 = 1;} else {go.axes.a1 = 0;}
    if (rotor2) {go.axes.a2 = 1;} else {go.axes.a2 = 0;}
    if (rotor3) {go.axes.a3 = 1;} else {go.axes.a3 = 0;}
    if (rotor4) {go.axes.a4 = 1;} else {go.axes.a4 = 0;}

    if(!fromSave){
        for(int j = 0; j < N; j++){
            go.speed[j] = speed[j];
            go.acceleration[j] = acceleration[j];
        }
    }
    else {
        for(int j = 0; j < N; j++){
            go.speed[j] = speedFromSave[j];
            go.acceleration[j] = accelerationFromSave[0];
        }
    }

    go.position[0] = -rotor1;
    go.position[1] = -rotor2;
    go.position[2] = -rotor3;
    go.position[3] = -rotor4;

//    double drotor1 = rotor1 * DegreeToNumbers[0];
//    double drotor2 = rotor1 * DegreeToNumbers[1];
//    double drotor3 = rotor2 * DegreeToNumbers[2];
//    double drotor4 = rotor3 * DegreeToNumbers[3];

    QVariant listTo;
    listTo.setValue(go);

    QString message = "command: 5 (moveToDest)\n    Active rotors: "
            + QString::number(go.axes.a1) + " " + QString::number(go.axes.a2) + " "
            + QString::number(go.axes.a3) + " " + QString::number(go.axes.a4) + " \n"
            + "    Speed: "
            + QString::number(go.speed[0]) + " " + QString::number(go.speed[1]) + " "
            + QString::number(go.speed[2]) + " " + QString::number(go.speed[3]) + " \n"
            + "    Acceleration: "
            + QString::number(go.acceleration[0]) + " " + QString::number(go.acceleration[1]) + " "
            + QString::number(go.acceleration[2]) + " " + QString::number(go.acceleration[3]) + " \n"
            + "    Position: "
            + QString::number(rotor1) + " "  + QString::number(rotor2) + " "
            + QString::number(rotor3) + " "  + QString::number(rotor4) + " \n";

    commandShowList.append(message);
    onChangeCommandList();
    Fifo.append(listTo);
}



void stepmotor::status()
{
    ManualStatus st;

    QByteArray temp;
    temp.insert(0, (const char*) &st, sizeof(st));
    p_Client->write(temp);
//    qDebug().noquote().nospace() << QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss")
//                                 << " Sended command: 6 (status)";
}

void stepmotor::setPosition(qint32 rotor1, qint32 rotor2,
                            qint32 rotor3, qint32 rotor4)
{
    // ???
    ManualSetPos pos;
    if (rotor1) {pos.axes.a1 = 1;} else {pos.axes.a1 = 0;}
    if (rotor2) {pos.axes.a2 = 1;} else {pos.axes.a2 = 0;}
    if (rotor3) {pos.axes.a3 = 1;} else {pos.axes.a3 = 0;}
    if (rotor4) {pos.axes.a4 = 1;} else {pos.axes.a4 = 0;}
    pos.position[0] = -rotor1;
    pos.position[1] = -rotor2;
    pos.position[2] = -rotor3;
    pos.position[3] = -rotor4;
    pos.positionEnc[0] = -rotor1;
    pos.positionEnc[1] = -rotor2;
    pos.positionEnc[2] = -rotor3;
    pos.positionEnc[3] = -rotor4;

    QVariant listTo;
    listTo.setValue(pos);

    QString message = "command: 7 (setPosition)\n    Active rotors: "
            + QString::number(pos.axes.a1) + " " + QString::number(pos.axes.a2) + " "
            + QString::number(pos.axes.a3) + " " + QString::number(pos.axes.a4) + " \n"
            + "    Position: "
            + QString::number(pos.position[0]) + " " + QString::number(pos.position[1]) + " "
            + QString::number(pos.position[2]) + " " + QString::number(pos.position[3]) + " \n"
            + "    Encoder position: "
            + QString::number(pos.positionEnc[0]) + " " + QString::number(pos.positionEnc[1]) + " "
            + QString::number(pos.positionEnc[2]) + " " + QString::number(pos.positionEnc[3]) + " \n";

    commandShowList.append(message);
    onChangeCommandList();
    Fifo.append(listTo);
}

void stepmotor::setParam(unsigned long paramValue1, unsigned long paramValue2,
                         unsigned long paramValue3, unsigned long paramValue4,
                         unsigned short paramID1, unsigned short paramID2,
                         unsigned short paramID3, unsigned short paramID4)
{
    // ???0xFFFFFFF
    ManualSetParam param;

    param.paramId[0] = paramID1;
    param.paramId[1] = paramID2;
    param.paramId[2] = paramID3;
    param.paramId[3] = paramID4;

    if (paramValue1) {
        param.axes.a1 = 1;
        param.paramValue[0] = paramValue1;
    }
    else {
        param.axes.a1 = 0;
        param.paramValue[0] = 0xFFFFFFF;
    }
    if (paramValue2) {
        param.axes.a2 = 1;
        param.paramValue[1] = paramValue2;
    }
    else {
        param.axes.a2 = 0;
        param.paramValue[1] = 0xFFFFFFF;
    }
    if (paramValue3) {
        param.axes.a3 = 1;
        param.paramValue[2] = paramValue3;
    }
    else {
        param.axes.a3 = 0;
        param.paramValue[2] = 0xFFFFFFF;
    }
    if (paramValue4) {
        param.axes.a4 = 1;
        param.paramValue[3] = paramValue4;
    }
    else {
        param.axes.a4 = 0;
        param.paramValue[3] = 0xFFFFFFF;
    }

    QVariant listTo;
    listTo.setValue(param);

    QString message = "command: 9 (SetParam)\n    Active rotors: "
            + QString::number(param.axes.a1) + " " + QString::number(param.axes.a2) + " "
            + QString::number(param.axes.a3) + " " + QString::number(param.axes.a4) + " \n"
            + "    Parametr Id: "
            + QString::number(param.paramId[0]) + " " + QString::number(param.paramId[1]) + " "
            + QString::number(param.paramId[2]) + " " + QString::number(param.paramId[3]) + " \n"
            + "    Parametr value: "
            + QString::number(param.paramValue[0]) + " " + QString::number(param.paramValue[1]) + " "
            + QString::number(param.paramValue[2]) + " " + QString::number(param.paramValue[3]) + " \n";

    commandShowList.append(message);
    onChangeCommandList();
    Fifo.append(listTo);
}

// функция которая вызывается после отправки команды из очереди
void stepmotor::actionsFifoFirstRemove(QString message)
{
    activeCommand = commandShowList[0];
    qDebug().noquote().nospace() << message;
    messageToQML(message);
    Fifo.removeFirst();
    commandShowList.removeFirst();
    onChangeCommandList();
}

// функция по получению данных из файла сохранения или настроек (в стринг)
QString stepmotor::getNumberFromCommandList(QString command, QString firsWords, QString lastWords = "")
{
    QStringList text;
    bool checkVoid = true;
    QString result = "";
    int indexOfVoid = 0;
    int lastIndex = 0;
    int firstIndex = command.lastIndexOf(firsWords);

    if(lastWords == ""){
        lastIndex = (command.size()) - 1 - firstIndex - firsWords.size();
    }
    else{
        lastIndex = (command.lastIndexOf(lastWords) - 1) - firstIndex - firsWords.size();
    }
    text = command.mid(firstIndex + firsWords.size(), lastIndex).split(QRegExp(" "), QString::SkipEmptyParts);

    while (checkVoid) {
        checkVoid = false;
        for(int j = 0; j < text.size(); j++)
            if(text[j] == ""){
                indexOfVoid = j;
                checkVoid = true;
            }
        if(checkVoid == true){
            text.removeAt(indexOfVoid);
        }

    }

    for(int j = 0; j < text.size(); j++){
        if(j != text.size() - 1) {result += text[j] + " ";}
        else {result += text[j];}
    }
    return result;
}

// функция по созданию очереди команд из файла сохраниния
void stepmotor::listFifoFromCommandList()
{
    if(!commandShowListFromSave.isEmpty()){
        for(int i = 0; i < commandShowListFromSave.size(); i++){
            QString textCommand;
            QStringList textCommandList1;
            QStringList textCommandList2;
            QStringList textCommandList3;
            QStringList textCommandList4;
            int comNum = commandShowListFromSave[i].mid(9, 1).toInt();
            QRegExp separator("[( |\n)]");

            switch (comNum) {
                case 2:
                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Speed:");
                    textCommandList1 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Acceleration:");
                    textCommandList2 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Inversion:");
                    textCommandList3 = textCommand.split(separator, QString::SkipEmptyParts);

                    for(int j = 0; j < 4; j++){
                        accelerationFromSave[j] = textCommandList2[j].toUShort();
                    }

                    startMove(textCommandList1[0].toUShort(), textCommandList1[1].toUShort(),
                              textCommandList1[2].toUShort(), textCommandList1[3].toUShort(),
                              QVariant(textCommandList3[0]).toBool(), QVariant(textCommandList3[1]).toBool(),
                              QVariant(textCommandList3[2]).toBool(), QVariant(textCommandList3[3]).toBool());
                    break;

                case 4:
                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Speed:");
                    textCommandList1 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Acceleration:");
                    textCommandList2 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Distance:");
                    textCommandList3 = textCommand.split(separator, QString::SkipEmptyParts);

                    for(int j = 0; j < 4; j++){
                        speedFromSave[j] = textCommandList1[j].toUShort();
                        accelerationFromSave[j] = textCommandList2[j].toUShort();
                    }

                    moveThrough(textCommandList3[0].toInt(), textCommandList3[1].toInt(),
                                textCommandList3[2].toInt(), textCommandList3[3].toInt());
                    break;

                case 5:
                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Speed:");
                    textCommandList1 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Acceleration:");
                    textCommandList2 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Position:");
                    textCommandList3 = textCommand.split(separator, QString::SkipEmptyParts);

                    for(int j = 0; j < 4; j++){
                        speedFromSave[j] = textCommandList1[j].toUShort();
                        accelerationFromSave[j] = textCommandList2[j].toUShort();
                    }

                    goTo(textCommandList3[0].toInt(), textCommandList3[1].toInt(),
                         textCommandList3[2].toInt(), textCommandList3[3].toInt());
                    break;

                case 7:
                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Speed:");
                    textCommandList1 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Position:");
                    textCommandList2 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Position:");
                    textCommandList3 = textCommand.split(separator, QString::SkipEmptyParts);

                    setPosition(textCommandList3[0].toInt(), textCommandList3[1].toInt(),
                                textCommandList3[2].toInt(), textCommandList3[3].toInt());
                    break;

                case 9:
                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Parametr Id:");
                    textCommandList1 = textCommand.split(separator, QString::SkipEmptyParts);

                    textCommand = getNumberFromCommandList(commandShowListFromSave[i], "Parametr value:");
                    textCommandList2 = textCommand.split(separator, QString::SkipEmptyParts);

                    setParam(textCommandList2[0].toULong(), textCommandList2[1].toULong(),
                             textCommandList2[2].toULong(), textCommandList2[3].toULong(),
                             textCommandList1[0].toUShort(), textCommandList1[1].toUShort(),
                             textCommandList1[2].toUShort(), textCommandList1[3].toUShort());
                    break;

            }
        }
    }
}

// Отсылает команду из листа команд в драйвер, удаляя в листе отправленную команду
// Тут описаны почти все команды, но в предыдущих функциях в лист записываются только команды
// по смене позиций (goTo, goThrough)
void stepmotor::listFifo()
{
    if (!Fifo.isEmpty())
    {
        if (Fifo.first().canConvert<ManualStart>()) {
            qDebug() << "ManualStart";
            ManualStart convert = Fifo.first().value<ManualStart>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                        + " Sended " + commandShowList[0];

            actionsFifoFirstRemove(message);
            return;
        }

        if (Fifo.first().canConvert<ManualStop>()) {
            qDebug() << "ManualStop";
            ManualStop convert = Fifo.first().value<ManualStop>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " Sended " + commandShowList[0];

            Fifo.removeFirst();
            commandShowList.removeFirst();
            return;
        }

        if (Fifo.first().canConvert<goOn>()) {
            qDebug() << "goOn";
            goOn convert = Fifo.first().value<goOn>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " Sended " + commandShowList[0];

            actionsFifoFirstRemove(message);
            return;
        }

        if (Fifo.first().canConvert<ManualGoto>()) {
            qDebug() << "ManualGoto";
            ManualGoto convert = Fifo.first().value<ManualGoto>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " Sended " + commandShowList[0];

            actionsFifoFirstRemove(message);
            return;
        }

//        if (Fifo.first().canConvert<ManualAnswerStatus>()) {
//            qDebug() << "ManualAnswerStatus";
//            ManualAnswerStatus convert = Fifo.first().value<ManualAnswerStatus>();
//            QByteArray temp;
//            temp.insert(0, (const char*) &convert, sizeof(convert));
//            p_Client->write(temp);

//            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
//                    + " Sended " + commandShowList[0];

//            return;
//        }

        if (Fifo.first().canConvert<ManualSetPos>()) {
            qDebug() << "ManualSetPos";
            ManualSetPos convert = Fifo.first().value<ManualSetPos>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " Sended " + commandShowList[0];

            actionsFifoFirstRemove(message);
            return;
        }

//        if (Fifo.first().canConvert<Emergency>()) {
//            qDebug() << "Emergency";
//            Emergency convert = Fifo.first().value<Emergency>();
//            QByteArray temp;
//            temp.insert(0, (const char*) &convert, sizeof(convert));
//            p_Client->write(temp);

//            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
//                    + " Sended " + commandShowList[0];

//            Fifo.removeFirst();
//            commandShowList.removeFirst();
//            return;
//        }

        if (Fifo.first().canConvert<ManualSetParam>()) {
            qDebug() << "ManualSetParam";
            ManualSetParam convert = Fifo.first().value<ManualSetParam>();
            QByteArray temp;
            temp.insert(0, (const char*) &convert, sizeof(convert));
            p_Client->write(temp);


            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " Sended " + commandShowList[0];

            actionsFifoFirstRemove(message);
            return;
        }
    }

    if(Fifo.isEmpty()) {
        activeCommand = "";
        onChangeCommandList();
    }

}

// загрузка настроек программы из текстового документа в корне программы
void stepmotor::loadParams()
{
    bool makeSave = false;
    QStringList textlistSpeed, textlistAcceleration, textlistCoefficient, textlistPath, textlistSourceIP, textlistDestIP;
    QString dirPath = qApp->applicationDirPath()  + "SETTINGS.txt";
    readTxt *readTxt = new class readTxt;
    QString text = readTxt->loadTxtFile(dirPath);
    QRegExp separator("[( |\n)]"), separator1("[( |:|\n)]");
    delete readTxt;
    textlistSpeed = getNumberFromCommandList(text, "Rorots speed:").split(separator, QString::SkipEmptyParts);
    textlistAcceleration = getNumberFromCommandList(text, "Rorots acceleration:").split(separator, QString::SkipEmptyParts);
    textlistCoefficient = getNumberFromCommandList(text, "Rorots degree convert coefficient:").split(separator, QString::SkipEmptyParts);
    textlistPath = getNumberFromCommandList(text, "Path for File Dialog:").split(separator, QString::SkipEmptyParts);
    textlistSourceIP = getNumberFromCommandList(text, "Source adress:").split(separator1, QString::SkipEmptyParts);
    textlistDestIP = getNumberFromCommandList(text, "Destination adress:").split(separator1, QString::SkipEmptyParts);
    for(int j = 0; j < N; j++){
        if(!textlistSpeed.isEmpty()){speed[j] = textlistSpeed[j].toUShort();}
        else {makeSave = true;}
        if(!textlistAcceleration.isEmpty()){acceleration[j] = textlistAcceleration[j].toUShort();}
        else {makeSave = true;}
        if(!textlistCoefficient.isEmpty()){DegreeToNumbers[j] = textlistCoefficient[j].toUShort();}
        else {makeSave = true;}
    }
    if(!textlistPath.isEmpty()){filePath = textlistPath[0];}
    else {makeSave = true;}

    if(textlistSourceIP.size() > 1){
       m_dstIP = QHostAddress(textlistSourceIP[0]);
       m_dstPort = textlistSourceIP[1].toUShort();
    }
    else {makeSave = true;}

    if(textlistDestIP.size() > 1){
        m_srcIP = QHostAddress(textlistDestIP[0]);
        m_srcPort = textlistDestIP[1].toUShort();
    }
    else {makeSave = true;}

    if(makeSave){saveParams();}

}

// сохранение настроек программы из текстового документа в корне программы
void stepmotor::saveParams()
{
    QString dirPath = qApp->applicationDirPath()  + "SETTINGS.txt";
    QString rotorsSpeed = "", rotorsAccel = "", DegreToNumb = "", rotorsMinAngles = "", rotorsMaxAngles = "";
    for(int j = 0; j < N; j++){
        rotorsSpeed += QString::number(speed[j]) + " ";
        rotorsAccel += QString::number(acceleration[j]) + " ";
        DegreToNumb += QString::number(DegreeToNumbers[j]) + " ";
        rotorsMinAngles += QString::number(minAngles[j]) + " ";
        rotorsMaxAngles += QString::number(maxAngles[j]) + " ";
    }

    QString save = "";
    save = + "Destination adress: " + m_dstIP.toString() + ":" + QString::number(m_dstPort) + "\n"
           + "Source adress: " + m_srcIP.toString() + ":" + QString::number(m_srcPort) + "\n\n"
           + "Rorots speed: " + rotorsSpeed + "\n"
           + "Rorots acceleration: " + rotorsAccel + "\n"
           + "Rorots degree convert coefficient: " + DegreToNumb + "\n"
           + "Minimum angles: " + rotorsMinAngles + "\n"
           + "Maximum angles: " + rotorsMaxAngles + "\n"
           + "Path for File Dialog: " + filePath;

    readTxt *readTxt = new class readTxt;
    readTxt->saveTxtFile(save, dirPath);
    delete readTxt;
}

void stepmotor::changeRotorParams(qint32 param1, qint32 param2,
                                  qint32 param3, qint32 param4,
                                  qint32 index)
{
    switch (index) {
        case 1:{
            DegreeToNumbers[0] = (unsigned short)param1;
            DegreeToNumbers[1] = (unsigned short)param2;
            DegreeToNumbers[2] = (unsigned short)param3;
            DegreeToNumbers[3] = (unsigned short)param4;
            saveParams();
            break;
        }

        case 2:{
            minAngles[0] = param1;
            minAngles[1] = param2;
            minAngles[2] = param3;
            minAngles[3] = param4;
            saveParams();
            break;
        }

        case 3:{
            maxAngles[0] = param1;
            maxAngles[1] = param2;
            maxAngles[2] = param3;
            maxAngles[3] = param4;
            saveParams();
            break;
        }

        case 4:{
            acceleration[0] = (unsigned short)param1;
            acceleration[1] = (unsigned short)param2;
            acceleration[2] = (unsigned short)param3;
            acceleration[3] = (unsigned short)param4;
            saveParams();
            break;
        }

        case 5:{
            speed[0] = (unsigned short)param1;
            speed[1] = (unsigned short)param2;
            speed[2] = (unsigned short)param3;
            speed[3] = (unsigned short)param4;
            saveParams();
            break;
        }
    }
}
