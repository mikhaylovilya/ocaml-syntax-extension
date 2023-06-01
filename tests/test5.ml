[@@@ocamlformat "disable"]  (* TODO: check *)

open Ocamlext.Pr_qml
open Caml_dynamic.Caml_dynamic_qobj
open Lablqml

QML "qmltest.qml"
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
      text: "Do_smth()"
    }
  }
ENDQML;;
