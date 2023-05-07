type qml_code = { qml_imports : string list; qml_obj : qml_obj }
and qml_obj = { obj_name : string; obj_nodes : qml_node list }
and qml_node = QmlProp of qml_prop | QmlObj of qml_obj
and qml_prop = { prop_name : string; prop_val : qml_val }
and qml_val = Expr of string | QmlObjVal of qml_obj

let rec tab n = match n with 0 -> "" | n -> "\t" ^ tab (n - 1)

let rec prop_to_string q_prop tp =
  let str =
    tab tp ^ q_prop.prop_name ^ ": "
    ^ (function Expr se -> se | QmlObjVal qo -> "\n" ^ obj_to_string qo tp)
        q_prop.prop_val
    ^ "\n"
  in
  str

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

  base ^ f q_obj.obj_nodes (tp + 1) ^ tab tp ^ "}" ^ "\n"

let code_to_string q_code =
  List.fold_right
    (fun i1 i2 ->
      if i2 = "" then "import " ^ i1 ^ "\n"
      else "import " ^ i1 ^ "\n" ^ "import " ^ i2 ^ "\n")
    q_code.qml_imports ""
  ^ obj_to_string q_code.qml_obj 0

let print_to_file qml_src =
  let oc = open_out "qmltest.qml" in
  Printf.fprintf oc "%s" qml_src;
  close_out oc

let run qml_src =
  let _ = print_to_file qml_src in
  Sys.command "qmlscene qmltest.qml" (*--quit*)
