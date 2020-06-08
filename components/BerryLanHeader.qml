import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


ColumnLayout {
    id: root
    spacing: 0

    property string text

    property int index

    property bool backButtonVisible: false

    property bool nextButtonVisible: false

    property bool selectAllButtonVisible: false

    signal backClicked()

    signal nextClicked()

    signal selectAllClicked()

    RowLayout {
        Layout.margins: app.margins

        /*ColorIcon {
            Layout.preferredHeight: app.iconSize * .8
            Layout.preferredWidth: height
            name: "../images/back.svg"
            visible: root.backButtonVisible
            MouseArea {
                anchors.fill: parent
                onClicked: root.backClicked()
            }
        }*/

        Button {
            id: back
            text: qsTr("back")
            visible: root.backButtonVisible
            onClicked:{
                swipeView.currentIndex--
            }
        }

        Button {
            id: selectAll
            text: qsTr("select all")
            visible: root.selectAllButtonVisible
            onClicked:{
                    for (index=0; index < discovery.deviceInfos.count ; index++){
                        discovery.deviceInfos.set(index, true)
                    }
                    while(!discovery.deviceInfos.get(networkManager.deviceIndex).selected){
                        networkManager.deviceIndex = networkManager.deviceIndex + 1;
                        print("Hallo: ", networkManager.deviceIndex);
                    }
                    print("Hallo2: ", networkManager.deviceIndex);
                    networkManager.bluetoothDeviceInfo = discovery.deviceInfos.get(networkManager.deviceIndex);
                    networkManager.connectDevice();
                    swipeView.currentIndex++
            }
        }

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

        Button {
            id: next
            text: qsTr("next")
            visible: root.nextButtonVisible
            onClicked:{
                while(!discovery.deviceInfos.get(networkManager.deviceIndex).selected){
                    networkManager.deviceIndex = networkManager.deviceIndex + 1;
                    print("Hallo: ", networkManager.deviceIndex);
                }
                print("Hallo2: ", networkManager.deviceIndex);
                networkManager.bluetoothDeviceInfo = discovery.deviceInfos.get(networkManager.deviceIndex);
                networkManager.connectDevice();
                swipeView.currentIndex++;
            }
        }

        /*ColorIcon {
            Layout.preferredHeight: app.iconSize * .8
            Layout.preferredWidth: height
            name: "../images/next.svg"
            visible: root.nextButtonVisible
            MouseArea {
                anchors.fill: parent
                onClicked: root.nextClicked()
            }
        }
        Item { // just to keep the label centered
            Layout.preferredHeight: app.iconSize * .8
            Layout.preferredWidth: height
            visible: root.backButtonVisible
        }
        Item { // just to keep the label centered
            Layout.preferredHeight: app.iconSize * .8
            Layout.preferredWidth: height
            visible: root.nextButtonVisible
        }*/
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        color: "#D8D8D8"

    }
}

