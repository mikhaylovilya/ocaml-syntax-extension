[@@@ocamlformat "disable"]  (* TODO: check *)

open Ocamlext.Pr_qml

QML "qmltest.qml"
  import "QtQuick 2.5";
  import "QtQuick.Controls 1.0"

  Rectangle {
    id: root;
    width: 640;
    height: 480;

    Text {
      x: parent.width / 2;
      y: root.height / 2;
      text: root.width + root.height
    }
  }
ENDQML;;
