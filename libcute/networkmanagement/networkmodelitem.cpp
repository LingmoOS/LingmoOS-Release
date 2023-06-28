/*
    Copyright 2013-2018 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "networkmodelitem.h"
#include "uiutils.h"

#include <NetworkManagerQt/AdslDevice>
#include <NetworkManagerQt/BluetoothDevice>
#include <NetworkManagerQt/BondDevice>
#include <NetworkManagerQt/BridgeDevice>
#include <NetworkManagerQt/InfinibandDevice>
#include <NetworkManagerQt/Manager>
#include <NetworkManagerQt/ModemDevice>
#include <NetworkManagerQt/Settings>
#include <NetworkManagerQt/TeamDevice>
#include <NetworkManagerQt/VlanDevice>
#include <NetworkManagerQt/VpnConnection>
#include <NetworkManagerQt/VpnSetting>
#include <NetworkManagerQt/WiredDevice>
#include <NetworkManagerQt/WirelessDevice>
#include <NetworkManagerQt/WirelessSetting>

#if WITH_MODEMMANAGER_SUPPORT
#include <ModemManagerQt/manager.h>
#include <ModemManagerQt/modem.h>
#include <ModemManagerQt/modemdevice.h>
#include <ModemManagerQt/modem3gpp.h>
#include <ModemManagerQt/modemcdma.h>
#endif

NetworkModelItem::NetworkModelItem(QObject *parent)
    : QObject(parent)
    , m_connectionState(NetworkManager::ActiveConnection::Deactivated)
    , m_deviceState(NetworkManager::Device::UnknownState)
    , m_detailsValid(false)
    , m_duplicate(false)
    , m_mode(NetworkManager::WirelessSetting::Infrastructure)
    , m_securityType(NetworkManager::NoneSecurity)
    , m_signal(0)
    , m_slave(false)
    , m_type(NetworkManager::ConnectionSettings::Unknown)
    , m_vpnState(NetworkManager::VpnConnection::Unknown)
    , m_rxBytes(0)
    , m_txBytes(0)
{
}

NetworkModelItem::NetworkModelItem(const NetworkModelItem *item, QObject *parent)
    : QObject(parent)
    , m_connectionPath(item->connectionPath())
    , m_connectionState(NetworkManager::ActiveConnection::Deactivated)
    , m_detailsValid(false)
    , m_duplicate(true)
    , m_mode(item->mode())
    , m_name(item->name())
    , m_securityType(item->securityType())
    , m_slave(item->slave())
    , m_ssid(item->ssid())
    , m_timestamp(item->timestamp())
    , m_type(item->type())
    , m_uuid(item->uuid())
    , m_vpnState(NetworkManager::VpnConnection::Unknown)
    , m_rxBytes(0)
    , m_txBytes(0)
{
}

NetworkModelItem::~NetworkModelItem()
{
}

QString NetworkModelItem::activeConnectionPath() const
{
    return m_activeConnectionPath;
}

void NetworkModelItem::setActiveConnectionPath(const QString &path)
{
    m_activeConnectionPath = path;
}

QString NetworkModelItem::connectionPath() const
{
    return m_connectionPath;
}

void NetworkModelItem::setConnectionPath(const QString &path)
{
    if (m_connectionPath != path) {
        m_connectionPath = path;
        m_changedRoles << NetworkModel::ConnectionPathRole << NetworkModel::UniRole;
    }
}

NetworkManager::ActiveConnection::State NetworkModelItem::connectionState() const
{
    return m_connectionState;
}

void NetworkModelItem::setConnectionState(NetworkManager::ActiveConnection::State state)
{
    if (m_connectionState != state) {
        m_connectionState = state;
        m_changedRoles << NetworkModel::ConnectionStateRole << NetworkModel::SectionRole;
        refreshIcon();
    }
}

QStringList NetworkModelItem::details() const
{
    if (!m_detailsValid) {
        updateDetails();
    }
    return m_details;
}

QString NetworkModelItem::devicePath() const
{
    return m_devicePath;
}

QString NetworkModelItem::deviceName() const
{
    return m_deviceName;
}

void NetworkModelItem::setDeviceName(const QString &name)
{
    if (m_deviceName != name) {
        m_deviceName = name;
        m_changedRoles << NetworkModel::DeviceName;
    }
}

void NetworkModelItem::setDevicePath(const QString &path)
{
    if (m_devicePath != path) {
        m_devicePath = path;
        m_changedRoles << NetworkModel::DevicePathRole << NetworkModel::ItemTypeRole << NetworkModel::UniRole;
    }
}

QString NetworkModelItem::deviceState() const
{
    return UiUtils::connectionStateToString(m_deviceState);
}

void NetworkModelItem::setDeviceState(const NetworkManager::Device::State state)
{
    if (m_deviceState != state) {
        m_deviceState = state;
        m_changedRoles << NetworkModel::DeviceStateRole;
    }
}

bool NetworkModelItem::duplicate() const
{
    return m_duplicate;
}

void NetworkModelItem::setIcon(const QString& icon)
{
    if (icon != m_icon) {
        m_icon = icon;
        m_changedRoles << NetworkModel::ConnectionIconRole;
    }
}

void NetworkModelItem::refreshIcon()
{
    setIcon(computeIcon());
}

QString NetworkModelItem::computeIcon() const
{
    switch (m_type) {
        case NetworkManager::ConnectionSettings::Adsl:
            return QStringLiteral("network-mobile-100");
            break;
        case NetworkManager::ConnectionSettings::Bluetooth:
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                return QStringLiteral("network-bluetooth-activated");
            } else {
                return QStringLiteral("network-bluetooth");
            }
            break;
        case NetworkManager::ConnectionSettings::Bond:
            break;
        case NetworkManager::ConnectionSettings::Bridge:
            break;
        case NetworkManager::ConnectionSettings::Cdma:
        case NetworkManager::ConnectionSettings::Gsm:
            if (m_signal == 0 ) {
                return QStringLiteral("network-mobile-0");
            } else if (m_signal < 20) {
                return QStringLiteral("network-mobile-20");
            } else if (m_signal < 40) {
                return QStringLiteral("network-mobile-40");
            } else if (m_signal < 60) {
                return QStringLiteral("network-mobile-60");
            } else if (m_signal < 80) {
                return QStringLiteral("network-mobile-80");
            } else {
                return QStringLiteral("network-mobile-100");
            }
            break;
        case NetworkManager::ConnectionSettings::Infiniband:
            break;
        case NetworkManager::ConnectionSettings::OLPCMesh:
            break;
        case NetworkManager::ConnectionSettings::Pppoe:
            return QStringLiteral("network-mobile-100");
            break;
        case NetworkManager::ConnectionSettings::Vlan:
            break;
        case NetworkManager::ConnectionSettings::Vpn:
        case NetworkManager::ConnectionSettings::WireGuard:
            return QStringLiteral("network-vpn");
            break;
        case NetworkManager::ConnectionSettings::Wired:
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                return QStringLiteral("network-wired-activated");
            } else {
                return QStringLiteral("network-wired");
            }
            break;
        case NetworkManager::ConnectionSettings::Wireless:
            if (m_signal == 0 ) {
                if (m_mode == NetworkManager::WirelessSetting::Adhoc || m_mode == NetworkManager::WirelessSetting::Ap) {
                    return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("network-wireless-connected-100") : QStringLiteral("network-wireless-connected-100");
                }
                return (m_securityType <= NetworkManager::NoneSecurity) ? QStringLiteral("network-wireless-connected-100") : QStringLiteral("network-wireless-connected-100");
            } else if (m_signal <= 25) {
                return QStringLiteral("network-wireless-connected-25");
            } else if (m_signal <= 50) {
                return QStringLiteral("network-wireless-connected-50");
            } else if (m_signal <= 75) {
                return QStringLiteral("network-wireless-connected-75");
            } else {
                return QStringLiteral("network-wireless-connected-100");
            }

            break;
        default:
            break;
    }

    if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
        return QStringLiteral("network-wired-activated");
    } else {
        return QStringLiteral("network-wired");
    }
}

NetworkModelItem::ItemType NetworkModelItem::itemType() const
{
    if (!m_devicePath.isEmpty() ||
        m_type == NetworkManager::ConnectionSettings::Bond ||
        m_type == NetworkManager::ConnectionSettings::Bridge ||
        m_type == NetworkManager::ConnectionSettings::Vlan ||
        m_type == NetworkManager::ConnectionSettings::Team ||
        ((NetworkManager::status() == NetworkManager::Connected ||
          NetworkManager::status() == NetworkManager::ConnectedLinkLocal ||
          NetworkManager::status() == NetworkManager::ConnectedSiteOnly) && (m_type == NetworkManager::ConnectionSettings::Vpn || m_type == NetworkManager::ConnectionSettings::WireGuard))) {
        if (m_connectionPath.isEmpty() && m_type == NetworkManager::ConnectionSettings::Wireless) {
            return NetworkModelItem::AvailableAccessPoint;
        } else {
            return NetworkModelItem::AvailableConnection;
        }
    }
    return NetworkModelItem::UnavailableConnection;
}

NetworkManager::WirelessSetting::NetworkMode NetworkModelItem::mode() const
{
    return m_mode;
}

void NetworkModelItem::setMode(const NetworkManager::WirelessSetting::NetworkMode mode)
{
    if (m_mode != mode) {
        m_mode = mode;
        refreshIcon();
    }
}

QString NetworkModelItem::name() const
{
    return m_name;
}

void NetworkModelItem::setName(const QString &name)
{
    if (m_name != name) {
        m_name = name;
        m_changedRoles << NetworkModel::ItemUniqueNameRole << NetworkModel::NameRole;
    }
}

QString NetworkModelItem::originalName() const
{
    if (m_deviceName.isEmpty()) {
        return m_name;
    }

    return QLatin1String("%1 (%2)").arg(m_name).arg(m_deviceName);

    // return m_name % QLatin1String(" (") % m_deviceName % ')';
}

QString NetworkModelItem::sectionType() const
{
    if (m_connectionState == NetworkManager::ActiveConnection::Deactivated) {
        return "Available connections";
    }  else {
        return QString();
    }
}

NetworkManager::WirelessSecurityType NetworkModelItem::securityType() const
{
    return m_securityType;
}

void NetworkModelItem::setSecurityType(NetworkManager::WirelessSecurityType type)
{
    if (m_securityType != type) {
        m_securityType = type;
        m_changedRoles << NetworkModel::SecurityTypeStringRole << NetworkModel::SecurityTypeRole;
        refreshIcon();
    }
}

int NetworkModelItem::signal() const
{
    return m_signal;
}

void NetworkModelItem::setSignal(int signal)
{
    if (m_signal != signal) {
        m_signal = signal;
        m_changedRoles << NetworkModel::SignalRole;
        refreshIcon();
    }
}

bool NetworkModelItem::slave() const
{
    return m_slave;
}

void NetworkModelItem::setSlave(bool slave)
{
    if (m_slave != slave) {
        m_slave = slave;
        m_changedRoles << NetworkModel::SlaveRole;
    }
}

QString NetworkModelItem::specificPath() const
{
    return m_specificPath;
}

void NetworkModelItem::setSpecificPath(const QString &path)
{
    if (m_specificPath != path) {
        m_specificPath = path;
        m_changedRoles << NetworkModel::SpecificPathRole;
    }
}

QString NetworkModelItem::ssid() const
{
    return m_ssid;
}

void NetworkModelItem::setSsid(const QString &ssid)
{
    if (m_ssid != ssid) {
        m_ssid = ssid;
        m_changedRoles << NetworkModel::SsidRole << NetworkModel::UniRole;
    }
}

NetworkManager::ConnectionSettings::ConnectionType NetworkModelItem::type() const
{
    return m_type;
}

QDateTime NetworkModelItem::timestamp() const
{
    return m_timestamp;
}

void NetworkModelItem::setTimestamp(const QDateTime &date)
{
    if (m_timestamp != date) {
        m_timestamp = date;
        m_changedRoles << NetworkModel::TimeStampRole;
    }
}

void NetworkModelItem::setType(NetworkManager::ConnectionSettings::ConnectionType type)
{
    if (m_type != type) {
        m_type = type;
        m_changedRoles << NetworkModel::TypeRole << NetworkModel::ItemTypeRole << NetworkModel::UniRole;

        refreshIcon();
    }
}

QString NetworkModelItem::uni() const
{
    if (m_type == NetworkManager::ConnectionSettings::Wireless && m_uuid.isEmpty()) {
        return m_ssid + '%' + m_devicePath;
    } else {
        return m_connectionPath + '%' + m_devicePath;
    }
}

QString NetworkModelItem::uuid() const
{
    return m_uuid;
}

void NetworkModelItem::setUuid(const QString &uuid)
{
    if (m_uuid != uuid) {
        m_uuid = uuid;
        m_changedRoles << NetworkModel::UuidRole;
    }
}

QString NetworkModelItem::vpnState() const
{
    return UiUtils::vpnConnectionStateToString(m_vpnState);
}

void NetworkModelItem::setVpnState(NetworkManager::VpnConnection::State state)
{
    if (m_vpnState != state) {
        m_vpnState = state;
        m_changedRoles << NetworkModel::VpnState;
    }
}

QString NetworkModelItem::vpnType() const
{
    return m_vpnType;
}

void NetworkModelItem::setVpnType(const QString &type)
{
    if (m_vpnType != type) {
        m_vpnType = type;
        m_changedRoles << NetworkModel::VpnType;
    }
}

qulonglong NetworkModelItem::rxBytes() const
{
    return m_rxBytes;
}

void NetworkModelItem::setRxBytes(qulonglong bytes)
{
    if (m_rxBytes != bytes) {
        m_rxBytes = bytes;
        m_changedRoles << NetworkModel::RxBytesRole;
    }
}

qulonglong NetworkModelItem::txBytes() const
{
    return m_txBytes;
}

void NetworkModelItem::setTxBytes(qulonglong bytes)
{
    if (m_txBytes != bytes) {
        m_txBytes = bytes;
        m_changedRoles << NetworkModel::TxBytesRole;
    }
}

QString NetworkModelItem::ipAddress() const
{
    updateDetails();
    return m_ipAdress;
}

void NetworkModelItem::setIpAddress(const QString address)
{
    m_ipAdress = address;
}

QString NetworkModelItem::router() const
{
    return m_router;
}

void NetworkModelItem::setRouter(const QString router)
{
    m_router = router;
}

QString NetworkModelItem::gateway()
{
    return m_gateway;
}

void NetworkModelItem::setGateway(const QString gateWay)
{
    m_gateway = gateWay;
}

bool NetworkModelItem::operator==(const NetworkModelItem *item) const
{
    if (!item->uuid().isEmpty() && !uuid().isEmpty()) {
        if (item->devicePath() == devicePath() && item->uuid() == uuid()) {
            return true;
        }
    } else if (item->type() == NetworkManager::ConnectionSettings::Wireless && type() == NetworkManager::ConnectionSettings::Wireless) {
        if (item->ssid() == ssid() && item->devicePath() == devicePath()) {
            return true;
        }
    }

    return false;
}

void NetworkModelItem::invalidateDetails()
{
    m_detailsValid = false;
    m_changedRoles << NetworkModel::ConnectionDetailsRole;
}

void NetworkModelItem::updateDetails() const
{
    m_detailsValid = true;
    m_details.clear();

    if (itemType() == NetworkModelItem::UnavailableConnection) {
        return;
    }

    NetworkManager::Device::Ptr device = NetworkManager::findNetworkInterface(m_devicePath);

    // Get IPv[46]Address and related nameservers + IPv4 default gateway
    if (device && device->ipV4Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV4Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV4Config().addresses().first().ip();
            if (!addr.isNull()) {
                m_details << tr("IPv4 Address") << addr.toString();
            }
        }
        if (!device->ipV4Config().gateway().isEmpty()) {
            QString addr = device->ipV4Config().gateway();
            if (!addr.isNull()) {
                m_details << tr("IPv4 Default Gateway") << addr;
            }
        }
        if (!device->ipV4Config().nameservers().isEmpty()) {
            QHostAddress addr = device->ipV4Config().nameservers().first();
            if (!addr.isNull()) {
                m_details << tr("IPv4 Nameserver") << addr.toString();
            }
        }
    }

    if (device && device->ipV6Config().isValid() && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        if (!device->ipV6Config().addresses().isEmpty()) {
            QHostAddress addr = device->ipV6Config().addresses().first().ip();
            if (!addr.isNull()) {
                m_details << tr("IPv6 Address") << addr.toString();
            }
        }
        if (!device->ipV6Config().nameservers().isEmpty()) {
            QHostAddress addr = device->ipV6Config().nameservers().first();
            if (!addr.isNull()) {
                m_details << tr("IPv6 Nameserver") << addr.toString();
            }
        }
    }
    if (m_type == NetworkManager::ConnectionSettings::Wired) {
        NetworkManager::WiredDevice::Ptr wiredDevice = device.objectCast<NetworkManager::WiredDevice>();
        if (wiredDevice) {
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                m_details << tr("Connection speed") << UiUtils::connectionSpeed(wiredDevice->bitRate());
            }
            m_details << tr("MAC Address") << wiredDevice->permanentHardwareAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Wireless) {
        NetworkManager::WirelessDevice::Ptr wirelessDevice = device.objectCast<NetworkManager::WirelessDevice>();
        m_details << tr("Access point (SSID)") << m_ssid;
        if (m_mode == NetworkManager::WirelessSetting::Infrastructure) {
            m_details << tr("Signal strength") << QStringLiteral("%1%").arg(m_signal);
        }
        m_details << tr("Security type") << UiUtils::labelFromWirelessSecurity(m_securityType);
        if (wirelessDevice) {
            if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
                m_details << tr("Connection speed") << UiUtils::connectionSpeed(wirelessDevice->bitRate());
            }
            m_details << tr("MAC Address") << wirelessDevice->permanentHardwareAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Gsm || m_type == NetworkManager::ConnectionSettings::Cdma) {
#if WITH_MODEMMANAGER_SUPPORT
        NetworkManager::ModemDevice::Ptr modemDevice = device.objectCast<NetworkManager::ModemDevice>();
        if (modemDevice) {
            ModemManager::ModemDevice::Ptr modem = ModemManager::findModemDevice(modemDevice->udi());
            if (modem) {
                ModemManager::Modem::Ptr modemNetwork = modem->interface(ModemManager::ModemDevice::ModemInterface).objectCast<ModemManager::Modem>();

                if (m_type == NetworkManager::ConnectionSettings::Gsm) {
                    ModemManager::Modem3gpp::Ptr gsmNet = modem->interface(ModemManager::ModemDevice::GsmInterface).objectCast<ModemManager::Modem3gpp>();
                    if (gsmNet) {
                        m_details << tr("Operator") << gsmNet->operatorName();
                    }
                } else {
                    ModemManager::ModemCdma::Ptr cdmaNet = modem->interface(ModemManager::ModemDevice::CdmaInterface).objectCast<ModemManager::ModemCdma>();
                    m_details << tr("Network ID") << QString("%1").arg(cdmaNet->nid());
                }

                if (modemNetwork) {
                    m_details << tr("Signal Quality") << QString("%1%").arg(modemNetwork->signalQuality().signal);
                    m_details << tr("Access Technology") << UiUtils::convertAccessTechnologyToString(modemNetwork->accessTechnologies());
                }
            }
        }
#endif
    } else if (m_type == NetworkManager::ConnectionSettings::Vpn) {
        m_details << tr("VPN plugin") << m_vpnType;

        if (m_connectionState == NetworkManager::ActiveConnection::Activated) {
            NetworkManager::ActiveConnection::Ptr active = NetworkManager::findActiveConnection(m_activeConnectionPath);
            NetworkManager::VpnConnection::Ptr vpnConnection;

            if (active) {
                vpnConnection = NetworkManager::VpnConnection::Ptr(new NetworkManager::VpnConnection(active->path()), &QObject::deleteLater);
            }

            if (vpnConnection && !vpnConnection->banner().isEmpty()) {
                m_details << tr("Banner") << vpnConnection->banner().simplified();
            }
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bluetooth) {
        NetworkManager::BluetoothDevice::Ptr bluetoothDevice = device.objectCast<NetworkManager::BluetoothDevice>();
        if (bluetoothDevice) {
            m_details << tr("Name") << bluetoothDevice->name();
            if (bluetoothDevice->bluetoothCapabilities() == NetworkManager::BluetoothDevice::Pan) {
                m_details << tr("Capabilities") << QStringLiteral("PAN");
            } else if (bluetoothDevice->bluetoothCapabilities() == NetworkManager::BluetoothDevice::Dun) {
                m_details << tr("Capabilities") << QStringLiteral("DUN");
            }
            m_details << tr("MAC Address") << bluetoothDevice->hardwareAddress();

        }
    } else if (m_type == NetworkManager::ConnectionSettings::Infiniband) {
        NetworkManager::InfinibandDevice::Ptr infinibandDevice = device.objectCast<NetworkManager::InfinibandDevice>();
        m_details << tr("Type") << tr("Infiniband");
        if (infinibandDevice) {
            m_details << tr("MAC Address") << infinibandDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bond) {
        NetworkManager::BondDevice::Ptr bondDevice = device.objectCast<NetworkManager::BondDevice>();
        m_details << tr("Type") << tr("Bond");
        if (bondDevice) {
            m_details << tr("MAC Address") << bondDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Bridge) {
        NetworkManager::BridgeDevice::Ptr bridgeDevice = device.objectCast<NetworkManager::BridgeDevice>();
        m_details << tr("Type") << tr("Bridge");
        if (bridgeDevice) {
            m_details << tr("MAC Address") << bridgeDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Vlan) {
        NetworkManager::VlanDevice::Ptr vlanDevice = device.objectCast<NetworkManager::VlanDevice>();
        m_details << tr("Type") << tr("Vlan");
        if (vlanDevice) {
            m_details << tr("Vlan ID") << QString("%1").arg(vlanDevice->vlanId());
            m_details << tr("MAC Address") << vlanDevice->hwAddress();
        }
    } else if (m_type == NetworkManager::ConnectionSettings::Adsl) {
        m_details << tr("Type") << tr("Adsl");
    }
      else if (m_type == NetworkManager::ConnectionSettings::Team) {
        NetworkManager::TeamDevice::Ptr teamDevice = device.objectCast<NetworkManager::TeamDevice>();
        m_details << tr("Type") << tr("Team");
        if (teamDevice) {
            m_details << tr("MAC Address") << teamDevice->hwAddress();
        }
    }

    if (device && m_connectionState == NetworkManager::ActiveConnection::Activated) {
        m_details << tr("Device") << device->interfaceName();
    }
}
