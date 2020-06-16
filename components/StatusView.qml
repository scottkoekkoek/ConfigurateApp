import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import BerryLan 1.0
import QtQuick.Controls.Material 2.2

Item {
    id: root
    implicitHeight: app.iconSize * 4

    property int step: 0

    //Gives the status in the process.
    RowLayout {
        anchors.centerIn: parent

        //Bluetooth devices status.
        Rectangle {
            Layout.preferredWidth: app.iconSize * 1.5
            Layout.preferredHeight: app.iconSize * 1.5
            radius: height / 2
            color: colorGray
            BerryLanBusyIndicator {
                anchors.fill: parent
                visible: step === 0
                color: Material.accent
                penWidth: 3
            }

            Rectangle {
                anchors.centerIn: parent
                height: root.step > 1 ? parent.height : 0
                width: height
                radius: height / 2
                color: colorTint
                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
            }

            ColorIcon {
                height: app.iconSize
                width: app.iconSize
                name: "../images/bluetooth.svg"
                anchors.centerIn: parent
                color: "white"
            }
            border.width: root.step > 0 ? 3 : 0
            border.color: colorTint

            MouseArea {
                anchors.fill: parent
                onClicked: root.step--
            }

        }
        Rectangle {
            Layout.preferredWidth: app.iconSize
            Layout.preferredHeight: 4
            color: colorGray
            Rectangle {
                anchors.fill: parent
                anchors.rightMargin:  root.step > 2 ? 0 : parent.width
                color: colorTint
                Behavior on anchors.rightMargin {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
            }
        }

        //Network status.
        Rectangle {
            Layout.preferredWidth: app.iconSize * 1.5
            Layout.preferredHeight: app.iconSize * 1.5
            radius: height / 2
            color: colorGray

            BerryLanBusyIndicator {
                anchors.fill: parent
                visible: step === 3
                color: Material.accent
                penWidth: 3
            }

            Rectangle {
                anchors.centerIn: parent
                height: root.step > 4 ? parent.height : 0
                width: height
                radius: height / 2
                color: colorTint
                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
            }
            ColorIcon {
                height: app.iconSize
                width: app.iconSize
                name: "../images/wifi.svg"
                anchors.centerIn: parent
                color: "white"
            }
            border.width: root.step > 3 ? 3 : 0
            border.color: colorTint
        }
        Rectangle {
            Layout.preferredWidth: app.iconSize
            Layout.preferredHeight: 4
            color: colorGray
            Rectangle {
                anchors.fill: parent
                anchors.rightMargin:  root.step > 5 ? 0 : parent.width
                color: colorTint
                Behavior on anchors.rightMargin {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
            }
        }
        //Connected status.
        Rectangle {
            Layout.preferredWidth: app.iconSize * 1.5
            Layout.preferredHeight: app.iconSize * 1.5
            radius: height / 2
            color: colorGray
            BerryLanBusyIndicator {
                anchors.fill: parent
                visible: step === 6
                color: Material.accent
                penWidth: 3
            }
            Rectangle {
                anchors.centerIn: parent
                height: root.step > 7 ? parent.height : 0
                width: height
                radius: height / 2
                color: colorTint
                Behavior on height {
                    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
                }
            }
            ColorIcon {
                height: app.iconSize
                width: app.iconSize
                name: "../images/link.svg"
                anchors.centerIn: parent
                color: "white"
            }
            border.width: root.step > 6 ? 3 : 0
            border.color: colorTint

            MouseArea {
                anchors.fill: parent
                onClicked: root.step++
            }
        }
    }
}
