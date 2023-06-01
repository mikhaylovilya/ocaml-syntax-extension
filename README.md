# ocaml-syntax-extension
Реализация интеграции Qt/QML с OCaml с помощью camlp5 и lablqml.

Позволяет писать разметку QML непосредственно в OCaml, и используя его, как скриптовый язык (поддержка только unit->unit функций).
# Как собрать (с помощью opam): 
$ opam depext lablqml --yes

$ opam install lablqml --yes

$ opam install . --deps-only --with-test

$ opam exec -- dune build

