  $ cat <<EOF > qml1.ml
  > (*open Ocamlext*)
  > 
  > type qml_obj = { cname : string; nodes : qml_node list }
  > and qml_node = Prop of qml_prop | QmlObj of qml_obj
  > and qml_prop = { prop_id : string; prop_val : prop_val }
  > and prop_val = Expr of string | QmlObjVal of qml_obj
  > QML 
  >   Rectangle
  >   {
  >       id : "rect1";
  >       x : "12 + 7"; z : "-4";
  >      
  >       header : Button
  >       {
  >         src : "src";
  >         anotherprop : "90";
  >         Image {
  >           x : "anchor.bs";
  >           y : "anchor.bs"
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
  >         id: "img1";
  >         x : "40";
  > 
  >         y : "40"
  >       };
  > 
  >       y : "0 + img1.x"
  >   } 
  > ENDQML;;
  > EOF
$ CAMLP5PARAM='b t' camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml1.ml
  $ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml
  (*open Ocamlext*)
  
  type qml_obj = { cname : string; nodes : qml_node list }
  and qml_node =
      Prop of qml_prop
    | QmlObj of qml_obj
  and qml_prop = { prop_id : string; prop_val : prop_val }
  and prop_val =
      Expr of string
    | QmlObjVal of qml_obj
  let _ =
    {cname = "Rectangle";
     nodes =
       [begin
          Prop {prop_id = "id"; prop_val = Expr "\"rect1\""};
          Prop {prop_id = "x"; prop_val = Expr "\"12 + 7\""};
          Prop {prop_id = "z"; prop_val = Expr "\"-4\""};
          Prop
            {prop_id = "header";
             prop_val =
               QmlObjVal
                 {cname = "Button";
                  nodes =
                    [begin
                       Prop {prop_id = "src"; prop_val = Expr "\"src\""};
                       Prop {prop_id = "anotherprop"; prop_val = Expr "\"90\""};
                       QmlObj
                         {cname = "Image";
                          nodes =
                            [begin
                               Prop
                                 {prop_id = "x";
                                  prop_val = Expr "\"anchor.bs\""};
                               Prop
                                 {prop_id = "y";
                                  prop_val = Expr "\"anchor.bs\""}
                             end]}
                     end]}};
          QmlObj
            {cname = "ToolButton";
             nodes =
               [begin
                  Prop {prop_id = "text"; prop_val = Expr "\"Open\""};
                  Prop
                    {prop_id = "iconName"; prop_val = Expr "\"document-open\""}
                end]};
          Prop {prop_id = "Border.color"; prop_val = Expr "\"blue\""};
          QmlObj
            {cname = "BUTTON";
             nodes =
               [begin
                  Prop {prop_id = "onClick"; prop_val = Expr "\"dosmth\""}
                end]};
          QmlObj
            {cname = "IMAGE";
             nodes =
               [begin
                  Prop {prop_id = "id"; prop_val = Expr "\"img1\""};
                  Prop {prop_id = "x"; prop_val = Expr "\"40\""};
                  Prop {prop_id = "y"; prop_val = Expr "\"40\""}
                end]};
          Prop {prop_id = "y"; prop_val = Expr "\"0 + img1.x\""}
        end]}
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
$ ocamlopt asdf.ml && ./a.out
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml
