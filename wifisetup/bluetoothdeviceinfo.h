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

#ifndef BLUETOOTHDEVICEINFO_H
#define BLUETOOTHDEVICEINFO_H

#include <QList>
#include <QObject>
#include <QBluetoothAddress>
#include <QBluetoothDeviceInfo>


class BluetoothDeviceInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name NOTIFY deviceChanged)
    Q_PROPERTY(QString address READ address NOTIFY deviceChanged)
    Q_PROPERTY(bool selected READ selected WRITE setSelected NOTIFY selectedChanged)
    Q_PROPERTY(bool ipAddress READ ipAddress WRITE setIpAddress NOTIFY ipAddressChanged)

public:
    BluetoothDeviceInfo();
    BluetoothDeviceInfo(const QBluetoothDeviceInfo &deviceInfo);

    QString address() const;
    QString name() const;
    bool isLowEnergy() const;
    bool selected();
    void setSelected(bool selected);
    bool ipAddress();
    void setIpAddress(bool ipAddress);

    QBluetoothDeviceInfo getBluetoothDeviceInfo() const;
    void setBluetoothDeviceInfo(const QBluetoothDeviceInfo &deviceInfo);

signals:
    void deviceChanged();
    void selectedChanged();
    void ipAddressChanged();

private:
    QBluetoothDeviceInfo m_deviceInfo;
    bool selected_;
    bool ipAddress_;
};

#endif // BLUETOOTHDEVICEINFO_H
