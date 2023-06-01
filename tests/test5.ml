[@@@ocamlformat "disable"]  (* TODO: check *)

open Ocamlext.Pr_qml
open Caml_dynamic.Caml_dynamic_qobj
open Lablqml

QML "../tests/test51.qml"
  import "QtQuick 2.5";
  import "QtQuick.Controls 2.5"

  Rectangle {
    id: root;
    width: 640;
    height: 480;

    Text {
      id: label1;
      x: label2.x;
      anchors.bottom: label2.top;
      font.pointSize: 14;
      text: root.width + root.height
    };

    Text {
      id: label2;
      x: parent.width / 2;
      y: root.height / 2;
      anchors.centerIn: parent;
      font.pointSize: 18;
      text: "Test 5"
    };

    Button {
      id: btn1;
      slot onClicked: {
        print_endline "sknfds"
      };
      text: "Do_smth()"
    }
  }
ENDQML;;

(* QML "test51.qml"
  import "QtQuick 2.5";
  import "QtQuick.Controls 1.0"
 
  Rectangle {
    id: root;
    width: 680;
    height: 480;
    
    gradient: Gradient 
    {
      GradientStop { position: 0.0; color: "black" };
      GradientStop { position: 1.0; color: "white" }
    };
    Text {
      x: parent.width / 2;
      y: parent.height / 2;
      text: "Hello, World! X coord:" + x + " Y coord: " + y
    }
  }
ENDQML;; *)
