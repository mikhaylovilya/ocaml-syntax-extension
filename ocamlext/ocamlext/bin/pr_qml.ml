type qml_obj = { obj_name : string; obj_nodes : qml_node list }
and qml_node = QmlProp of qml_prop | QmlObj of qml_obj
and qml_prop = { prop_name : string; prop_val : qml_val }
and qml_val = Expr of string | QmlObjVal of qml_obj

(* type qmlProp = { propId : string; propVal : string }

   type qmlObj = {
     title : string;
     qmlNodes : [ `QmlProp of qmlProp | `QmlObj of qmlObj ] list;
   } *)

let rec tab n = match n with 0 -> "" | n -> "\t" ^ tab (n - 1)

let rec prop_to_string q_prop tp =
  let str =
    tab tp ^ q_prop.prop_name ^ ": "
    ^ (function Expr se -> se | QmlObjVal qo -> "\n" ^ obj_to_string qo tp)
        q_prop.prop_val
    ^ "\n"
  in
  str (*^ propListToString tl tp *)

and obj_to_string q_obj tp =
  (*tp - tabulation parameter*)
  let base = tab tp ^ q_obj.obj_name ^ "\n" ^ tab tp ^ "{" ^ "\n" in

  let rec f nodes tp =
    match nodes with
    | [] -> ""
    | nodeshd :: nodestl ->
        (function
          | QmlProp qp -> prop_to_string qp tp
          | QmlObj qo -> obj_to_string qo tp)
          nodeshd
        ^ f nodestl tp
  in

  base
  ^ f q_obj.obj_nodes (tp + 1)
  ^ tab tp ^ "}" ^ "\n" (*^ qmlObjListToString tl tp*)