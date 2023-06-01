(* open Base
open Stdio *)

open Lablqml
open Caml_dynamic.Caml_dynamic_qobj

(* type qml_slot =
  { slot_name : string
  ; slot_body : MLast.expr
  } *)

type qml_obj =
  { obj_name : string
  ; obj_nodes : qml_node list
  }

and qml_node =
  | QmlProp of qml_prop
  | QmlObj of qml_obj
  | QmlSlot of string

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
  (*np - naming parameter*)
  let base = String.concat "" [ tab tp; q_obj.obj_name; "\n"; tab tp; "{"; "\n" ] in
  let rec f nodes tp =
    match nodes with
    | [] -> ""
    | nodeshd :: nodestl ->
      (function
       | QmlProp qp -> prop_to_string qp tp
       | QmlObj qo ->
         obj_to_string qo tp
         (* | QmlSlot qs ->
         prop_to_string
           { prop_name = qs; prop_val = Expr ("" ^ Int.to_string (np + 1)) }
           tp*))
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
  let command =
    "qmlscene " ^ filename ^ " " ^ List.fold_right (fun a1 a2 -> a1 ^ " " ^ a2) args ""
  in
  (* let _ = Printf.printf "%s" command in *)
  Stdlib.Sys.command command
;;

(* $ cat <<EOF > qml2.ml
> open Pr_qml
> 
> QML "qml2.qml"
>   import "QtQuick 2.5"
>   
>   Rectangle
>   {
>       id : rect1;
>       x : 20; y : 30;
>      
>       header : Button
>       {
>         src : "src";
>         anotherprop : "90";
>         Image {
>           x : anchor.bs;
>           y : anchor.bs
>         }
>       };
> 
>       ToolButton {
>         text: "Open";
>         iconName: "document-open"
>       };
> 
>       Border.color : "blue";
>       BUTTON 
>       {
>         onClick : "dosmth"
>       };
> 
>       IMAGE
>       {
>         id: img1;
>         x : 40;
> 
>         y : 40
>       };
> 
>       y : 0 + img1.x
>   } 
> ENDQML;;
> EOF
$ CAMLP5PARAM='b t' camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml1.ml
$ eval $(opam env)
$ camlp5o ./ocamlext.cma pr_o.cmo qml2.ml > asdf2.ml
$ cat <<EOF> qml1.ml
> open Pr_qml
> QML "qml1.qml"
>   import "QtQuick 2.5";
>   import "QtQuick.Controls 1.0"
> 
>   Rectangle {
>     id: root;
>     width: 680;
>     height: 480;
>     
>     gradient: Gradient 
>     {
>       GradientStop { position: 0.0; color: "black" };
>       GradientStop { position: 1.0; color: "white" }
>     };
>     Text {
>       x: parent.width / 2;
>       y: parent.height / 2;
>       text: "Hello, World! X coord:" + x + " Y coord: " + y
>     }
>   }
> ENDQML;;
$ camlp5o -I . ocamlext.cma pr_o.cmo qml2.ml > asdf0.ml
$ camlp5o -I . ocamlext.cma pr_o.cmo qml2.ml
$ camlp5o -I . ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
$ ocamlopt -o asdf pr_qml.ml asdf.ml -dsource
$ ./asdf
qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml *)
