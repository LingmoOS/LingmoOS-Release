/******************************************************************
 * Copyright 2021 Reion Wong <aj@cuteos.com>
 * Copyright 2016 Chinmoy Ranjan Pradhan <chinmoyrp65@gmail.com>
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
 ******************************************************************/

#ifndef APPMENUMODEL_H
#define APPMENUMODEL_H

#include <KWindowSystem>
#include <QAbstractListModel>
#include <QPointer>
#include <QRect>
#include <QStringList>

class QMenu;
class QModelIndex;
class QDBusServiceWatcher;
class CDBusMenuImporter;

class AppMenuModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(bool menuAvailable READ menuAvailable WRITE setMenuAvailable NOTIFY menuAvailableChanged)
    Q_PROPERTY(bool visible READ visible NOTIFY visibleChanged)

public:
    explicit AppMenuModel(QObject *parent = nullptr);
    ~AppMenuModel() override;

    enum AppMenuRole {
        MenuRole = Qt::UserRole + 1, // TODO this should be Qt::DisplayRole
        ActionRole,
    };

    QVariant data(const QModelIndex &index, int role) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    void updateApplicationMenu(const QString &serviceName, const QString &menuObjectPath);

    bool menuAvailable() const;
    void setMenuAvailable(bool set);

    bool visible() const;

Q_SIGNALS:
    void requestActivateIndex(int index);

private Q_SLOTS:
    void onActiveWindowChanged();
    void setVisible(bool visible);
    void update();

Q_SIGNALS:
    void menuAvailableChanged();
    void modelNeedsUpdate();
    void visibleChanged();

private:
    bool m_menuAvailable;
    bool m_updatePending = false;
    bool m_visible = true;

    //! current active window used
    WId m_currentWindowId = 0;
    //! window that its menu initialization may be delayed
    WId m_delayedMenuWindowId = 0;

    QPointer<QMenu> m_menu;

    QDBusServiceWatcher *m_serviceWatcher;
    QString m_serviceName;
    QString m_menuObjectPath;

    QPointer<CDBusMenuImporter> m_importer;
};

#endif
