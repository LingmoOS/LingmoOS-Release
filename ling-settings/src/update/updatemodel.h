#ifndef UPDATEMODEL_H
#define UPDATEMODEL_H

#include <QObject>

#include <QApt/Backend>
#include <QApt/Config>
#include <QApt/Transaction>

class UpdateModel : public QObject
{
    Q_OBJECT

public:
    explicit UpdateModel(QObject *parent = nullptr);

public slots:
    void onTransactionStatusChanged(QApt::TransactionStatus status);

private:
    QApt::Backend *m_backend;
    QApt::Package *m_package;
    QApt::Transaction *m_trans;
};

#endif // UPDATEMODEL_H
