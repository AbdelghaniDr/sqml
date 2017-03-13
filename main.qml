import QtQuick 2.0

import "user"

Item {

    width: 360
    height: 360

    DataBase {
        id: dataBase
    }

    UserService {
        id: userService
        connection: dataBase
        debug: false
    }

    Component.onCompleted: {
        dataBase.transaction(function (tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS User(id TEXT, name TEXT)');
        });
    }

    Component.onDestruction:  {
        dataBase.transaction(function (tx){
            tx.executeSql('DROP TABLE User');
        });
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var user = {
                id: Date.now(),
                name: Math.random().toString().substring(0, 12)
            }

            userService.insert(user, function(size){
                console.log("size: " , size);
            });

            userService.findList({}, function(list){
                for(var iter in list) {
                    console.log("user: ", JSON.stringify(list[iter]));
                }
            });
        }
    }
}
