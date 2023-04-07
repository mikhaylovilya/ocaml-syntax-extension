  $ cat <<EOF > qml1.ml
  > QML 
  >   Rectangle
  >   {
  >       id : rect1;
  >       x : 12; z : -4;
  >      
  >       header : Button
  >       {
  >         src : "src";
  >         anotherprop : 90
  >       }; 
  > 
  >       ToolButton {
  >         text: qsTr("Open"); (*bug - ocaml expr deletes parentheses*)
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
  >         x : "40";
  > 
  >         y : "40"
  >       };
  > 
  >       y : "0" + img1.x
  >   } 
  > ENDQML;;
  > EOF
$ CAMLP5PARAM='b t' camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml1.ml
  $ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml
  let _ =
    "id", rect1;
    "x", 12;
    "z", -4;
    "header", begin "src", "src"; "anotherprop", 90 end;
    "text", qsTr "Open";
    (*bug - ocaml expr deletes parentheses*)
    "iconName", "document-open";
    "Border.color", "blue";
    "onClick", "dosmth";
    "id", img1;
    "x", "40";
    "y", "40";
    "y", "0" + img1.x
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
$ ocamlopt asdf.ml && ./a.out
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml
