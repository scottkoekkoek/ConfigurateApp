/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                         *
 *  Copyright (C) 2018 Simon Stuerz <simon.stuerz@guh.io>                  *
 *                                                                         *
 *  This file is part of nymea:app                                         *
 *                                                                         *
 *  This library is free software; you can redistribute it and/or          *
 *  modify it under the terms of the GNU Lesser General Public             *
 *  License as published by the Free Software Foundation; either           *
 *  version 2.1 of the License, or (at your option) any later version.     *
 *                                                                         *
 *  This library is distributed in the hope that it will be useful,        *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU      *
 *  Lesser General Public License for more details.                        *
 *                                                                         *
 *  You should have received a copy of the GNU Lesser General Public       *
 *  License along with this library; If not, see                           *
 *  <http://www.gnu.org/licenses/>.                                        *
 *                                                                         *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include "bluetoothdeviceinfos.h"

#include <QDebug>

BluetoothDeviceInfos::BluetoothDeviceInfos(QObject *parent) : QAbstractListModel(parent)
{
}

QList<BluetoothDeviceInfo *> BluetoothDeviceInfos::deviceInfos()
{
    return m_deviceInfos;
}

int BluetoothDeviceInfos::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_deviceInfos.count();
}

QVariant BluetoothDeviceInfos::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_deviceInfos.count())
        return QVariant();

    BluetoothDeviceInfo *deviceInfo = m_deviceInfos.at(index.row());
    if (role == BluetoothDeviceInfoRoleName) {
        return deviceInfo->name();
    } else if (role == BluetoothDeviceInfoRoleAddress) {
        return deviceInfo->address();
    } else if (role == BluetoothDeviceInfoRoleLe) {
        return deviceInfo->isLowEnergy();
    } else if(role == BluetoothDeviceInfoRoleSelected){
        return deviceInfo->selected();
    } else if(role == NetwerkInfoIPAddress){
        return deviceInfo->ipAddress();
    }

    return QVariant();
}


bool BluetoothDeviceInfos::setData(const QModelIndex &index, const QVariant &value, int role)
{
    qDebug() << "Stap 1";
    if (role == Qt::EditRole) {
        if (!checkIndex(index))
            return false;
        //save value from editor to member m_gridData
        BluetoothDeviceInfo *deviceInfo = m_deviceInfos.at(index.row());
        //for presentation purposes only: build and emit a joined string
        if(role == BluetoothDeviceInfoRoleSelected){
            qDebug() << "Stap 3";
            deviceInfo->setSelected(value.toBool());
        } else if(role == NetwerkInfoIPAddress){
            qDebug() << "Stap 4";
            deviceInfo->setIpAddress(value.toString());
        }
        //emit editCompleted();
        emit dataChanged();
        return true;
    }
    return false;
}

int BluetoothDeviceInfos::count() const
{
    return m_deviceInfos.count();
}


BluetoothDeviceInfo *BluetoothDeviceInfos::get(int index) const
{
    if (index >= m_deviceInfos.count() || index < 0)
        return Q_NULLPTR;

    return m_deviceInfos.at(index);
}

BluetoothDeviceInfo *BluetoothDeviceInfos::set(int index, bool selected)
{
    qDebug() << "Index: " << index;
    qDebug() << "Selected: " << selected;
    if (index >= m_deviceInfos.count() || index < 0) {
        return Q_NULLPTR;
    }
    BluetoothDeviceInfo *bdi = m_deviceInfos.at(index);
    bdi->setSelected(selected);
    emit countChanged();
    return bdi;
}

void BluetoothDeviceInfos::addBluetoothDeviceInfo(BluetoothDeviceInfo *deviceInfo)
{
    qDebug() << "Adding device" << deviceInfo->name();
    deviceInfo->setParent(this);
    beginInsertRows(QModelIndex(), m_deviceInfos.count(), m_deviceInfos.count());
    m_deviceInfos.append(deviceInfo);
    endInsertRows();
    emit countChanged();
}

void BluetoothDeviceInfos::removeBluetoothDeviceInfo(int index)
{
    beginRemoveRows(QModelIndex(), index, index);
    removeRow(index, QModelIndex());
    endRemoveRows();

    emit countChanged();
}

void BluetoothDeviceInfos::clearModel()
{
    beginResetModel();
    qDeleteAll(m_deviceInfos);
    m_deviceInfos.clear();
    endResetModel();
    emit countChanged();
}

QHash<int, QByteArray> BluetoothDeviceInfos::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[BluetoothDeviceInfoRoleName] = "name";
    roles[BluetoothDeviceInfoRoleAddress] = "address";
    roles[BluetoothDeviceInfoRoleLe] = "lowEnergy";
    roles[BluetoothDeviceInfoRoleSelected] = "selected";
    roles[NetwerkInfoIPAddress] = "ipAddress";
    return roles;
}
