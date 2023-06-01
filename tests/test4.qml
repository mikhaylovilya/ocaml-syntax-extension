import QtQuick 2.1
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true

    signal qml_signal1()
    // signal qml_signal2()

    Component.onCompleted: {
        // console.log(wrapper);
        // console.log(wrapper.callConnectDynamicSlot(root, "call_caml_slot()", "increment()"));
        wrapper.callConnectDynamicSlot(root, "qml_signal1()", "increment()");
        //wrapper1.callConnectDynamicSlot(root, "qml_signal2()", "pr()");
        //Qt.quit();
    }
    Text {
        text: "test4"
    }
    // Button {
    //     id: incrementBtn
    //     anchors.centerIn: parent
    //     text: "Increment"
    //     font.pointSize: 18
    //     onClicked: qml_signal2();
    // }

    Timer {
         interval: 50;
         running: true;
         repeat: false
         onTriggered: {
             qml_signal1();
             Qt.quit();
         }
    }
}
