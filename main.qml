import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import BerryLan 1.0
import "components"

ApplicationWindow {
    id: app
    visible: true
    width: 320
    height: 480
    title: qsTr("BerryLan")

    Material.foreground: "#011627"
    Material.background: "#fdfffc"
    Material.accent: colorTint

    property int iconSize: 32
    property int margins: 6
    property int largeFont: 20
    property int smallFont: 12
    property int index
    property int selectedCount: 0
    property int currentCount: 0
    property string sidd
    property string password
    property bool busy: false
    property string colorTint: "#87ceff"
    property string colorGray: "#D8D8D8"

    BluetoothDiscovery {
        id: discovery
        discoveryEnabled: swipeView.currentIndex <= 1
        onBluetoothEnabledChanged: {
            if (!bluetoothEnabled) {
                swipeView.currentIndex = 0;
            }
        }
    }

    NetworkManagerController {
        id: networkManager
    }

    QtObject {
        id: d
        property var currentAP: null
        readonly property bool accessPointMode: networkManager.manager && networkManager.manager.wirelessDeviceMode == WirelessSetupManager.WirelessDeviceModeAccessPoint
    }

    Connections {
        target: discovery.deviceInfos
        onCountChanged: {
            if (swipeView.currentItem === discoveringView && discovery.deviceInfos.count > 0) {
                swipeView.currentIndex++
            }
        }
    }

    Connections {
        target: networkManager.manager
        onInitializedChanged: {
            print("Start onInitializedChanged");
            print("initialized changed", networkManager.manager.initialized)
            // Als ik bij volgende device ben, dan zet wireless van BluetoothDeviceInfo
            // Als
            print("Busy: ", busy);
            if (networkManager.manager.initialized) {
                if(busy) {
                print("Verbonden!");
                print("AccesPoint Avaiable: ", networkManager.manager.accessPointModeAvailable);
                print("SSID: ", ssidTextField.text);
                print("Password: ", passwordTextField.text);
                networkManager.manager.connectWirelessNetwork(ssidTextField.text, passwordTextField.text);
                print("Ingevoerd ssid");
                }
                else{
                    print("Volgende 1");
                    swipeView.currentIndex++;
                }
            } else {
                if (busy){
                    print("Connectie is gesloten");
                    print("Index ervoor: ",networkManager.deviceIndex);
                    networkManager.deviceIndex = networkManager.deviceIndex + 1;
                    if (discovery.deviceInfos.count <= networkManager.deviceIndex){
                        print("Klaar! uit init");
                        busy = false
                        print("Volgende 2");                        
                        swipeView.currentIndex++;
                    }
                    print("Index erna: ",networkManager.deviceIndex);
                    networkManager.bluetoothDeviceInfo = discovery.deviceInfos.get(networkManager.deviceIndex);
                    networkManager.connectDevice();
                    currentCount++;

                }
                else{
                    swipeView.currentIndex = 0;
                }
            }
        }

        onConnectedChanged: {
            print("Start onConnectedChanged")
            print("connectedChanged", networkManager.manager.connected)
            if (!networkManager.manager.connected) {
                if (swipeView.currentIndex == 5){
                    busy = true;
                }
                else{
                    swipeView.currentIndex = 0;
                }
            }
        }

        onNetworkStatusChanged: {
            print("Network status changed:", networkManager.manager.networkStatus)
            if (swipeView.currentItem === connectingToWiFiView) {
                if (networkManager.manager.networkStatus === WirelessSetupManager.NetworkStatusGlobal) {
                    print("Volgende 3");
                    swipeView.currentIndex++;
                } else {
                    print("UNHANDLED Network status change:", networkManager.manager.networkStatus  )
                }

            }
        }
        onWirelessStatusChanged: {
            print("Wireless status changed:", networkManager.manager.networkStatus)
            if (swipeView.currentItem === connectingToWiFiView) {
                if (networkManager.manager.wirelessStatus === WirelessSetupManager.WirelessStatusActivated) {
                    print("Volgende 4");
                    swipeView.currentIndex++;
                }
                if (networkManager.manager.wirelessStatus === WirelessSetupManager.WirelessStatusFailed) {
                    connectingToWiFiView.running = false
                    connectingToWiFiView.text = qsTr("Sorry, the password is wrong.")
                    connectingToWiFiView.buttonText = qsTr("Try again")
                }
            }
        }

        onErrorOccurred: {
            if (swipeView.currentItem === connectingToWiFiView) {
                connectingToWiFiView.running = false
                connectingToWiFiView.text = qsTr("Sorry, an unexpected error happened.")
                connectingToWiFiView.buttonText = qsTr("Try again")
            }
        }
    }

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: BerryLanPage {
            title: {
                switch (swipeView.currentIndex) {
                case 0:
                case 1:
                case 2:
                    return qsTr("Devices")
                case 3:
                    return qsTr("Network")
                case 4:
                    return qsTr("Login")
                case 5:
                    return qsTr("Connecting")
                case 6:
                    return qsTr("Connected")
                }
            }

            backButtonVisible: swipeView.currentIndex === 4

            nextButtonVisible: swipeView.currentIndex === 1

            selectAllButtonVisible: swipeView.currentIndex === 1

            onHelpClicked: swipeView.currentIndex++

            step: {
                switch (swipeView.currentIndex) {
                case 0:
                case 1:
                    return 0;
                case 2:
                    return 3;
                case 3:
                    if (!networkManager.manager) {
                        return 2;
                    }
                    if (networkManager.manager.accessPoints.count == 0) {
                        return 3;
                    }
                    return 4;
                case 4:
                    for(index = 0 ; index < discovery.deviceInfos.count ; index++){
                        if(discovery.deviceInfos.get(index).selected){
                            selectedCount++;
                        }
                    }
                    return 4;
                case 5:
                    if (networkManager.manager.wirelessStatus < WirelessSetupManager.WirelessStatusConfig) {
                        print("hoi");
                        return 5;
                    }
                    print("Connectie gaat sluiten");
                    busy = true;
                    networkManager.manager.disconnectDevice();

                    return 5;
                case 6:
                    return 8;
                }
            }

            content: SwipeView {
                id: swipeView
                anchors.fill: parent
                interactive: false

                // 0
                WaitView {
                    id: discoveringView
                    height: swipeView.height
                    width: swipeView.width
                    text: !discovery.bluetoothAvailable
                          ? qsTr("Bluetooth doesn't seem to be available on this device. BerryLan requires a working Bluetooth connection.")
                          : !discovery.bluetoothEnabled
                            ? qsTr("Bluetooth seems to be disabled. Please enable Bluetooth on your device in order to use BerryLan.")
                            : qsTr("Searching for your\nRaspberry Pi")
                }

                // 1
                ListView {
                    id: discoveryListView
                    height: swipeView.height
                    width: swipeView.width
                    model: discovery.deviceInfos
                    clip: true
                    ColorIcon {
                        Layout.preferredHeight: app.iconSize
                        Layout.preferredWidth: app.iconSize
                        name: "../images/next.svg"
                    }
                    delegate: BerryLanItemDelegate {
                        width: parent.width
                        text: name
                        iconSource: "../images/bluetooth.svg"
                    }

                }

                // 2
                WaitView {
                    id: connectingToPiView
                    height: swipeView.height
                    width: swipeView.width
                    text: qsTr("Connecting to your Raspberry Pi")
                }

                // 3
                ColumnLayout {
                    height: swipeView.height
                    width: swipeView.width

                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        id: apSelectionListView
                        model: WirelessAccessPointsProxy {
                            id: accessPointsProxy
                            accessPoints: networkManager.manager ? networkManager.manager.accessPoints : null
                        }
                        clip: true

                        delegate: BerryLanItemDelegate {
                            width: parent.width
                            text: model.ssid
                            iconSource: model.signalStrength > 66
                                        ? "../images/wifi-100.svg"
                                        : model.signalStrength > 33
                                          ? "../images/wifi-66.svg"
                                          : model.signalStrength > 0
                                            ? "../images/wifi-33.svg"
                                            : "../images/wifi-0.svg"

                            onClicked: {
                                currentCount++;
                                print("Connect to ", model.ssid, " --> ", model.macAddress)
                                d.currentAP = accessPointsProxy.get(index);
                                ssidTextField.text = d.currentAP.ssid;
                                if (!d.currentAP.isProtected) {
                                    networkManager.manager.connectWirelessNetwork(d.currentAP.ssid)
                                    swipeView.currentIndex++;
                                }
                                swipeView.currentIndex++;
                            }
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        visible: networkManager.manager.accessPointModeAvailable
                        text: qsTr("Open Access Point")
                        onClicked: {
                            swipeView.currentIndex++
                        }
                    }
                }


                // 4
                Item {
                    id: authenticationView
                    width: swipeView.width
                    height: swipeView.height
                    ColumnLayout {
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: - swipeView.height / 4
                        width: app.iconSize * 8
                        spacing: app.margins
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Name")
                            visible: !d.currentAP
                        }

                        TextField {
                            id: ssidTextField
                            Layout.fillWidth: true
                            visible: !d.currentAP
                            maximumLength: 32
                            onAccepted: {
                                passwordTextField.focus = true
                            }
                        }

                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Password")
                        }

                        RowLayout {
                            TextField {
                                id: passwordTextField
                                Layout.fillWidth: true
                                maximumLength: 64
                                property bool showPassword: false
                                echoMode: showPassword ? TextInput.Normal : TextInput.Password
                                onAccepted: {
                                    okButton.clicked()
                                }
                            }

                            ColorIcon {
                                Layout.preferredHeight: app.iconSize
                                Layout.preferredWidth: app.iconSize
                                name: "../images/eye.svg"
                                color: passwordTextField.showPassword ? colorTint : keyColor
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: passwordTextField.showPassword = !passwordTextField.showPassword
                                }
                            }
                        }

                        Button {
                            id: okButton
                            Layout.fillWidth: true
                            text: qsTr("OK")
                            enabled: passwordTextField.displayText.length >= 8
                            onClicked: {
                                if (d.currentAP) {
                                    connectingToWiFiView.text = qsTr("Connecting the Raspberry Pi to %1").arg(d.currentAP.ssid);
                                    networkManager.manager.connectWirelessNetwork(d.currentAP.ssid, passwordTextField.text)
                                    sidd = d.currentAP.ssid;
                                    password = passwordTextField.text;
                                } else {
                                    connectingToWiFiView.text = qsTr("Opening access point \"%1\" on the Raspberry Pi").arg(ssidTextField.text);
                                    networkManager.manager.startAccessPoint(ssidTextField.text, passwordTextField.text)
                                }
                                connectingToWiFiView.buttonText = "";
                                connectingToWiFiView.running = true

                                swipeView.currentIndex++
                            }
                        }
                    }
                }

                // 5
                WaitView {
                    id: connectingToWiFiView
                    height: swipeView.height
                    width: swipeView.width

                    onButtonClicked: {
                        swipeView.currentIndex--;
                        if (!d.currentAP.isProtected) {
                            swipeView.currentIndex--;
                        }
                    }
                }

                // 6
                Item {
                    id: resultsView
                    height: swipeView.height
                    width: swipeView.width

                    ColumnLayout {
                        anchors.fill: parent
                        Label {
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
                        Button {
                            Layout.alignment: Qt.AlignHCenter
                            visible: d.accessPointMode
                            text: qsTr("Close access point")
                            onClicked: {
                                networkManager.manager.disconnectWirelessNetwork();
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            ColumnLayout {
                                anchors.centerIn: parent
                                width: parent.width
                                spacing: app.margins * 4
                                Label {
                                    text: qsTr("Thanks for using the app!")
                                    font.pixelSize: app.largeFont
                                    Layout.fillWidth: true
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                }
                                ColorIcon {
                                    Layout.preferredHeight: app.iconSize
                                    Layout.preferredWidth: app.iconSize
                                    Layout.alignment: Qt.AlignHCenter
                                    name: "../images/github.svg"

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            Qt.openUrlExternally("https://github.com/nymea/berrylan")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
