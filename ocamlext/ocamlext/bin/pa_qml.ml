(* property followed by \n or ; 
   property <type> <name> : <value>
    <value> ::= expr | qml
    
   property alias <name> : <reference>
   function -> jsFunc
   <prop> : {<expr>} -> jsFunc
*)
open Pcaml
open Pr_qml.TEST
let obj1 = {cname = "Rect"; nodes = [Prop { prop_id = "x"; prop_val = Expr " \"str\" "}]}

(* let g = Grammar.gcreate (Plexer.gmake());; *)
(* let qexpr = Grammar.Entry.create g "expression";; *)

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
  [["QML"; x = qml; "ENDQML" 
  -> <:expr< $x$ >>
  ]];
  qml:
  [
    [cname = UIDENT; "{"; nodes = LIST0 node SEP ";" ; "}"
    (* -> <:expr< Printf.printf "2222Hello, %s!" $str:cname$ >> *)
    (* -> <:expr< $uid:cname$ >> *)
    -> <:expr< { cname = $str:cname$; nodes = [do {$list:nodes$}] } >>
    ]
  ];
  propid:
  [
    [x = FOLD1 (fun l1 l2 -> if <:expr<$l1$>> = "" then <:expr<$l2$>> else <:expr<$l1$>> ^ "." ^ <:expr<$l2$>>) 
    "" [LIDENT|UIDENT] SEP "." -> x]
  ];
  propval:
  [
    [checkQmlObj; pv = qml -> <:expr< QmlObjVal $pv$ >>] |
    [pv = expr LEVEL "expr1" 
    -> let str_expr = Printf.sprintf "%s" (Eprinter.apply pr_expr Pprintf.empty_pc pv) in
       let str_expr = str_expr |> String.escaped in
      <:expr< Expr $str:str_expr$ >>]
  ];
  prop: 
  [
    [propid = propid; ":"; propval = propval -> <:expr< { prop_id = $str:propid$; prop_val = $propval$} >>] 
  ];
  node:
  [
    [checkQmlObj; nodetype = qml -> <:expr< QmlObj $nodetype$ >>] |
    [nodetype = prop -> <:expr< Prop $nodetype$ >>]
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