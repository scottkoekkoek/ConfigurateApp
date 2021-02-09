import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


ColumnLayout {
    id: root
    spacing: 0

    property string text

    property int index

    property int selectedCount: 0

    property bool backButtonVisible: false

    property bool nextButtonVisible: false

    property bool selectAllButtonVisible: false

    signal backClicked()

    signal nextClicked()

    signal selectAllClicked()

    RowLayout {
        Layout.margins: app.margins

        //Back Button for go back from password field to the SSID list. Visible on screen four.
        Button {
            id: back
            text: qsTr("back")
            visible: root.backButtonVisible
            onClicked:{
                print("I go back from swipeview ", swipeView.currentIndex, " to swipeview ", swipeView.currentIndex - 1)
                //swipeView.currentIndex--
                root.backClicked()
            }
        }

        //Select All bluetooth devices button. Set all bluetooth devices in the list on selected and go automatic
        //to the next page where made the first connection. Visible on screen one.
        Button {
            id: selectAll
            text: qsTr("select all")
            visible: root.selectAllButtonVisible && discovery.deviceInfos.count > 0
            onClicked:{
                    //Set all the devices on selected true.
                    for (index=0; index < discovery.deviceInfos.count ; index++){
                        discovery.deviceInfos.set(index, true)
                        print("Device with index ", index, " is selected to true")
                    }
                    //Connect to the first device.
                    networkManager.bluetoothDeviceInfo = discovery.deviceInfos.get(0)
                    print("Connection made with the first WAMM")
                    networkManager.connectDevice();
                    swipeView.currentIndex++
            }
        }

        //Shows the current page name like Devices, connecting, etc...
        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: app.iconSize * .8
            text: root.text.toUpperCase()
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: app.largeFont
            font.family: "Rajdhani"
            font.weight: Font.DemiBold
        }

        //The next Button can used to go to the next page. This button is visible on screen one.
        //When you have a selection of devices, you can go to the next step.
        Button {
            id: next
            text: qsTr("next")
            visible: root.nextButtonVisible && discovery.deviceInfos.count > 0
            onClicked:{
                //Search the first selected device to connect.
                print("deviceindex = ", networkManager.deviceIndex)
                //print("Selected = ", discovery.deviceInfos.get(networkManager.deviceIndex).selected)
                while(!discovery.deviceInfos.get(networkManager.deviceIndex).selected){
                    //if(discovery.deviceInfos.get(networkManager.deviceIndex).selected !== NULL){
                        networkManager.deviceIndex = networkManager.deviceIndex + 1;
                    //}
                }
                print("Device with the index ", networkManager.deviceIndex, " is the first WAMM to connect")
                networkManager.bluetoothDeviceInfo = discovery.deviceInfos.get(networkManager.deviceIndex);
                networkManager.connectDevice();
                swipeView.currentIndex++;
            }
        }
    }

    //Horizontale line between the bluetooth devices in the list. To create for each device a box.
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        color: colorGray

    }
}
