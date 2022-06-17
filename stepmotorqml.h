#ifndef STEMMOTORQML_H
#define STEMMOTORQML_H

#include <QObject>
#include <cmath>
#include "stepmotor.h"


class stepMotorQML : public QObject
{
    Q_OBJECT

public:
    explicit stepMotorQML(QObject *parent = nullptr);

signals:
    void positionToLabelText(QString var1, QString var2, QString var3, QString var4);
    void connectRotors(bool conStatus);
    void rotorsRotation(bool rotorStatus1, bool rotorStatus2,
                        bool rotorStatus3, bool rotorStatus4,
                        bool allStatusIcon);

    void messageToGUI(QString message);
    void commandListToGUI(QString message, QString activeCommand);
    void setPathtoFileDialog(QString path);

public slots:
    void positionToString(double, double, double, double);
    void getRotorValue(QString, QString, QString, QString, qint32);
    //void getRotorMoveValue(QString, QString, QString, QString, bool, bool, bool, bool);
    void btnStop();
    void btnConnect();
    //void btnStatus();
    void connectedStatus(bool conStatus);
    void rotorStatus();
    //void btnList();
    void messageTo(QString);
    void commandListTo();
    void btnRemoveLastCommand();
    void btnStartCommandList(bool startCommandList);
    void btnDeleteAllCommands();
    void btnSaveCommandList(QString filedest);
    void btnLoadCommandList(QString filedest);
    void ConnectPath(QString path);
    void setPathToSave(QString);
    void btnQuit();

private:
    stepmotor stepMotor;
    readTxt readTxt;
    QString messageAll;
};



#endif // STEMMOTORQML_H
