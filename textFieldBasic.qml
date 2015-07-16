import QtQuick 1.1

Rectangle {

    property alias resultText: textInput.text

    width: 100
    height: 62


    TextInput  {
        id: textInput
//        text: "Result"
//        anchors.top: text
    }
}


