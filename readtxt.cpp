#include "readtxt.h"

readTxt::readTxt(QObject *parent) : QObject(parent)
{

}

void readTxt::saveTxtFile(QString text, QString fileRout)
{
    QFile file(fileRout);
    if (file.open(QIODevice::WriteOnly| QFile::Truncate | QIODevice::Text)) {
        QTextStream stream(&file);
        stream.setCodec("UTF-8");
        stream << text;
        file.close();
    }
}

QString readTxt::loadTxtFile(QString fileRout)
{
    QFile file(fileRout);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QString text = "";
        QTextStream stream(&file);
        stream.setCodec("UTF-8");
        while (!stream.atEnd()){
                    text += stream.readLine() + "\n";
        }
        file.close();
        return text;
    }
    return "error";
}
