import QtQuick 2.1
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true

    signal call_caml_slot()

    Component.onCompleted: {
        // console.log(wrapper);
        // console.log(wrapper.callConnectDynamicSlot(root, "call_caml_slot()", "increment()"));
        wrapper.callConnectDynamicSlot(root, "call_caml_slot()", "increment()");
        Qt.quit();
    }
    Text {
        text: "test4"
    }
    // Button {
    //     id: incrementBtn
    //     anchors.centerIn: parent
    //     text: "Increment"
    //     font.pointSize: 18
    //     onClicked: call_caml_slot()
    // }

    Timer {
         interval: 50;
         running: true;
         repeat: false
         onTriggered: {
             call_caml_slot()
             Qt.quit();
         }
    }
}
