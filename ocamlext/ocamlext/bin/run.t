  $ cat <<EOF > qml1.ml
  > QML 
  >   RECTANGLE 
  >   {
  >       id : rect1;
  >       x : 12; z : -4;
  >       
  >       ToolButton {
  >         text: qsTr("Open"); (*ocaml expr deletes parentheses*)
  >         iconname: "document-open"
  >       };
  > 
  >       (*border.color : "blue"; -- doesnt work*)
  >       BUTTON 
  >       {
  >         onclick : "dosmth"
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
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
$ ocamlopt asdf.ml && ./a.out
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml