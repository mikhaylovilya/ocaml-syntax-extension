import QtQuick 2.1
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true

    Component.onCompleted: {
        console.log(wrapper);
        console.log(wrapper.callConnectDynamicSlot(incrementBtn, "clicked()", "increment()"));
    }
    Text {
        text: "test4"
    }
    // Timer {
    //      interval: 5000;
    //      running: true;
    //      repeat: false
    //      onTriggered: {
    //         //wrapper.run();
    //         Qt.quit();
    //      }
    // }
    Button {
        id: incrementBtn
        anchors.centerIn: parent
        text: "Increment"
        font.pointSize: 18
    }
}
