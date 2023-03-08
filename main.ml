open Printf ;;
(*let _ = printf "%s" "ggg" ;; *)

type qmlProp =
{
  propId : string;
  propVal : string  
}

type qmlObj = 
{
  title : string;
  qmlNodes : [`QmlProp of qmlProp | `QmlObj of qmlObj] list;
}
let rec tab n = 
  match n with
  | 0 -> ""
  | n -> "\t" ^ tab (n - 1) ;; 

let rec propListToString list tp = 
  match list with
  | [] -> ""
  | hd :: tl ->  
    let line = tab tp ^ hd.propId ^ ": " ^ hd.propVal ^ "\n" in 
      line ^ (propListToString tl tp) ;;

let rec qmlObjListToString list tp = (*tp - tabulation parameter*)
  match list with
  | [] -> ""
  | hd :: tl -> 
     let base = tab tp ^ hd.title ^ "\n" 
      ^ tab tp ^ "{" ^ "\n" in

      let rec f (nodes : [`QmlProp of qmlProp | `QmlObj of qmlObj] list) tp =
        match nodes with
        | [] -> ""
        | nodehd :: nodetl ->
          match nodehd with
          | `QmlProp qp -> propListToString [qp] tp
          | `QmlObj qo -> qmlObjListToString [qo] tp;
        ^ f nodetl tp 
        in

      base ^
      f hd.qmlNodes (tp + 1) 
      ^ tab tp ^ "}" ^ "\n"
      ^ qmlObjListToString tl (tp) 
;;

let textprops = [`QmlProp {propId = "id"; propVal = "text1"}; `QmlProp {propId = "x"; propVal = "40"}; 
                 `QmlProp {propId = "y"; propVal = "10"}; `QmlProp {propId = "text"; propVal = "hi"} ] ;;
let text = {title = "Text"; qmlNodes = textprops; } ;;
let rectangle1props = [`QmlProp {propId = "id"; propVal = "rect1"}] ;;
let rectangle1 = {title = "Rectangle"; qmlNodes = [`QmlProp {propId = "x"; propVal = "31"}] @ [`QmlObj text] @ rectangle1props} ;;
let imageprops = [`QmlProp {propId = "id"; propVal = "image1"}; `QmlProp {propId = "x"; propVal = "60"}; 
                  `QmlProp {propId = "y"; propVal = "30"}; `QmlProp {propId = "image"; propVal = "url"}] ;;
let image = {title = "Image"; qmlNodes = imageprops } ;;
let rectangle2props = [`QmlProp {propId = "id"; propVal = "rect2"}] ;;
let rectangle2 = {title = "Rectangle"; qmlNodes = rectangle2props @ [`QmlObj image] @ [`QmlProp {propId = "x"; propVal = "31"}] @ [`QmlObj rectangle1]} ;;

let s = qmlObjListToString [rectangle2] 0 ;;
let _ = printf "%s" s ;;
let __ = 
  let oc = open_out "qmltest.qml" in
  fprintf oc "%s" s; 
  close_out oc ;;