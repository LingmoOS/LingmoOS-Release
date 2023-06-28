#include "application.h"

#include <QDBusConnection>
#include <QDebug>

Application::Application(int &argc, char **argv)
    : QCoreApplication(argc, argv)
{
}

int Application::run()
{
//    if (!QDBusConnection::systemBus().registerService("com.cute.Daemon")) {
//        return 0;
//    } else {
//        m_appManager = new AppManager(this);
//    }

//    qDebug() << QDBusConnection::systemBus().registerService("com.cute.Daemon") << " registerService";
    m_appManager = new AppManager(this);
    return QCoreApplication::exec();
}
