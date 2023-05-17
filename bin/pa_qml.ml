(* property followed by \n or ; 
   property <type> <name> : <value>
    <value> ::= expr | qml
    
   property alias <name> : <reference>
   function -> jsFunc
   <prop> : {<expr>} -> jsFunc
*)
open Pcaml
open Pr_qml

(*todo: lookup for more than 2 lexems*)
let checkQmlObj =
  let f stream = 
    match Stream.npeek 2 stream with
    | [(smth1, uid);(smth2, paren)] -> 
      (Char.code uid.[0] > 64 || Char.code uid.[0] < 91) && paren.[0] = '{'
    | _ -> false
  in
  Grammar.Entry.of_parser gram "checkQmlObj" (fun strm -> if f strm then () else raise Stream.Failure)
;;

EXTEND
  GLOBAL: expr;
  expr: BEFORE "expr1"
  [["QML"; ui = STRING; imports = LIST0 import SEP ";"; q = qml; "ENDQML" 
   -> let imps = List.fold_right (fun x acc -> <:expr< [$x$ :: $acc$] >>) imports <:expr< [] >> in
    (* FOLD0 (fun n1 n2 -> <:expr< $n1$ @ [$n2$] >>) <:expr< [] >> import SEP ";"; *)
     let code = <:expr< { qml_imports = $imps$; qml_obj = $q$} >> in 

      (* let a = <:expr< 11 >> in 
      let b = <:expr< 12 >> in 
          let c = <:expr< 13 >> in
          let lst = 
            List.fold_left
            (fun acc x -> 
              <:expr< [ $x$ :: $acc$ ] >>
              ) 
              <:expr< [] >> 
              [a;b;c] 
            in 
            let _ = <:expr< $lst$ >> *)

       <:expr< run ~qml_src:(code_to_string $code$) ~filename:$str:ui$ ~args:[] >>
  ]];
  import:
  [
    ["import"; imp = STRING
    -> <:expr< $str:imp$ >>]
  ];
  qml:
  [
    [cname = UIDENT; "{"; nodes = LIST0 node SEP ";" ; "}"
    -> 
      (* nodes = FOLD0 (fun n1 n2 -> <:expr< [$n2$ :: $n1$] >>) <:expr< [] >> node SEP ";" *)
       let ns = List.fold_right (fun x acc -> <:expr< [$x$ :: $acc$] >>) nodes <:expr< [] >> in
        <:expr< { obj_name = $str:cname$; obj_nodes = $ns$ } >>
    ]
  ];
  propid:
  [
    [x = FOLD1 (fun l1 l2 -> if <:expr<$l1$>> = "" then <:expr<$l2$>> else <:expr<$l1$>> ^ "." ^ <:expr<$l2$>>) 
    "" [LIDENT|UIDENT] SEP "." -> x]
  ];
  propval:
  [
    [checkQmlObj; pv = qml -> <:expr< (QmlObjVal $pv$) >>] |
    [pv = expr LEVEL "expr1" 
    -> let str_expr = Printf.sprintf "%s" (Eprinter.apply pr_expr Pprintf.empty_pc pv) in
       let str_expr = str_expr |> String.escaped in
      <:expr< (Expr $str:str_expr$) >>]
  ];
  prop: 
  [
    [propid = propid; ":"; propval = propval -> <:expr< { prop_name = $str:propid$; prop_val = $propval$} >>] 
  ];
  node:
  [
    [checkQmlObj; nodetype = qml -> <:expr< (QmlObj $nodetype$) >>] |
    [nodetype = prop -> <:expr< (QmlProp $nodetype$) >>]
  ];
END

(* $ cat <<EOF > test1.ml
> let x = 1 in sum x ; x ; 2 end;;
> EOF
$ camlp5o ./pa_JSX.cma pr_o.cmo test1.ml
let _ = let x = 1 in 2 + (x + (x + 0)) *)

(* $ cat <<EOF > qml.ml
> QML RECTANGLE {x:str1; y:str1} ;;
> EOF
$ CAMLP5PARAM='b t' camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml.ml
$ camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml.ml *)

(* let __ ()  =
  Sys.command (
    "qmlscene asdf.qml"
  ) *)

  (* > type qml_obj = { cname : string; nodes : qml_node list }
  > and qml_node = Prop of qml_prop | QmlObj of qml_obj
  > and qml_prop = { prop_id : string; prop_val : prop_val }
  > and prop_val = Expr of string | QmlObjVal of qml_obj *)