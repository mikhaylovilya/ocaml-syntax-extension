[@@@ocamlformat "disable"]  (* TODO: check *)

open Ocamlext.Pr_qml

QML "qmltest.qml"
  import "QtQuick 2.5"
  
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

(* let _ =
   run
     (code_to_string
        {
          qml_imports = [ "QtQuick" ];
          qml_obj =
            {
              obj_name = "Rectangle";
              obj_nodes =
                [
                  (QmlProp { prop_name = "id"; prop_val = Expr "root" };
                   QmlProp { prop_name = "width"; prop_val = Expr "640" };
                   QmlProp { prop_name = "height"; prop_val = Expr "480" };
                   QmlObj
                     {
                       obj_name = "Text";
                       obj_nodes =
                         [
                           QmlProp
                             {
                               prop_name = "text";
                               prop_val = Expr "\"hello, nextdemo!\"";
                             };
                         ];
                     });
                ];
            };
        }) *)
