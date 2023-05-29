import QtQuick 2.1
import QtQuick.Controls 1.0

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true

    Component.onCompleted: {
        console.log(runner)
    }
    Text {
        text: "test4"
    }

    Timer {
         interval: 5000;
         running: true;
         repeat: false
         onTriggered: {
            runner.run();
            Qt.quit();
         }
    }

}
