#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "stepmotorqml.h"

int main(int argc, char *argv[])
{


    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    stepMotorQML *motorQML = new stepMotorQML;
    engine.rootContext()->setContextProperty("motorQML", motorQML);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);
    motorQML->btnConnect();

    return app.exec();
}
