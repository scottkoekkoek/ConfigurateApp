import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Page {
    id: root
    property int step: 0
    property bool backButtonVisible: false
    property bool nextButtonVisible: false
    property bool selectAllButtonVisible: false

    property alias content: contentItemContainer.data

    signal helpClicked()
    signal backClicked()
    signal nextClicked()
    signal selectAllClicked()

    header: BerryLanHeader {
        text: root.title

        //Looks in main.qml when the buttons are visble and when not.
        backButtonVisible: root.backButtonVisible
        nextButtonVisible: root.nextButtonVisible
        selectAllButtonVisible: root.selectAllButtonVisible

        //Get a signal from main.qml when th user clicked on the button.
        onBackClicked: root.backClicked()
        onNextClicked: root.nextClicked()
        onSelectAllClicked: root.selectAllClicked()
    }

    //The status view with animation and loading proces.
    ColumnLayout {
        anchors.fill: parent

        StatusView {
            Layout.fillWidth: true
            step: root.step
        }
        Label {
            visible: swipeView.currentIndex == 6
            Layout.fillWidth: true
            Layout.margins: app.margins
            text: "All the "+selectedCount+" Wamm(s) are configurated!"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: app.largeFont
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    clipBoard.text = networkManager.manager.currentConnection.hostAddress
                    parent.ToolTip.show(qsTr("IP address copied to clipboard."), 2000)
                }
            }
        }

        Item {
            id: contentItemContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    footer: Item {
        id: footer
        height: app.iconSize * 1.5 + ((systemProductType === "ios" && Screen.height === 812) ? 10 : 0)
        //A button that shows on all the pages in them app. When you will go back to the start with any reason,
        //you can press the button and you go back.
            ColorIcon {
                        width: app.iconSize
                        height: app.iconSize
                        anchors { left: parent.left; top: parent.top; margins: app.margins }
                        name: "../images/help.svg"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.helpClicked()
                        }
                    }
            ColorIcon {
                width: app.iconSize
                height: app.iconSize
                anchors { right: parent.right; top: parent.top; margins: app.margins }
                name: "../images/refresh.svg"

                //When you press the button you go to the start. When your current swipeview is higher
                //than three will first disconnnect from network, after disconnect network your device disconnect and you go to swipeview zero.
                //When your swipeview is three will only disconnect your device. If your swipeview is not higher than two you only go to the begin.
                MouseArea {
                    anchors.fill: parent
                    onClicked:{
                        print("You go to the start from swipeview ", swipeView.currentIndex)
                        if(swipeView.currentIndex > 2){
                            if(swipeView.currentIndex > 3){
                                networkManager.manager.disconnectWirelessNetwork()
                            }
                            networkManager.manager.disconnectDevice()
                        }
                        discovery.deviceInfos.clearModel()
                        networkManager.deviceIndex = 0
                        swipeView.currentIndex = 0
                        print("Counter go to 0")
                        selectedCount == 0
                   }
                }
            }
    }
}
