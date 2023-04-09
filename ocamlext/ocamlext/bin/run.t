  $ cat <<EOF > qml1.ml
  > (*open Ocamlext*)
  > 
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
  $ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
  $ ocamlopt asdf.ml && ./a.out --open ocamlext.pr_qml
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml
