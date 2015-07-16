import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0

ApplicationWindow {
    id: root
    title: qsTr("TestSQLlite v0.2")
    width: 640
    height: 480
    visible: true
    color: settings.color


    Settings {
        id: settings
        property color color: '#000000'
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem {
                text: qsTr("&Save Data")
                onTriggered: messageDialog.show(qsTr("Open action triggered"));
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MainForm {
        anchors.fill: parent
        button1.onClicked: {
            MouseArea: {
                anchors.fill =  parent
                root.color= Qt.hsla(Math.random(), 0.5, 0.5, 1.0)
            }
            //Initializing DB
            initializeDB()
            //Update or insert on DB
            updateDB(textField1, textField2)
            textField1 = ""
            textField2 = ""
            textField33 = ""
        }

        button2.onClicked: {
            //onClicked second button show in textfield 3 the result
            var textResult = projectingDB(textField1)
            print("Result: " + textResult)
            textField1 = ""
            textField2 = ""
            textField33 = textResult
        }

        button3.onClicked: {
            //onClicked third button delete from DB
            if (textField1 != undefined){
                removeItemDB(textField1)
                textField33 = textField1
                textField1 = ""
                textField2 = "Removed"

            }
        }
    }

    MessageDialog {

        id: messageDialog

        title: qsTr("Saving name and last name")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    function storeColor (){
        settings.color =root.color
    }


    function initializeDB() {

        print("initialazingDB ... ")
        var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        db.transaction( function(tx){
            print("Creating table ...")
            tx.executeSql('CREATE TABLE IF NOT EXISTS notes(name TEXT, lastName TEXT)')
        });
    }

    function projectingDB(FirstName) {
        var completeName = "null"
        var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        db.transaction( function(tx) {
            var result = tx.executeSql('select * from notes where name = "'+ FirstName +'"');
            for (var i = 0; i < result.rows.length; i++ ){
                print("Result")
                var dbItem =result.rows.item(i) //Getting Item from DB
                var name = dbItem.name
                var lastName = dbItem.lastName
                print("name: "+ name + " , lastName: " +lastName)
                completeName = ""
                completeName = name + " - " + lastName
            }
        });
        return completeName
    }

    function updateDB (name, lastName){
        print("store DB")
        var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        if (!db) { return; }
        db.transaction( function(tx) {
            print("verify if notes has created")
            var result = tx.executeSql('select * from notes where name = "' +name+'"')
            if (result > 0 ) {
                print ("updating")
                result = tx.executeSql('UPDATE notes set lastName ? where name = "' +name+'"', [lastName])
            }else {
                print("Insert into DB ..")
                result = tx.executeSql('INSERT into notes values (?, ?)', [name, lastName])
            }
        });
    }
    function removeItemDB (name){
        print("remove Items on DB")
        var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        if (!db) { return; }
        db.transaction( function(tx) {
            print("checking if notes exists")
            var result = tx.executeSql('select * from notes where name = "' +name+'"')
            for (var i = 0; i < result.rows.length; i++ ) {
                print ("deleting: "+name)
                result = tx.executeSql('DELETE from notes where name = "' +name+'"')
            }
        });
    }
}
