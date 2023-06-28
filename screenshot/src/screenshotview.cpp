/*
 * Copyright (C) 2021 CuteOS Team.
 *
 * Author:     Reion Wong <reionwong@gmail.com>
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

#include "screenshotview.h"

#include <QClipboard>
#include <QEventLoop>
#include <QTimer>

#include <QGuiApplication>
#include <QQmlContext>
#include <QScreen>
#include <QPixmap>
#include <QStandardPaths>
#include <QDateTime>

#include <QDBusInterface>
#include <QDBusPendingCall>

ScreenshotView::ScreenshotView(QQuickView *parent)
    : QQuickView(parent)
{
    rootContext()->setContextProperty("view", this);

    setFlags(Qt::FramelessWindowHint | Qt::X11BypassWindowManagerHint);
    setScreen(qGuiApp->primaryScreen());
    setResizeMode(QQuickView::SizeRootObjectToView);
    setSource(QUrl("qrc:/qml/main.qml"));
    setGeometry(screen()->geometry());
}

void ScreenshotView::start()
{
    // 保存图片
    QPixmap p = qGuiApp->primaryScreen()->grabWindow(0);
    p.save("/tmp/cute-screenshot.png");

    setVisible(true);
    setKeyboardGrabEnabled(true);

    emit refresh();
}

void ScreenshotView::delay(int value)
{
    QEventLoop waitLoop;
    QTimer::singleShot(value, &waitLoop, SLOT(quit()));
    waitLoop.exec();

    start();
}

void ScreenshotView::quit()
{
    qGuiApp->quit();
}

void ScreenshotView::saveFile(QRect rect)
{
    setVisible(false);

    QString desktopPath = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
    QString fileName = QString("%1/Screenshot_%2.png")
                              .arg(desktopPath)
                              .arg(QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss"));

    QImage image("/tmp/cute-screenshot.png");
    QImage cropped = image.copy(rect);
    bool saved = cropped.save(fileName);

    if (saved) {
        QDBusInterface iface("org.freedesktop.Notifications",
                             "/org/freedesktop/Notifications",
                             "org.freedesktop.Notifications",
                             QDBusConnection::sessionBus());
        if (iface.isValid()) {
            QList<QVariant> args;
            args << "cute-screenshot";
            args << ((unsigned int) 0);
            args << "cute-screenshot";
            args << "";
            args << tr("The picture has been saved to %1").arg(fileName);
            args << QStringList();
            args << QVariantMap();
            args << (int) 10;
            iface.asyncCallWithArgumentList("Notify", args);
        }
    }

    removeTmpFile();
    this->quit();
}

void ScreenshotView::copyToClipboard(QRect rect)
{
    setVisible(false);

    QImage image("/tmp/cute-screenshot.png");
    QImage cropped = image.copy(rect);
    QClipboard *clipboard = qGuiApp->clipboard();
    clipboard->setImage(cropped);

    QDBusInterface iface("org.freedesktop.Notifications",
                         "/org/freedesktop/Notifications",
                         "org.freedesktop.Notifications",
                         QDBusConnection::sessionBus());
    if (iface.isValid()) {
        QList<QVariant> args;
        args << "cute-screenshot";
        args << ((unsigned int) 0);
        args << "cute-screenshot";
        args << "";
        args << tr("The picture has been saved to the clipboard");
        args << QStringList();
        args << QVariantMap();
        args << (int) 10;
        iface.asyncCallWithArgumentList("Notify", args);
    }

    removeTmpFile();

    QTimer::singleShot(100, qGuiApp, &QGuiApplication::quit);
}

void ScreenshotView::removeTmpFile()
{
    QFile("/tmp/cute-screenshot.png").remove();
}
