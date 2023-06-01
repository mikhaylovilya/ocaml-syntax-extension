[@@@ocamlformat "disable"]  (* TODO: check *)

open Ocamlext.Pr_qml
open Lablqml
open Caml_dynamic.Caml_dynamic_qobj

QML "../tests/test2.qml"
  import "QtQuick 2.5";
  import "QtQuick.Controls 1.0"

  Rectangle {
    id: root;
    width: 640;
    height: 480;

    Text {
      x: parent.width / 2;
      y: 0;
      text: root.width + root.height
    };

    Text {
      x: parent.width / 2;
      y: root.height / 2;
      text: "TEST2";
      font.pointSize: 20
    }
  }
ENDQML;;
