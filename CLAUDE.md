# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Caraml is an early-stage interpreted programming language being implemented in **OCaml**, with surface syntax inspired by OCaml and Rust (see `README.md` and `main.cml`). This is a **learning project** — the user is building the interpreter phase-by-phase as a way to learn how interpreters and compilers work.

The implementation was previously in C but was reset and switched to OCaml on 2026-05-12. Only the scaffolding exists today; no language phase (lexer/parser/evaluator) is implemented yet.

## Build / Run / Test

The project uses **dune** (`dune-project` at the root):

```bash
dune build              # compile everything
dune exec caraml -- main.cml   # run the interpreter on a .cml file
dune runtest            # run the alcotest suite
dune build @check       # type-check without producing executables
dune utop lib/          # open a REPL with the library loaded
```

Dependencies: `ocaml >= 5.0`, `dune`, and `alcotest` (test-only). Install with `opam install . --deps-only --with-test`.

## Architecture / Layout

```
dune-project        project root; declares package "caraml"
bin/                executable entry point
  dune
  main.ml           thin wrapper — calls Caraml.Driver.run
lib/                interpreter library (public name: caraml, module: Caraml)
  dune
  driver.ml         top-level entry; currently a placeholder
  (lexer/parser/eval modules will be added here as phases progress)
test/               alcotest suite
  dune
  test_caraml.ml
docs/               phase-by-phase tutorial (see docs/README.md)
main.cml            sample Caraml program (the planned surface syntax)
```

Pipeline (intended; nothing past the driver shell exists yet):

1. **Driver** (`lib/driver.ml`) — entry point invoked from `bin/main.ml`. Will dispatch reading a file → lexer → parser → evaluator.
2. **Lexer** *(Phase 1, in progress)* — file contents → token stream.
3. **Parser** *(planned)* — token stream → AST.
4. **Evaluator** *(planned)* — tree-walking interpreter over the AST.

## Working with this user — important

This repository is the user's **learning project**. Default operating mode:

- **Do not write implementation code** in `lib/` for the user. They write it; Claude teaches and reviews.
- Work in **phases**; don't advance until the user explicitly signals they're done with the current one.
- Each phase has a **gate test suite** at `test/test_phase_N_<name>.ml`, written by Claude as the rubric at the start of the phase. A phase is done when those tests pass *and* the user has no more questions.
- Claude **does** write/maintain documentation (`docs/`, `README.md`, this file) and the **phase-gate test files** — that's teaching material / spec, not the implementation the user is learning to write.
- See the memory file `feedback_teaching_mode` for full details.

## Things to know when extending

- Adding a new module to `lib/`: just create the `.ml` file (and optional `.mli`). Dune picks it up automatically — no list to update.
- Adding a new executable or test target: edit the corresponding `dune` file.
- `_build/` is the dune output directory (gitignored).
- The umbrella OCaml module exposed by the library is `Caraml` (capitalized — OCaml module convention), even though the package/binary name is `caraml` (lowercase — opam convention).
