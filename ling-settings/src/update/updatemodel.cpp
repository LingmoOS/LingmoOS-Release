#include "updatemodel.h"
#include <QDebug>

UpdateModel::UpdateModel(QObject *parent)
    : QObject(parent)
{
    m_backend = new QApt::Backend(this);
//    m_backend->init();

//    m_trans = m_backend->updateCache();
//    m_trans->setLocale(QLatin1String(setlocale(LC_MESSAGES, 0)));
//    connect(m_trans, SIGNAL(statusChanged(QApt::TransactionStatus)),
//            this, SLOT(onTransactionStatusChanged(QApt::TransactionStatus)));
//    m_trans->run();
}

void UpdateModel::onTransactionStatusChanged(QApt::TransactionStatus status)
{
//    qDebug() << status;

//    switch (status) {
//    case QApt::FinishedStatus:
//        m_backend->reloadCache();
//        qDebug() << "Finished";
//        m_trans->deleteLater();
//        m_trans = nullptr;
//        break;
//    default:
//        break;
//    }
}
