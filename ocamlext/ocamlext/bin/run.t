  $ cat <<EOF > qml2.ml
  > open Pr_qml
  > 
  > QML
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
 $ eval $(opam env)
  $ camlp5o ./ocamlext.cma pr_o.cmo qml2.ml > asdf2.ml
 $ cat <<EOF> qml1.ml
 > open Pr_qml
 > QML
 >   import "QtQuick 2.5"
 > 
 >   Rectangle {
 >     id: root;
 >     width: 640;
 >     height: 480;
 > 
 >     Text {
 >       text: "Hello, Cram!"
 >     }
 >   }
 > ENDQML;;
 $ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
 $ ocamlopt -w -10 -o asdf pr_qml.ml asdf.ml
 $ ./asdf --close
 qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml
