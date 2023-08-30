/*
 * Copyright (C) 2021 CuteOS Team.
 *
 * Author:     Kate Leet <kate@cuteos.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "updatorhelper.h"
#include "upgradeablemodel.h"
#include <QSettings>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QTimer>
#include <QDebug>

const static QString s_dbusName = "com.cute.Session";
const static QString s_pathName = "/Session";
const static QString s_interfaceName = "com.cute.Session";

UpdatorHelper::UpdatorHelper(QObject *parent)
    : QObject(parent)
    , m_checkProgress(0)
    , m_backend(new QApt::Backend(this))
    , m_trans(nullptr)
{
    m_backend->init();

    QSettings settings("/etc/lingmo", QSettings::IniFormat);
    m_currentVersion = settings.value("Version").toString();

    QTimer::singleShot(100, this, &UpdatorHelper::checkUpdates);
}

UpdatorHelper::~UpdatorHelper()
{
}

void UpdatorHelper::checkUpdates()
{
    if (m_trans)
        return;

    m_checkProgress = 0;
    m_trans = m_backend->updateCache();
    m_trans->setLocale(QLatin1String(setlocale(LC_MESSAGES, 0)));

    connect(m_trans, &QApt::Transaction::progressChanged, this, [=] (int progress) {
        m_checkProgress = progress <= 100 ? progress : 100;
        emit checkProgressChanged();
    });

    connect(m_trans, &QApt::Transaction::statusChanged, this, [=] (QApt::TransactionStatus status) {
        switch (status) {
        case QApt::RunningStatus: {
            break;
        }
        case QApt::FinishedStatus: {
            m_backend->reloadCache();

            bool success = m_trans->error() == QApt::Success;
            QString errorDetails = m_trans->errorDetails();

            m_trans->cancel();
            m_trans->deleteLater();
            m_trans = nullptr;

            if (success) {
                // Add packages.
                for (QApt::Package *package : m_backend->upgradeablePackages()) {
                    if (!package)
                        continue;

                    UpgradeableModel::self()->addPackage(package->name(),
                                                         package->availableVersion(),
                                                         package->downloadSize());
                }

                emit checkUpdateFinished();
            } else {
                emit checkError(errorDetails);
            }

            break;
        }
        default:
            break;
        }
    });

    m_trans->run();
}

void UpdatorHelper::upgrade()
{
    if (m_trans) {
        return;
    }

    m_statusDetails.clear();
    m_trans = m_backend->upgradeSystem(QApt::FullUpgrade);
    m_trans->setLocale(QLatin1String(setlocale(LC_MESSAGES, 0)));

    connect(m_trans, &QApt::Transaction::statusDetailsChanged, this, [=] (const QString &statusDetails) {
        m_statusDetails.append(statusDetails + "\n");
        emit statusDetailsChanged();
    });

    connect(m_trans, &QApt::Transaction::statusChanged, this, [=] (QApt::TransactionStatus status) {
        switch (status) {
        case QApt::RunningStatus: {
            emit startingUpdate();
            break;
        }
        case QApt::FinishedStatus: {
            bool success = m_trans->error() == QApt::Success;

            m_trans->cancel();
            m_trans->deleteLater();
            m_trans = nullptr;

            if (success) {
                emit updateFinished();
            } else {
                emit updateError();
            }

            break;
        }
        default:
            break;
        }
    });

    m_trans->run();
}

void UpdatorHelper::reboot()
{
    QDBusInterface iface(s_dbusName, s_pathName, s_interfaceName, QDBusConnection::sessionBus());

    if (iface.isValid()) {
        iface.call("reboot");
    }
}

QString UpdatorHelper::version()
{
    return m_currentVersion;
}

QString UpdatorHelper::statusDetails()
{
    return m_statusDetails;
}

int UpdatorHelper::checkProgress()
{
    return m_checkProgress;
}
