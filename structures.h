#include <QObject>
#define N 6
#ifndef STRUCTURES_H
#define STRUCTURES_H


#endif // STRUCTURES_H

struct AxesMask{
    unsigned short a1: 1;
    unsigned short a2: 1;
    unsigned short a3: 1;
    unsigned short a4: 1;
    unsigned short a5: 1;
    unsigned short a6: 1;
    unsigned short a7: 1;
    unsigned short a8: 1;
    unsigned short a9: 1;
    unsigned short a10: 1;
    unsigned short a11: 1;
    unsigned short a12: 1;
    unsigned short a13: 1;
    unsigned short a14: 1;
    unsigned short a15: 1;
    unsigned short a16: 1;
};

struct smStart{
    unsigned short nCmd = 0x02;
    AxesMask axes;
    bool dir[N] = {0};
    unsigned short speed[N] = {0};
    unsigned short acceleration[N] = {0};
};

struct smStop{
    unsigned short nCmd = 0x03;
    AxesMask axes;
    bool stopMode[N];
};

#pragma pack(push, 1)
struct smMove{
    unsigned short nCmd = 0x04;
    AxesMask axes;
    unsigned short speed[N];
    unsigned short acceleration[N];
    signed long dist[N];
};
#pragma pack(pop)

struct smGOTO{
    unsigned short nCmd = 0x05;
    AxesMask axes;
    unsigned short speed[N];
    unsigned short acceleration[N];
    signed long position[N];
};

struct smStatus{
    unsigned short nCmd = 0x06;
//    unsigned long position[N];
//    unsigned long positionEnc[N];
//    unsigned int state[N];
};

#pragma pack(push, 1)
struct smStatusGet{
    unsigned short nCmd = 0x06;
    signed long position[N];
    signed long positionEnc[N];
    unsigned int state[N];
};
#pragma pack(pop)


struct smSetPos{
    unsigned short nCmd = 0x07;
    AxesMask axes;
    signed long position[N];
    signed long positionEnc[N];
};

struct smEmergency{
    unsigned short nCmd = 0x08;
    // unsigned int key[N - 1];
    unsigned long key1 = 1234;
};

