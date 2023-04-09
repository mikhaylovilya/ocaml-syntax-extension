open Ocamlext.Pr_qml

let _ = Printf.printf "\nDemo used to test ADT for qml code in module pr_qml!\n"

let textprops =
  [
    QmlProp { prop_name = "id"; prop_val = Expr "text1" };
    QmlProp { prop_name = "x"; prop_val = Expr "40" };
    QmlProp { prop_name = "y"; prop_val = Expr "10" };
    QmlProp { prop_name = "text"; prop_val = Expr "\"hi\" + \"you\"" };
  ]

let text = { obj_name = "Text"; obj_nodes = textprops }
let rectangle1props = [ QmlProp { prop_name = "id"; prop_val = Expr "rect1" } ]

let rectangle1 =
  {
    obj_name = "Rectangle";
    obj_nodes =
      [ QmlProp { prop_name = "x"; prop_val = Expr "31" } ]
      @ [ QmlObj text ] @ rectangle1props;
  }

let imageprops =
  [
    QmlProp { prop_name = "id"; prop_val = Expr "image1" };
    QmlProp { prop_name = "x"; prop_val = Expr "60" };
    QmlProp { prop_name = "y"; prop_val = Expr "30" };
    QmlProp { prop_name = "image"; prop_val = Expr "url" };
  ]

let image = { obj_name = "Image"; obj_nodes = imageprops }
let rectangle2props = [ QmlProp { prop_name = "id"; prop_val = Expr "rect2" } ]

let rectangle2 =
  {
    obj_name = "Rectangle";
    obj_nodes =
      rectangle2props @ [ QmlObj image ]
      @ [ QmlProp { prop_name = "x"; prop_val = Expr "31" } ]
      @ [ QmlObj rectangle1 ]
      @ [
          QmlProp
            {
              prop_name = "header";
              prop_val =
                QmlObjVal
                  {
                    obj_name = "Image";
                    obj_nodes =
                      [
                        QmlProp
                          { prop_name = "src"; prop_val = Expr "somesrc.png" };
                      ];
                  };
            };
        ];
  }

let s = obj_to_string rectangle2 0
let _ = Printf.printf "%s" s

let __ =
  let oc = open_out "qmltest.qml" in
  Printf.fprintf oc "%s" s;
  close_out oc
