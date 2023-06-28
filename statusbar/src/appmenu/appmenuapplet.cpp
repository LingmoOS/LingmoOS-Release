/*
 * Copyright 2021 Reion Wong <aj@cuteos.com>
 * Copyright 2016 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "appmenuapplet.h"
#include <QAction>
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QKeyEvent>
#include <QMenu>
#include <QMouseEvent>
#include <QQuickItem>
#include <QQuickWindow>
#include <QScreen>
#include <QTimer>

int AppMenuApplet::s_refs = 0;

static QString viewService()
{
    return QStringLiteral("com.cute.cappmenuview");
}

AppMenuApplet::AppMenuApplet(QObject *parent)
    : QObject(parent)
{
    ++s_refs;
    // if we're the first, register the service
//    if (s_refs == 1) {
//        QDBusConnection::sessionBus().interface()->registerService(viewService(),
//                                                                   QDBusConnectionInterface::QueueService,
//                                                                   QDBusConnectionInterface::DontAllowReplacement);
//    }
    /*it registers or unregisters the service when the destroyed value of the applet change,
      and not in the dtor, because:
      when we "delete" an applet, it just hides it for about a minute setting its status
      to destroyed, in order to be able to do a clean undo: if we undo, there will be
      another destroyedchanged and destroyed will be false.
      When this happens, if we are the only appmenu applet existing, the dbus interface
      will have to be registered again*/
//    connect(this, &Applet::destroyedChanged, this, [](bool destroyed) {
//        if (destroyed) {
//            // if we were the last, unregister
//            if (--s_refs == 0) {
//                QDBusConnection::sessionBus().interface()->unregisterService(viewService());
//            }
//        } else {
//            // if we're the first, register the service
//            if (++s_refs == 1) {
//                QDBusConnection::sessionBus().interface()->registerService(viewService(),
//                                                                           QDBusConnectionInterface::QueueService,
//                                                                           QDBusConnectionInterface::DontAllowReplacement);
//            }
//        }
//    });
}

int AppMenuApplet::currentIndex() const
{
    return m_currentIndex;
}

QQuickItem *AppMenuApplet::buttonGrid() const
{
    return m_buttonGrid;
}

void AppMenuApplet::setButtonGrid(QQuickItem *buttonGrid)
{
    if (m_buttonGrid != buttonGrid) {
        m_buttonGrid = buttonGrid;
        emit buttonGridChanged();
    }
}

AppMenuModel *AppMenuApplet::model() const
{
    return m_model;
}

void AppMenuApplet::setModel(AppMenuModel *model)
{
    if (m_model != model) {
        m_model = model;
        emit modelChanged();
    }
}

