/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     cutefish <cutefishos@foxmail.com>
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

#ifndef WINDOWHELPER_H
#define WINDOWHELPER_H

#include <QObject>
#include <QWindow>

class WindowHelper : public QObject
{
    Q_OBJECT

public:
    explicit WindowHelper(QObject *parent = nullptr);

    Q_INVOKABLE void startSystemMove(QWindow *w);
    Q_INVOKABLE void startSystemResize(QWindow *w, Qt::Edges edges);

    Q_INVOKABLE void minimizeWindow(QWindow *w);

private:
    void doStartSystemMoveResize(QWindow *w, int edges);

private:
};

#endif // WINDOWHELPER_H
