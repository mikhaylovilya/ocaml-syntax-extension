  $ cat <<EOF > qml2.ml
  > open Pr_qml
  > 
  > QML "qml2.qml"
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
  >           x : anchor.bs;
  >           y : anchor.bs
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
  >         id: img1;
  >         x : 40;
  > 
  >         y : 40
  >       };
  > 
  >       y : 0 + img1.x
  >   } 
  > ENDQML;;
  > EOF
$ CAMLP5PARAM='b t' camlp5o ~/Desktop/testing_dune/pn/bin/main.cmo pr_o.cmo qml1.ml
 $ eval $(opam env)
  $ camlp5o ./ocamlext.cma pr_o.cmo qml2.ml > asdf2.ml
  $ cat <<EOF> qml1.ml
  > open Pr_qml
  > QML "qml1.qml"
  >   import "QtQuick 2.5"
  > 
  >   Rectangle {
  >     id: root;
  >     width: 680;
  >     height: 480;
  >     
  >     gradient: Gradient 
  >     {
  >       GradientStop { position: 0.0; color: "black" };
  >       GradientStop { position: 1.0; color: "white" }
  >     };
  >     Text {
  >       x: parent.width / 2;
  >       y: parent.height / 2;
  >       text: "Hello, World! X coord:" + x + " Y coord: " + y
  >     }
  >   }
  > ENDQML;;
  $ camlp5o -I . ocamlext.cma pr_o.cmo qml2.ml > asdf0.ml
 $ camlp5o -I . ocamlext.cma pr_o.cmo qml2.ml
  $ camlp5o -I . ocamlext.cma pr_o.cmo qml1.ml > asdf.ml
  $ ocamlopt -o asdf pr_qml.ml asdf.ml
  $ ./asdf
  qt.qpa.plugin: Could not find the Qt platform plugin "wayland" in ""
$ camlp5o ./ocamlext.cma pr_o.cmo qml1.ml | ocaml
