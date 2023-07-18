/*
 * @Author: CuteOS
 * @Date: 2022-07-02 21:45:34
 * @LastEditors: 柚子
 * @LastEditTime: 2022-07-03 11:08:18
 * @FilePath: /settings/src/application.h
 * @Description: 
 * 
 * Copyright (c) 2022 by CuteOS, All Rights Reserved. 
 */
#ifndef APPLICATION_H
#define APPLICATION_H

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDBusConnection>
#include "../include/interface/moduleinterface.h"

class Application : public QApplication
{
    Q_OBJECT

public:
    explicit Application(int &argc, char **argv);
    void addPage(QString title,QString name,QString page,QString iconSource,QString iconColor,QString category);
    void switchToPage(const QString &name);

private:
    void insertPlugin();
    QQmlApplicationEngine m_engine;
};

#endif // APPLICATION_H
