#ifndef READTXT_H
#define READTXT_H

#include <QObject>
#include <QFile>
#include <QTextStream>


class readTxt : public QObject
{
    Q_OBJECT
public:
    explicit readTxt(QObject *parent = nullptr);
    void saveTxtFile(QString text, QString fileRout);
    QString loadTxtFile(QString fileRout);

signals:

public slots:

private:
};

#endif // READTXT_H
