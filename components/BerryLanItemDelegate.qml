import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

ItemDelegate {
    id: root
    height: 60

    leftPadding: app.margins
    rightPadding: app.margins
    topPadding: 0
    bottomPadding: 0

    property string iconSource

    contentItem: ColumnLayout {
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: index === 0 ? 1 : 0
            color: Material.foreground
        }

        RowLayout {

            //Icon by the list items. On screen one with bluetooth devices is the bluetooth icon visible.
            //On screen three you get a list with SSIDs and icons how strong the signal is.
            ColorIcon {
                Layout.preferredHeight: app.iconSize
                Layout.preferredWidth: app.iconSize
                name: root.iconSource
            }

            //The names on screen one with bluetooth devices and on screen three SSID names.
            Label {
                Layout.fillWidth: true
                text: root.text
                font.pixelSize: app.largeFont
                elide: Text.ElideRight
            }

            //Create on screen one a box right. When you click on the box it is checked
            //and selected to configurate later in the proces.
            CheckBox {
                id: checkbox
                visible: swipeView.currentIndex == 1
                onClicked:{
                    discovery.deviceInfos.set(index, checkState)
                    print("After setting selected is the state: ", discovery.deviceInfos.get(index).selected)
                }
            }
            Label {
                visible: swipeView.currentIndex == 6
                Layout.fillWidth: true
                text: networkManager.bluetoothDeviceInfo.connectedNetwork ? "Not connected" : ipAddress
                font.pixelSize: app.largeFont
                elide: Text.ElideRight
            }
        }

        //Horizontale line between the bluetooth devices in the list. To create for each device a box.
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Material.foreground
        }
    }
}
