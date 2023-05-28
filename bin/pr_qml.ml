(* open Base
open Stdio *)

type qml_obj =
  { obj_name : string
  ; obj_nodes : qml_node list
  }

and qml_node =
  | QmlProp of qml_prop
  | QmlObj of qml_obj

and qml_prop =
  { prop_name : string
  ; prop_val : qml_val
  }

and qml_val =
  | Expr of string
  | QmlObjVal of qml_obj

type qml_code =
  { qml_imports : string list
  ; qml_obj : qml_obj
  }

let rec tab = function
  | 0 -> ""
  | n -> "\t" ^ tab (n - 1)
;;

let rec prop_to_string q_prop tp =
  tab tp
  ^ q_prop.prop_name
  ^ ": "
  ^ (function
     | Expr se -> se
     | QmlObjVal qo -> "\n" ^ obj_to_string qo tp)
      q_prop.prop_val
  ^ "\n"

and obj_to_string q_obj tp =
  (*tp - tabulation parameter*)
  let base = String.concat "" [ tab tp; q_obj.obj_name; "\n"; tab tp; "{"; "\n" ] in
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
  String.concat "" [ base; f q_obj.obj_nodes (tp + 1); tab tp; "}"; "\n" ]
;;

let code_to_string q_code =
  List.fold_right
    (fun x acc ->
      if String.equal acc ""
      then String.concat "" [ "import "; x; "\n" ]
      else String.concat "" [ "import "; x; "\n"; acc; "\n" ])
    q_code.qml_imports
    ""
  ^ obj_to_string q_code.qml_obj 0
;;

let print_to_file ~qml_src ~filename =
  (*filename: "qmltest.qml"*)
  let oc = open_out (* Out_channel.create *) filename in
  Printf.fprintf oc "%s" qml_src;
  Out_channel.close oc
;;

let run ~qml_src ~filename ~args =
  (*filename: "qmltest.qml" args: ["--quit"]*)
  let _ = print_to_file ~qml_src ~filename in
  Stdlib.Sys.command
    ("qmlscene " ^ filename ^ List.fold_right (fun a1 a2 -> a1 ^ a2) args "")
;;
(*--quit*)
