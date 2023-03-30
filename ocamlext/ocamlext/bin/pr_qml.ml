type qmlProp2 = string * string;;
type qmlObj2 = string * qmlNode list and qmlNode = Prop of qmlProp2 | Obj of qmlObj2;;

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