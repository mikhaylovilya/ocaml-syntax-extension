(* open Pcaml
EXTEND
  expr: BEFORE "expr1"
  [ [ "sum";
      e =
      FOLD0 (fun e1 e2 -> <:expr< $e2$ + $e1$ >>) <:expr< 0 >>
        expr LEVEL "expr1" SEP ";";
      "end" -> e ] ] ;
END *)

(* property followed by \n or ; 

   property <type> <name> : <value>
    <value> ::= expr | qml
    
   property alias <name> : <reference>

   function -> jsFunc
   <prop> : {<expr>} -> jsFunc

*)

open Pcaml 

(* let g = Grammar.gcreate (Plexer.gmake());; *)
(* let qexpr = Grammar.Entry.create g "expression";; *)

let checkQmlObj =
  let f stream = 
    match Stream.npeek 2 stream with
    | [(smth1, uid);(smth2, paren)] -> 
      if (Char.code uid.[0] > 64 || Char.code uid.[0] < 91) && paren.[0] = '{' then true else false
    | _ -> false
  in
  Grammar.Entry.of_parser gram "checkQmlObj" (fun strm -> if f strm then () else raise Stream.Failure)
;;

EXTEND
  GLOBAL: expr;
  expr: BEFORE "expr1"
  [["QML"; x = qml; "ENDQML" -> x]];
  qml:
  [
    [cname = UIDENT; "{"; nodes = LIST0 node SEP ";" ; "}"
    (* -> <:expr< Printf.printf "2222Hello, %s!" $str:cname$ >> *)
    (* -> <:expr< $uid:cname$ >> *)
    -> <:expr< do {$list:nodes$} >>
    ]
  ];
  propid:
  [
    [x = FOLD1 (fun l1 l2 -> if <:expr<$l1$>> = "" then <:expr<$l2$>> else <:expr<$l1$>> ^ "." ^ <:expr<$l2$>>) "" LIDENT SEP "." -> x]
  ];
  propval:
  [
    [checkQmlObj; pv = qml -> pv] |
    [pv = expr LEVEL "expr1" -> pv]
  ];
  prop: 
  [
    [propid = propid; ":"; propval = propval -> <:expr< ($str:propid$, $propval$) >>] 
    (* [propid = LIDENT; ":"; propval =  -> <:expr< ($lid:propid$, $propval$) >>] *)
    (* [propid = UIDENT; ":"; propval = expr LEVEL "expr1" -> <:expr< ($uid:propid$, $propval$) >>] *)
  ];
  node:
  [
    [nodetype = qml -> nodetype] |
    [nodetype = prop -> nodetype]
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