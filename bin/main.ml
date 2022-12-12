#load "pa_extend.cmo";
#load "q_MLast.cmo";
open Pcaml;

value g = Grammar.gcreate (Plexer.gmake ());
value expr = Grammar.Entry.create g "expr";

EXTEND
  GLOBAL: expr;
  expr: [[cname = component_name; "{"; nested_component = LIST0 expr; attrs = LIST0 props; "}" -> 
         let res = [<:expr< $cname$ {$list:nested_component$} {$list:attrs$} >>] in
         <:expr< {$list:res$} >>
    ]];
  component_name:
    [[name = UIDENT -> name]];
  props:
    [[id = LIDENT; ":"; v = INT; ";"]];
END;

(*open Printf;
let str = "ITEM{x:9;y:8;}" in
for i = 0 to String.length str - 1 do {
  let r = Grammar.Entry.parse expr (Stream.of_string str.(i)) in
  printf "%s = %s\n" Sys.argv.(i) r;
  flush stdout;
};*)