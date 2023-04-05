(*-- i dunno it doesnt seem to work correctly
  jsx
  хотим как в jsx но для qml -- в qml запихать --, как в javascript запихали jsx
  Lookahead one in camlp5 -- dragon book
*)
open Ocamlext.Pr_qml

let _ = Printf.printf "\nDemo used to test ADT for qml code in module pr_qml!\n"

(* type qmlProp2 = string * string;;
   type qmlObj2 = string * qmlNode list and qmlNode = Prop of qmlProp2 | Obj of qmlObj2;;

   let nprop1 : qmlProp2 = "x", "40";;
   let nprop2: qmlProp2 = "y", "0";;
   let nobj1 : qmlObj2 = "button", [Prop nprop1; Prop nprop2];;
   let nprop3 : qmlProp2 = "x", "0";;
   let nprop4: qmlProp2 = "y", "0";;
   let nobj2 : qmlObj2 = "rectangle", [Prop nprop3; Obj nobj1; Prop nprop4];; *)

let textprops =
  [
    `QmlProp { propId = "id"; propVal = "text1" };
    `QmlProp { propId = "x"; propVal = "40" };
    `QmlProp { propId = "y"; propVal = "10" };
    `QmlProp { propId = "text"; propVal = "hi" };
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
