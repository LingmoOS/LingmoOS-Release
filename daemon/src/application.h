#ifndef APPLICATION_H
#define APPLICATION_H

#include <QCoreApplication>
#include "appmanager.h"

class Application : public QCoreApplication
{
    Q_OBJECT

public:
    explicit Application(int &argc, char **argv);

    int run();

private:
    AppManager *m_appManager;

};

#endif // APPLICATION_H