void AppMenuApplet::trigger(QQuickItem *ctx, int idx)
{
    if (m_currentIndex == idx) {
        return;
    }

    if (!ctx || !ctx->window() || !ctx->window()->screen()) {
        return;
    }

    QMenu *actionMenu = createMenu(idx);
    if (actionMenu) {
        // this is a workaround where Qt will fail to realize a mouse has been released
        // this happens if a window which does not accept focus spawns a new window that takes focus and X grab
        // whilst the mouse is depressed
        // https://bugreports.qt.io/browse/QTBUG-59044
        // this causes the next click to go missing

        // by releasing manually we avoid that situation
        auto ungrabMouseHack = [ctx]() {
            if (ctx && ctx->window() && ctx->window()->mouseGrabberItem()) {
                // FIXME event forge thing enters press and hold move mode :/
                ctx->window()->mouseGrabberItem()->ungrabMouse();
            }
        };

        QTimer::singleShot(0, ctx, ungrabMouseHack);
        // end workaround

        const auto &geo = ctx->window()->screen()->availableVirtualGeometry();

        QPoint pos = ctx->window()->mapToGlobal(ctx->mapToScene(QPointF()).toPoint());
        // Top
        pos.setY(pos.y() + ctx->height() + 6);

        actionMenu->adjustSize();

        pos = QPoint(qBound(geo.x(), pos.x(), geo.x() + geo.width() - actionMenu->width()),
                     qBound(geo.y(), pos.y(), geo.y() + geo.height() - actionMenu->height()));

        actionMenu->installEventFilter(this);

        actionMenu->winId(); // create window handle
        actionMenu->windowHandle()->setTransientParent(ctx->window());

        // hide the old menu only after showing the new one to avoid brief focus flickering on X11.
        // on wayland, you can't have more than one grabbing popup at a time so we show it after
        // the menu has hidden. thankfully, wayland doesn't have this flickering.
        if (!KWindowSystem::isPlatformWayland()) {
            actionMenu->popup(pos);
        }

        QMenu *oldMenu = m_currentMenu;
        m_currentMenu = actionMenu;
        if (oldMenu && oldMenu != actionMenu) {
            // don't initialize the currentIndex when another menu is already shown
            disconnect(oldMenu, &QMenu::aboutToHide, this, &AppMenuApplet::onMenuAboutToHide);
            oldMenu->hide();
        }

        if (KWindowSystem::isPlatformWayland()) {
            actionMenu->popup(pos);
        }

        setCurrentIndex(idx);

        // FIXME TODO connect only once
        connect(actionMenu, &QMenu::aboutToHide, this, &AppMenuApplet::onMenuAboutToHide, Qt::UniqueConnection);
    } else { // is it just an action without a menu?
        const QVariant data = m_model->index(idx, 0).data(AppMenuModel::ActionRole);
        QAction *action = static_cast<QAction *>(data.value<void *>());
        if (action) {
            Q_ASSERT(!action->menu());
            action->trigger();
        }
    }
}

bool AppMenuApplet::eventFilter(QObject *watched, QEvent *event)
{
    auto *menu = qobject_cast<QMenu *>(watched);
    if (!menu) {
        return false;
    }

    if (event->type() == QEvent::KeyPress) {
        auto *e = static_cast<QKeyEvent *>(event);

        // TODO right to left languages
        if (e->key() == Qt::Key_Left) {
            int desiredIndex = m_currentIndex - 1;
            emit requestActivateIndex(desiredIndex);
            return true;
        } else if (e->key() == Qt::Key_Right) {
            if (menu->activeAction() && menu->activeAction()->menu()) {
                return false;
            }

            int desiredIndex = m_currentIndex + 1;
            emit requestActivateIndex(desiredIndex);
            return true;
        }

    } else if (event->type() == QEvent::MouseMove) {
        auto *e = static_cast<QMouseEvent *>(event);

        if (!m_buttonGrid || !m_buttonGrid->window()) {
            return false;
        }

        const QPointF &windowLocalPos = m_buttonGrid->window()->mapFromGlobal(e->globalPos());
        const QPointF &buttonGridLocalPos = m_buttonGrid->mapFromScene(windowLocalPos);

        // Reduce the number of transmission signal.
        if (buttonGridLocalPos.x() < m_buttonGrid->window()->x() ||
            buttonGridLocalPos.y() > m_buttonGrid->window()->height())
            return false;

        emit mousePosChanged(buttonGridLocalPos.x(), buttonGridLocalPos.y());
    }

    return false;
}

QMenu *AppMenuApplet::createMenu(int idx) const
{
    QMenu *menu = nullptr;
    QAction *action = nullptr;

    const QModelIndex index = m_model->index(idx, 0);
    const QVariant data = m_model->data(index, AppMenuModel::ActionRole);
    action = (QAction *)data.value<void *>();
    if (action) {
        menu = action->menu();
    }

    return menu;
}

void AppMenuApplet::setCurrentIndex(int currentIndex)
{
    if (m_currentIndex != currentIndex) {
        m_currentIndex = currentIndex;
        emit currentIndexChanged();
    }
}

void AppMenuApplet::onMenuAboutToHide()
{
    setCurrentIndex(-1);
}
