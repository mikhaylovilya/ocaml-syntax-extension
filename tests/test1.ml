open Ocamlext.Pr_qml

let _ = Printf.printf "\nDemo used to test ADT for qml code in module pr_qml!\n"

let textprops =
  [ QmlProp { prop_name = "id"; prop_val = Expr "text1" }
  ; QmlProp { prop_name = "x"; prop_val = Expr "40" }
  ; QmlProp { prop_name = "y"; prop_val = Expr "10" }
  ; QmlProp { prop_name = "text"; prop_val = Expr "\"TEST1\" + \"TEST1\"" }
  ]
;;

let text = { obj_name = "Text"; obj_nodes = textprops }

let rectangle1props =
  [ QmlProp { prop_name = "id"; prop_val = Expr "rect1" }
  ; QmlProp { prop_name = "width"; prop_val = Expr "120" }
  ; QmlProp { prop_name = "height"; prop_val = Expr "60" }
  ]
;;

let rectangle1 = { obj_name = "Rectangle"; obj_nodes = [ QmlObj text ] @ rectangle1props }

let imageprops =
  [ QmlProp { prop_name = "id"; prop_val = Expr "image1" }
  ; QmlProp { prop_name = "x"; prop_val = Expr "60" }
  ; QmlProp { prop_name = "y"; prop_val = Expr "30" }
    (* QmlProp { prop_name = "image"; prop_val = Expr "" }; *)
  ]
;;

let image = { obj_name = "Image"; obj_nodes = imageprops }
let rectangle2props = [ QmlProp { prop_name = "id"; prop_val = Expr "rect2" } ]

let rectangle2 =
  { obj_name = "Rectangle"
  ; obj_nodes =
      rectangle2props
      @ [ QmlObj image ]
      @ [ QmlProp { prop_name = "width"; prop_val = Expr "640" } ]
      @ [ QmlProp { prop_name = "height"; prop_val = Expr "480" } ]
      @ [ QmlObj rectangle1 ]
  }
;;

let code1 = { qml_imports = [ "QtQuick 2.5" ]; qml_obj = rectangle2 }
let s = code_to_string code1
let _ = Printf.printf "%s" s
let _ = run ~qml_src:s ~filename:"../tests/test1.qml" ~args:[ "--quit" ]
