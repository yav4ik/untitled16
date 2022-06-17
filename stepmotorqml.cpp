#include "stepmotorqml.h"
#include <QDebug>

stepMotorQML::stepMotorQML(QObject *parent) : QObject(parent)
{
    QString messageAll = "";
}

// Запуск соеденений
void stepMotorQML::btnConnect()
{
    // для статуса подключения на интерфейс
    connect(&stepMotor, SIGNAL(onConnected(bool)), this, SLOT(connectedStatus(bool)));

    stepMotor.initialization(QHostAddress("192.168.10.1"), QHostAddress("192.168.10.11"), 50005, 50032);

    // для отображения позиций на интерфейсе
    connect(&stepMotor, SIGNAL(onAnswerPos(double, double,double, double)),
            this, SLOT(positionToString(double, double, double, double)));

    // для статуса движений (кручений) двигателей
    connect(&stepMotor, SIGNAL(rotorRorartion()), this, SLOT(rotorStatus()));

    // для вывода сообщений на графический интерфейс
    connect(&stepMotor, SIGNAL(messageToQML(QString)), this, SLOT(messageTo(QString)));

    // для вывода списка комманд на графический интерфейс
    connect(&stepMotor, SIGNAL(onChangeCommandList()), this, SLOT(commandListTo()));
}


// Преобразует тип данных позиций в стринг и отображает их
void stepMotorQML::positionToString(double pos1, double pos2, double pos3, double pos4)
{
    QString pos11, pos12, pos13, pos14;
    double n = 0;
    n = pos1 / 360;
    if(pos1 >= 0){pos1 = pos1 - 360 * trunc(n);} else {pos1 = 360 - abs(pos1 - 360 * trunc(n));}
    n = pos2 / 360;
    if(pos2 >= 0){pos2 = pos2 - 360 * trunc(n);} else {pos2 = 360 - abs(pos2 - 360 * trunc(n));}
    n = pos3 / 360;
    if(pos3 >= 0){pos3 = pos3 - 360 * trunc(n);} else {pos3 = 360 - abs(pos3 - 360 * trunc(n));}
    n = pos4 / 360;
    if(pos4 >= 0){pos4 = pos4 - 360 * trunc(n);} else {pos4 = 360 - abs(pos4 - 360 * trunc(n));}

    pos11 = QString::number(pos1, 'f', 3);
    pos12 = QString::number(pos2, 'f', 3);
    pos13 = QString::number(pos3, 'f', 3);
    pos14 = QString::number(pos4, 'f', 3);

//    qDebug() << pos11;
//    qDebug() << pos12;
//    qDebug() << pos13;
//    qDebug() << pos14;
    positionToLabelText(pos11, pos12, pos13, pos14);
}

