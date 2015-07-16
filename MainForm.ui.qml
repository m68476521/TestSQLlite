import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

Item {

    property alias button3: button3
    property alias button2: button2
    property alias button1: button1
    property alias textField1: textField1.text
    property alias textField2: textField2.text
    property alias textField33: textField3.text

    width: 640
    height: 480

    RowLayout {

        id: rowLayout

        anchors.verticalCenterOffset: -95
        anchors.horizontalCenterOffset: -9
        anchors.centerIn: parent

        Button {
            id: button1
            text: qsTr("Inserting")
        }

        Button {
            id: button2
            text: qsTr("Searching")
        }

        Button {
            id: button3
            text: "Deleting"
        }
    }

    ColumnLayout {

        id: columnLayout1

        x: 153
        y: 179
        width: 210
        height: 149

        TextField {

            id: textField1

            x: 304
            y: 382
            placeholderText: qsTr("Enter name")
        }

        TextField {

            id: textField2

            x: 299
            y: 349
            placeholderText: qsTr("Enter last name")
        }

        TextField {

            id: textField3

            x: 299
            y: 315
            //text: qsTr("Output")
            text: "Output"
            readOnly: true
        }
    }
}
