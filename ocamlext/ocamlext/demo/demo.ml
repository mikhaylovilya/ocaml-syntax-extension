open Ocamlext.Pr_qml

let _ = Printf.printf "\nDemo used to test ADT for qml code in module pr_qml!\n"

let textprops =
  [
    `QmlProp { propId = "id"; propVal = "text1" };
    `QmlProp { propId = "x"; propVal = "40" };
    `QmlProp { propId = "y"; propVal = "10" };
    `QmlProp { propId = "text"; propVal = "\"hi\" + \"you\"" };
  ]

let text = { title = "Text"; qmlNodes = textprops }
let rectangle1props = [ `QmlProp { propId = "id"; propVal = "rect1" } ]

let rectangle1 =
  {
    title = "Rectangle";
    qmlNodes =
      [ `QmlProp { propId = "x"; propVal = "31" } ]
      @ [ `QmlObj text ]
      @ rectangle1props;
  }

let imageprops =
  [
    `QmlProp { propId = "id"; propVal = "image1" };
    `QmlProp { propId = "x"; propVal = "60" };
    `QmlProp { propId = "y"; propVal = "30" };
    `QmlProp { propId = "image"; propVal = "url" };
  ]

let image = { title = "Image"; qmlNodes = imageprops }
let rectangle2props = [ `QmlProp { propId = "id"; propVal = "rect2" } ]

let rectangle2 =
  {
    title = "Rectangle";
    qmlNodes =
      rectangle2props
      @ [ `QmlObj image ]
      @ [ `QmlProp { propId = "x"; propVal = "31" } ]
      @ [ `QmlObj rectangle1 ];
  }

let s = qmlObjListToString [ rectangle2 ] 0
let _ = Printf.printf "%s" s

let __ =
  let oc = open_out "qmltest.qml" in
  Printf.fprintf oc "%s" s;
  close_out oc