// Кнопки связаныне с позицией (Установить, Переместить к, Перпеместить на)
void stepMotorQML::getRotorValue(QString rotor1, QString rotor2, QString rotor3, QString rotor4, qint32 code)
{
    qint32 rotor11, rotor12, rotor13, rotor14;
    unsigned long rotor21, rotor22, rotor23, rotor24;
    unsigned short rotor31, rotor32, rotor33, rotor34;
    short rotor41, rotor42, rotor43, rotor44;
    double drotor1, drotor2, drotor3, drotor4;
    bool inv1 = false, inv2 = false, inv3 = false, inv4 = false;

    drotor1 = rotor1.toDouble() * (double)stepMotor.DegreeToNumbers[0];
    drotor2 = rotor2.toDouble() * (double)stepMotor.DegreeToNumbers[1];
    drotor3 = rotor3.toDouble() * (double)stepMotor.DegreeToNumbers[2];
    drotor4 = rotor4.toDouble() * (double)stepMotor.DegreeToNumbers[3];

    switch (code) {
        case 2:{
            if (drotor1 <= 0) {inv1 = true; rotor31 = ushort(-drotor1);}
            else {inv1 = false; rotor31 = (ushort)drotor1;}

            if (drotor2 <= 0) {inv2 = true; rotor32 = ushort(-drotor2);}
            else {inv2 = false; rotor32 = (ushort)drotor2;}

            if (drotor3 <= 0) {inv3 = true; rotor33 = ushort(-drotor3);}
            else {inv3 = false; rotor33 = (ushort)drotor3;}

            if (drotor4 <= 0) {inv4 = true; rotor34 = ushort(-drotor4);}
            else {inv4 = false; rotor34 = (ushort)drotor4;}

            stepMotor.startMove(rotor31, rotor32, rotor33, rotor34,
                                inv1, inv2, inv3, inv4);
            break;
        }

        case 4:{
            rotor11 = (int)drotor1;
            rotor12 = (int)drotor2;
            rotor13 = (int)drotor3;
            rotor14 = (int)drotor4;
            stepMotor.moveThrough(rotor11, rotor12, rotor13, rotor14);
            break;
        }

        case 5:{
            rotor11 = (int)drotor1;
            rotor12 = (int)drotor2;
            rotor13 = (int)drotor3;
            rotor14 = (int)drotor4;
            stepMotor.goTo(rotor11, rotor12, rotor13, rotor14);
            break;
        }

        case 7:{
            rotor11 = (int)drotor1;
            rotor12 = (int)drotor2;
            rotor13 = (int)drotor3;
            rotor14 = (int)drotor4;

            stepMotor.setPosition(rotor11, rotor12, rotor13, rotor14);
            break;
        }

        case 91:{
            rotor21 = rotor1.toULong();
            rotor22 = rotor2.toULong();
            rotor23 = rotor3.toULong();
            rotor24 = rotor4.toULong();

            stepMotor.setParam(rotor21, rotor22, rotor23, rotor24, 1, 1, 1, 1);
            break;
        }

        case 92:{
            stepMotor.listFifo();

//            rotor21 = rotor1.toULong();
//            rotor22 = rotor2.toULong();
//            rotor23 = rotor3.toULong();
//            rotor24 = rotor4.toULong();

//            stepMotor.setParam(rotor21, rotor22, rotor23, rotor24, 2, 2, 2, 2);
            break;
        }

        case 100:{
            if (rotor1.toUShort() != 0) {stepMotor.DegreeToNumbers[0] = rotor1.toUShort();}
            if (rotor2.toUShort() != 0) {stepMotor.DegreeToNumbers[1] = rotor2.toUShort();}
            if (rotor3.toUShort() != 0) {stepMotor.DegreeToNumbers[2] = rotor3.toUShort();}
            if (rotor4.toUShort() != 0) {stepMotor.DegreeToNumbers[3] = rotor4.toUShort();}

            QString message = QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss") +
                    + " new coefficient: "
                    + QString::number(stepMotor.DegreeToNumbers[0]) + " "
                    + QString::number(stepMotor.DegreeToNumbers[1]) + " "
                    + QString::number(stepMotor.DegreeToNumbers[2]) + " "
                    + QString::number(stepMotor.DegreeToNumbers[3]) + " \n";

            commandListTo();
            messageTo(message);
            stepMotor.longPositonsCoord[0] = stepMotor.longPositonsCoord[0] * stepMotor.DegreeToNumbers[0];
            stepMotor.longPositonsCoord[1] = stepMotor.longPositonsCoord[1] * stepMotor.DegreeToNumbers[1];
            stepMotor.longPositonsCoord[2] = stepMotor.longPositonsCoord[2] * stepMotor.DegreeToNumbers[2];
            stepMotor.longPositonsCoord[2] = stepMotor.longPositonsCoord[3] * stepMotor.DegreeToNumbers[3];
            stepMotor.saveParams();
            break;
        }
        // мин угол
        case 101:
            rotor11 = (int)drotor1;
            rotor12 = (int)drotor2;
            rotor13 = (int)drotor3;
            rotor14 = (int)drotor4;
            stepMotor.changeRotorParams(rotor11, rotor12, rotor13, rotor14, 2);
            break;
        // макс угол
        case 102:
            rotor11 = (int)drotor1;
            rotor12 = (int)drotor2;
            rotor13 = (int)drotor3;
            rotor14 = (int)drotor4;
            stepMotor.changeRotorParams(rotor11, rotor12, rotor13, rotor14, 3);
            break;
        // ускор
        case 103:
            rotor11 = rotor1.toInt();
            rotor12 = rotor2.toInt();
            rotor13 = rotor3.toInt();
            rotor14 = rotor4.toInt();
            stepMotor.changeRotorParams(rotor11, rotor12, rotor13, rotor14, 4);
            break;
        // скорость
        case 104:
            rotor11 = rotor1.toInt();
            rotor12 = rotor2.toInt();
            rotor13 = rotor3.toInt();
            rotor14 = rotor4.toInt();
            stepMotor.changeRotorParams(rotor11, rotor12, rotor13, rotor14, 5);
            break;
    }
}

