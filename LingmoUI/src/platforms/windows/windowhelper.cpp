/*
 * Copyright (C) 2023 CuteOS Team.
 */

#include "windowhelper.h"

#include <QGuiApplication>
#include <QCursor>
#include <QDebug>


WindowHelper::WindowHelper(QObject *parent)
    : QObject(parent)
{
}

void WindowHelper::startSystemMove(QWindow *w)
{
    doStartSystemMoveResize(w, 16);
}

void WindowHelper::startSystemResize(QWindow *w, Qt::Edges edges)
{
    doStartSystemMoveResize(w, edges);
}

void WindowHelper::minimizeWindow(QWindow *w)
{
    qWarning() << "not implement";
}

void WindowHelper::doStartSystemMoveResize(QWindow *w, int edges)
{
    qWarning() << "not implement";
}
