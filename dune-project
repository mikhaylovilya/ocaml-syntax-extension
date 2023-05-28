(lang dune 3.6)

(name ocamlext)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ocamlext)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune camlp5 base stdio dune-configurator)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