// Кнопка Старт
//void stepMotorQML::getRotorMoveValue(QString rotor1, QString rotor2, QString rotor3, QString rotor4,
//                                     bool inv1, bool inv2, bool inv3, bool inv4)
//{
//    quint16 rotor11 = rotor1.toUShort();
//    quint16 rotor22 = rotor2.toUShort();
//    quint16 rotor33 = rotor3.toUShort();
//    quint16 rotor44 = rotor4.toUShort();

//    stepMotor.startMove(rotor11, rotor22, rotor33, rotor44,
//                        inv1, inv2, inv3, inv4);
//}



void stepMotorQML::messageTo(QString message)
{
    messageAll = message + "\n\n" + messageAll;
    if(messageAll.size() > 2000){
        messageAll.resize(2000);
    }
    messageToGUI(messageAll);
}

void stepMotorQML::commandListTo()
{
    QString message = "";
    if(!stepMotor.commandShowList.isEmpty())
    {
        for(int i = 0; i < stepMotor.commandShowList.size(); i++)
        {
            stepMotor.commandShowList[i].replace("\n", " ");
            message += QString::number(i + 1) + " " +  stepMotor.commandShowList[i] + "<br><br>";
        }
    }
    qDebug() << message;
    qDebug() << stepMotor.activeCommand;
    commandListToGUI(message, stepMotor.activeCommand);
}

// Кнопка остановки
void stepMotorQML::btnStop()
{
    btnStartCommandList(false);
    stepMotor.stopMove();
}

void stepMotorQML::btnSaveCommandList(QString filedest)
{
    if(!stepMotor.commandShowList.isEmpty())
    {
        QString text = "";
        for(int i = 0; i < stepMotor.commandShowList.size(); i++)
        {
            stepMotor.commandShowList[i].replace("\n", " ");
            text += stepMotor.commandShowList[i] + "\n";
        }
        filedest.remove(0, 8);
        readTxt.saveTxtFile(text, filedest);
    }
}

void stepMotorQML::btnLoadCommandList(QString filedest)
{
    filedest.remove(0, 8);
    stepMotor.commandShowList.clear();
    stepMotor.commandShowListFromSave.clear();
    stepMotor.Fifo.clear();
    QString text = readTxt.loadTxtFile(filedest);
    stepMotor.commandShowListFromSave = text.split(QRegExp("\n"));
    stepMotor.commandShowListFromSave.removeLast();
    stepMotor.listFifoFromCommandList();
    commandListTo();
//    QString text = "";
//    for(int i = 0; i < stepMotor.commandShowList.size(); i++)
//    {
//        stepMotor.commandShowList[i].replace("\n", " ");
//        text += stepMotor.commandShowList[i] + "\n";
//    }
}

void stepMotorQML::btnStartCommandList(bool startCommandList)
{
    stepMotor.startFifoList = startCommandList;
}

void stepMotorQML::btnRemoveLastCommand()
{
    if(!stepMotor.commandShowList.isEmpty())
    {
        stepMotor.commandShowList.removeLast();
        stepMotor.Fifo.removeLast();
    }
    commandListTo();
}

void stepMotorQML::btnDeleteAllCommands()
{
    if(!stepMotor.commandShowList.isEmpty()){
        stepMotor.Fifo.clear();
        stepMotor.commandShowList.clear();
    }
    commandListTo();
}

void stepMotorQML::btnQuit()
{
    stepMotor.saveParams();
}
//Кнопка статуса
//void stepMotorQML::btnStatus()
//{
//    stepMotor.setParam();
//}

// сигнал для статуса подключения на интерфейс
void stepMotorQML::connectedStatus(bool conStatus)
{
    connectRotors(conStatus);
}

// сигнал для статуса движений двигателей на интерфейс
void stepMotorQML::rotorStatus()
{
    rotorsRotation(stepMotor.rotorMove[0], stepMotor.rotorMove[1],
                   stepMotor.rotorMove[2], stepMotor.rotorMove[3],
                   stepMotor.allMoveIcon);
}

void stepMotorQML::setPathToSave(QString path)
{
    stepMotor.setFilePath(path);
    stepMotor.saveParams();
}

void stepMotorQML::ConnectPath(QString path)
{
    setPathtoFileDialog(path);
}
