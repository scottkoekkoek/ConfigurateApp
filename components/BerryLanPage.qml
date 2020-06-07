import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3

Page {
    id: root
    property int step: 0
    property bool backButtonVisible: false
    property bool nextButtonVisible: false

    property alias content: contentItemContainer.data

    signal helpClicked()
    signal backClicked()
    signal nextClicked()

    header: BerryLanHeader {
        text: root.title
        backButtonVisible: root.backButtonVisible
        onBackClicked: root.backClicked()
        nextButtonVisible: root.nextButtonVisible
        onNextClicked: root.nextClicked()
    }

    ColumnLayout {
        anchors.fill: parent

        StatusView {
            Layout.fillWidth: true
            step: root.step
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
        RowLayout {
            anchors { top: parent.top; margins: app.margins; horizontalCenter: parent.horizontalCenter }
            height: app.iconSize
            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: app.iconSize * .8
                text: qsTr("an open source tool by")
                font.pixelSize: app.smallFont
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
            }
            Image {
                Layout.preferredHeight: app.iconSize
                sourceSize.height: app.iconSize
                source: "../images/nymea.svg"
                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally("https://nymea.io")
                }
            }
            Label {
                Layout.preferredHeight: app.iconSize * .8
                text: "n y m e a     "
                font.pixelSize: app.smallFont
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
            }
        }
        ColorIcon {
            width: app.iconSize
            height: app.iconSize
            anchors { right: parent.right; top: parent.top; margins: app.margins }
            name: "../images/refresh.svg"

            MouseArea {
                anchors.fill: parent
                onClicked:{
                    networkManager.manager.disconnectWirelessNetwork();
                    networkManager.manager.disconnectDevice();
                    swipeView.currentIndex == 0;
                }
            }
        }
    }
}
