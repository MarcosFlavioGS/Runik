<img src="https://github.com/user-attachments/assets/da1296ee-c3df-48c7-9529-e30d60a4c3f4" width="500" height="500">

# Caraml

Caraml is a work-in-progress interpreted programming language that combines functional programming features with a syntax inspired by OCaml and Rust. It aims to provide a modern, expressive, and type-safe programming experience.

## Features (Planned)

- **Functional Programming**: First-class functions, pattern matching, and immutable data structures
- **Type System**: Strong static typing with type inference
- **Modern Syntax**: Clean and expressive syntax inspired by OCaml and Rust
- **Interpreted**: Direct execution without compilation step
- **Memory Safety**: Built-in memory management and safety features

## Example (Planned Syntax)

```rust
// Function definition with pattern matching
let factorial = |n| match n {
    0 => 1,
    n => n * factorial(n - 1)
};

// Type inference and immutable variables
let x = 42;
let message = "Hello, Caraml!";

// Higher-order functions
let map = |f, list| match list {
    [] => [],
    [head, ...tail] => [f(head), ...map(f, tail)]
};
```

## Implementation

Caraml is implemented in **OCaml**, built with [dune](https://dune.build/). It is a learning project — the interpreter is being built phase-by-phase (lexer → parser → evaluator). See `docs/` for the tutorial trail.

### Requirements

- OCaml >= 5.0
- dune
- alcotest (for tests)

```bash
opam install . --deps-only --with-test
```

### Building & Running

```bash
dune build                       # compile
dune exec caraml -- main.cml     # run the interpreter on a source file
dune runtest                     # run the test suite
```

## Status

Early development. Project scaffolding is in place; **Phase 1 (lexer)** is next. See `docs/` for current progress.

## License

[License information to be added] 
