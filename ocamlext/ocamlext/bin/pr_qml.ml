module TEST = struct
  (* type qmlProp = string * qmlObj

     type qmlObj = string * qmlNode list
     and qmlNode = Prop of qmlProp | Obj of qmlObj *)
  type qmlObj = string * qmlNode list
  and qmlNode = Prop of qmlProp | QmlObj of qmlObj
  and qmlProp = { propid : string; propval : propval }
  and propval = Expr of string | QmlObjVal of qmlObj

  let prop1 = { propid = "onClick"; propval = Expr "dosmth" }
  let obj1 : qmlObj = ("Button", [ Prop prop1 ])
  let prop2 = { propid = "src"; propval = Expr "http://somesrc.com" }
  let obj2 : qmlObj = ("Image", [ Prop prop2 ])
  let prop3 = { propid = "header"; propval = QmlObjVal obj2 }
  let obj3 : qmlObj = ("Window", [ Prop prop3; QmlObj obj2 ])
end

type qmlProp = { propId : string; propVal : string }

type qmlObj = {
  title : string;
  qmlNodes : [ `QmlProp of qmlProp | `QmlObj of qmlObj ] list;
}

let rec tab n = match n with 0 -> "" | n -> "\t" ^ tab (n - 1)

let rec propListToString list tp =
  match list with
  | [] -> ""
  | hd :: tl ->
      let line = tab tp ^ hd.propId ^ ": " ^ hd.propVal ^ "\n" in
      line ^ propListToString tl tp

let rec qmlObjListToString list tp =
  (*tp - tabulation parameter*)
  match list with
  | [] -> ""
  | hd :: tl ->
      let base = tab tp ^ hd.title ^ "\n" ^ tab tp ^ "{" ^ "\n" in

      let rec f (nodes : [ `QmlProp of qmlProp | `QmlObj of qmlObj ] list) tp =
        match nodes with
        | [] -> ""
        | nodehd :: nodetl ->
            (match nodehd with
            | `QmlProp qp -> propListToString [ qp ] tp
            | `QmlObj qo -> qmlObjListToString [ qo ] tp)
            ^ f nodetl tp
      in

      base
      ^ f hd.qmlNodes (tp + 1)
      ^ tab tp ^ "}" ^ "\n" ^ qmlObjListToString tl tp
