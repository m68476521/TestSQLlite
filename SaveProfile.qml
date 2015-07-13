import QtQuick 1.1
import QtQuick.LocalStorage 2.0

//Rectangle {
//    width: 100
//    height: 62
//}


Item {
    id: componentDB

    Component.onCompleted: {
        var db = LocalStorage.openDatabaseSync("MyExample","1.0", "Example Database", 10000);
        db.transaction( function(tx) {
            var result = tx.executeSql('select * from notes');
            for (var i = 0; i < result.rows.length; i++ ){
                print(result.rows[i].text);
            }
        });
    }
}
