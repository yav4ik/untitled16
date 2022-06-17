#ifndef STEPMOTOR_H
#define STEPMOTOR_H

#include <QtNetwork/QTcpSocket>
#include <QHostAddress>
#include <QTimer>
#include <QTime>
#include <QThread>
#include <QCoreApplication>
#include <readtxt.h>

const int N = 6;

enum COMMANDS
{
    STATUS = 0x06
};

struct AxesMask{
    unsigned short a1 : 1;
    unsigned short a2 : 1;
    unsigned short a3 : 1;
    unsigned short a4 : 1;
    unsigned short a5 : 1;
    unsigned short a6 : 1;
    unsigned short a7 : 1;
    unsigned short a8 : 1;
    unsigned short a9 : 1;
    unsigned short a10 : 1;
    unsigned short a11 : 1;
    unsigned short a12 : 1;
    unsigned short a13 : 1;
    unsigned short a14 : 1;
    unsigned short a15 : 1;
    unsigned short a16 : 1;
};

struct ManualStart{
    const unsigned short nCmd = 0x02;
    AxesMask axes;
    bool dir[N] = {0};
    unsigned short speed[N] = {0};
    unsigned short acceleration[N] = {0};
};

struct ManualStop{
    const unsigned short nCmd = 0x03;
    AxesMask axes;
    bool stopMode[N];
};

#pragma pack(push, 1)
struct goOn{
    const unsigned short nCmd = 0x04;
    AxesMask axes;
    unsigned short speed[N];
    unsigned short acceleration[N];
    signed long dist[N];
};
#pragma pack(pop)

struct ManualGoto{
    const unsigned short nCmd = 0x05;
    AxesMask axes;
    unsigned short speed[N];
    unsigned short acceleration[N];
    signed long position[N];
};

struct ManualStatus{
    const unsigned short nCmd = STATUS;
//    unsigned long position[N];
//    unsigned long positionEnc[N];
//    unsigned int state[N];
};
#pragma pack(push, 1)
struct ManualAnswerStatus{
    const unsigned short nCmd = 0x06;
    signed long position[N];
    signed long positionEnc[N];
    unsigned char state[N];
};
#pragma pack(pop)


struct ManualSetPos{
    const unsigned short nCmd = 0x07;
    AxesMask axes;
    qint32 position[N];
    qint32 positionEnc[N];
};

struct Emergency{
    const unsigned short nCmd = 0x08;
    // unsigned int key[N - 1];
    unsigned long key1 = 1234;
    unsigned long key2 = 0;
    unsigned long key3 = 4321;
};

struct ManualSetParam{
    const unsigned short nCmd = 0x09;
    AxesMask axes;
    unsigned short paramId[N];
    unsigned long paramValue[N];
};

Q_DECLARE_METATYPE(ManualStart)
Q_DECLARE_METATYPE(ManualStop)
Q_DECLARE_METATYPE(goOn)
Q_DECLARE_METATYPE(ManualGoto)
Q_DECLARE_METATYPE(ManualAnswerStatus)
Q_DECLARE_METATYPE(ManualSetPos)
Q_DECLARE_METATYPE(Emergency)
Q_DECLARE_METATYPE(ManualSetParam)

class stepmotor : public QObject
{
    Q_OBJECT
private:
    QHostAddress m_dstIP = QHostAddress("192.168.10.1"), m_srcIP = QHostAddress("192.168.10.1");
    uint16_t m_dstPort = 50005, m_srcPort = 50032;
    QTcpSocket *p_Client = nullptr;
    QTimer *listTimer;
    QTimer *checkConnect;
    int connectStatus = -1;
    int nComparePos = 0;
    double position0 = 0, position1 = 0, position2 = 0, position3 = 0;
    unsigned short speedFromSave[N] = {200, 200, 200, 200};
    unsigned short accelerationFromSave[N] = {10, 10, 10, 10};
    QString filePath = "";
    unsigned short maxSpeed = 400;

    void actionsFifoFirstRemove(QString message);
    QString getNumberFromCommandList(QString command, QString firsWords, QString lastWords);

public:
    signed long longPositonsCoord[N] = {0};
    unsigned short speed[N] = {200, 200, 200, 200};
    unsigned short acceleration[N] = {10, 10, 10, 10};
    unsigned short DegreeToNumbers[N] = {1, 1, 1, 1};
    qint32 maxAngles[N] = {0, 0, 0, 0};
    qint32 minAngles[N] = {0, 0, 0, 0};


    bool rotorMove[N] = {false, false, false, false};
    bool allMoveIcon = false;
    QList<QString> commandShowList;
    QList<QString> commandShowListFromSave;
    QList<QVariant> Fifo;
    QString activeCommand = "";
    bool startFifoList = false;

    stepmotor();
    void setFilePath(QString);
    QString getFilePath();
    void setConnectParams(QHostAddress srcIP, QHostAddress dstIP, uint16_t srcPort, uint16_t dstPort);
    void initialization(QHostAddress srcIP, QHostAddress dstIP, uint16_t srcPort, uint16_t dstPort);

    void startMove(quint16 rotor1, quint16 rotor2, quint16 rotor3, quint16 rotor4,
                   bool inv1, bool inv2, bool inv3, bool inv4, bool fromSave = false);

    void stopMove();
    void moveThrough(qint32, qint32, qint32, qint32, bool fromSave = false);
    void goTo(qint32, qint32, qint32, qint32, bool fromSave = false);
    void status();
    void setPosition(qint32, qint32, qint32, qint32);
    void comparePos(signed long, signed long, signed long, signed long);
    void setParam(unsigned long, unsigned long,
                  unsigned long, unsigned long,
                  unsigned short paramID1 = 0, unsigned short paramID2 = 0,
                  unsigned short paramID3 = 0, unsigned short paramID4 = 0);

    void listFifoFromCommandList();
    void loadParams();
    void saveParams();
    void changeRotorParams(qint32, qint32, qint32, qint32, qint32);

    static AxesMask setAxesMask(int axe);


signals:
    void onPositionChange(qint32, qint32, qint32, qint32 );
    void onGetRotorValue(QString, QString, QString, QString, qint32);
    void onAnswerPos(double, double, double, double);
    void onConnected(bool);
    void rotorRorartion();
    void messageToQML(QString);
    void onChangeCommandList();

private slots:

    int initialization();
    void onClientReadyRead();
    void checkPos();
    void disconnectSocket();


public slots:
    void listFifo();
};

#endif // STEPMOTOR_H
