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

let checkSlot =
  let f stream = 
    match Stream.npeek 2 stream with
    | [(smth1, "slot");(smth2, paren)] -> 
      (* (Char.code uid.[0] > 64 || Char.code uid.[0] < 91) && paren.[0] = '{' *) true
    | _ -> false
  in
  Grammar.Entry.of_parser gram "checkSlot" (fun strm -> if f strm then () else raise Stream.Failure)
;;

let counter = ref 0;;

let next_val = 
  fun () ->
    counter := (!counter) + 1;
    !counter;;

EXTEND
  GLOBAL: expr;
  expr: BEFORE "expr1"
  [["QML"; ui = STRING; imports = LIST0 import SEP ";"; q = qml; "ENDQML" 
   -> let s_infs, qqml = q in

      let handlers = List.map (fun number, handler 
      -> let str_number = Int.to_string number in 
      <:expr< let single =
        (CamlDynamicQObj.create_func(
          ~name:(String.concat ("" ["caml_slot"; $str:str_number$]))
          ~f:(fun () -> $handler$)))
      in
      set_context_property
        ~ctx:(get_view_exn ~name:"rootContext")
        ~name:(String.concat "" ["wrapper"; $str:str_number$])
        (CamlDynamicQObj.to_lablqml_cppobj single) >>) s_infs
    in

    let qml_startup = <:expr<
   let (app, engine) = create_qapplication Sys.argv in
   let _ = do { $list:handlers$ } in
   let w = loadQml "../tests/test4.qml" engine in
   let _ = assert (w <> None) in
   let _w =
     match w with
     [ Some w -> w
     | None -> failwith "can't create window"]
   in
   QGuiApplication.exec app >> in
     let imps = List.fold_right (fun x acc -> <:expr< [$x$ :: $acc$] >>) imports <:expr< [] >> in
    (* FOLD0 (fun n1 n2 -> <:expr< $n1$ @ [$n2$] >>) <:expr< [] >> import SEP ";"; *)
     let code = <:expr< { qml_imports = $imps$; qml_obj = $qqml$} >> in 

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

       <:expr< let _ = run ~qml_src:(code_to_string $code$) ~filename:$str:ui$ ~args:["--quit"] in $qml_startup$>>
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
      let slots = List.filter_map (fun nd -> match nd with 
      | [], _ -> None
      | x, _ -> Some x) nodes in
      let s_infs = List.concat slots in
      let records = List.map (fun (opt, record) -> record) nodes in
      (* nodes = FOLD0 (fun n1 n2 -> <:expr< [$n2$ :: $n1$] >>) <:expr< [] >> node SEP ";" *)
       let ns = List.fold_right (fun x acc -> <:expr< [$x$ :: $acc$] >>) records <:expr< [] >> in
        (s_infs, <:expr< { obj_name = $str:cname$; obj_nodes = $ns$ } >>)
    ]
  ];
  propid:
  [
    [x = FOLD1 (fun l1 l2 -> if <:expr<$l1$>> = "" then <:expr<$l2$>> else <:expr<$l1$>> ^ "." ^ <:expr<$l2$>>) 
    "" [LIDENT|UIDENT] SEP "." -> x]
  ];
  propval:
  [
    [checkQmlObj; pv = qml 
    -> let s_infs, qqml = pv in
      (s_infs, <:expr< (QmlObjVal $qqml$) >>)] |
    [pv = expr LEVEL "expr1"
    -> let str_expr = Printf.sprintf "%s" (Eprinter.apply pr_expr Pprintf.empty_pc pv) in
       let str_expr = str_expr |> String.escaped in
      ([], <:expr< (Expr $str:str_expr$) >>)]
  ];
  prop: 
  [
    [propid = propid; ":"; propval = propval 
    -> let (s_infs, records) = propval in
      (s_infs, <:expr< { prop_name = $str:propid$; prop_val = $records$} >>)] 
  ];
  node:
  [
    [checkSlot; nodetype = slot 
    -> 
       let (nv, slot_body, s_record) = nodetype in
      ([(nv, slot_body)], <:expr< (QmlSlot $s_record$) >>)] |
    [checkQmlObj; nodetype = qml 
    -> let s_infs, qqml = nodetype in
      (s_infs, <:expr< (QmlObj $qqml$) >>)] |
    [nodetype = prop 
    -> let (s_infs, records) = nodetype in
      (s_infs, <:expr< (QmlProp $records$) >>)]
  ];
  slot:
  [
    ["slot"; slot_name = LIDENT; ":"; "{"; slot_body = expr LEVEL "expr1"; "}" 
    -> 
      let nv = next_val () in  
      let str_nv = Int.to_string nv in
      (nv, <:expr< $slot_body$ >>, <:expr< { slot_name = $str:slot_name$; slot_number = $int:str_nv$}  >>) ]
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