import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtWebView 1.1

Page {
    header: BerryLanHeader {
        text: qsTr("About CLB Config")
        backButtonVisible: true
        onBackClicked: pageStack.pop()
        nextButtonVisible: false
        onNextClicked: pageStack.pop()
    }
    ColumnLayout {
        anchors.fill: parent


        Label {
            visible: true
            Layout.fillWidth: true
            Layout.margins: app.margins
            text: "Version: 1.0.0"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: app.largeFont
            font.bold: false
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

        }
        Label {
            visible: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: app.margins
            text: "CLB Holding BV"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: app.largeFont
            font.bold: false
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

        }
        Label {
            visible: true
            Layout.fillWidth: true
            Layout.margins: app.margins
            text: "Based on open source app Nymea"
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: app.largeFont
            font.bold: true
            horizontalAlignment: Text.AlignHCenter

                }


        Item {
            id: contentItemContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

}
