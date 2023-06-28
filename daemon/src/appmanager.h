#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>
#include <QApt/Backend>
#include <QApt/Transaction>

class AppManager : public QObject
{
    Q_OBJECT

public:
    explicit AppManager(QObject *parent = nullptr);

    void uninstall(const QString &content);

private:
    void notifyUninstalling(const QString &packageName);
    void notifyUninstallFailure(const QString &packageName);
    void notifyUninstallSuccess(const QString &packageName);

private:
    QApt::Backend *m_backend;
    QApt::Transaction *m_trans;
};

#endif // APPMANAGER_H
