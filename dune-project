(lang dune 3.18)

(name caraml)

(generate_opam_files true)

(source
 (github MarcosFlavioGS/Caraml))

(authors "Marcos Flavio")

(maintainers "marcos.flavio@justtraveltour.com")

(package
 (name caraml)
 (synopsis "Caraml: a small interpreted language (learning project)")
 (description "An OCaml-implemented interpreter for Caraml, a small language with syntax inspired by OCaml and Rust.")
 (depends
  (ocaml (>= 5.0))
  dune
  (alcotest :with-test)))
