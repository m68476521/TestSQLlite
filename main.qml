import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0


ApplicationWindow {
    id: root
    title: qsTr("TestSQLlite v0.1")
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
                text: qsTr("&Open")
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
            //messageDialog.show(qsTr("Button 1 pressed"))

            MouseArea:  {
                anchors.fill =  parent
                root.color= Qt.hsla(Math.random(), 0.5, 0.5, 1.0)
            }

        }
        button2.onClicked:  {
            initializeDB()
            projectingDB()
            textField2.text= projectingDB()

        }

        button3.onClicked: {//messageDialog.show(qsTr("Button 3 pressed"))
            var name =  textField1.text
            var lastName = textField2.text

//            var name1 = columnLayout1.text
            if (name != undefined){
                updateDB(name, lastName)
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

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

       function projectingDB() {

             var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
           db.transaction( function(tx) {
               var result = tx.executeSql('select * from notes');
               for (var i = 0; i < result.rows.length; i++ ){
                   print("Result")
//                   print(result.rows[i].value);
                   var dbItem =result.rows.item(i)//+  "\n"
//                   var obj = JSON.parse(result.rows[i].value)

                  print("name: "+ dbItem.name)
                  print("lname: "+ dbItem.lastName)
                   return dbItem.lastName
               }
           });
       }


    function updateDB (name, lastName){
        print("store DB")
           var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        if (!db) { return; }
        db.transaction( function(tx) {
            print("checking if notes exists")
            var result = tx.executeSql('select * from notes where name = "' +name+'"')
            if (result === 1 ) {
                print ("updating")
                result = tx.executeSql('UPDATE notes set lastName ? where name = "' +name+'"', [lastName])
//                textField1.text = "mike"
            }else {
                print("Insert into DB ..")
                result = tx.executeSql('INSERT into notes values (?, ?)', [name, lastName])
            }
        });
    }
}
