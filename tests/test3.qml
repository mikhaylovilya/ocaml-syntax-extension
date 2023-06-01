import QtQuick 2.1
import QtQuick.Controls 1.0

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true

    Timer {
         interval: 50;
         running: true;
         repeat: false
         onTriggered: {
             runner.run();
             Qt.quit();
         }
    }
}
