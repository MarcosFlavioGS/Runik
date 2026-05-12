# Caraml — Build-an-Interpreter Tutorial

This folder is the tutorial trail for building the Caraml interpreter. Each phase has its own document, written *as* the phase is built — explaining what we did, why, and what was learned.

## Phases

1. [Phase 1 — Lexer](phase-1-lexer.md) *(in progress)*
2. Phase 2 — Parser & AST *(planned)*
3. Phase 3 — Tree-walking evaluator *(planned)*
4. Phase 4 — Expressions, precedence *(planned)*
5. Phase 5 — Functions & closures *(planned)*
6. Phase 6 — Control flow & pattern matching *(planned)*

## The big picture

An interpreter turns source text into runtime behavior by passing it through a series of representations:

```
   Source text          "let x = 42;"
       │
       ▼
   ┌─────────┐
   │ LEXER   │   →  stream of tokens:  [LET] [IDENT "x"] [=] [INT 42] [;]
   └─────────┘
       │
       ▼
   ┌─────────┐
   │ PARSER  │   →  AST (tree):   Let("x", IntLit 42)
   └─────────┘
       │
       ▼
   ┌──────────────┐
   │ EVALUATOR /  │   →  runtime effects (bindings, prints, ...)
   │ INTERPRETER  │
   └──────────────┘
```

- **Lexer** — groups characters into tokens. Knows nothing about grammar.
- **Parser** — groups tokens into a tree that mirrors the grammar. Knows nothing about values.
- **Evaluator** — walks the tree and executes it, managing the environment.

Each phase document expands on one of these.

## How a phase "completes"

A phase is **done** when both are true:

1. The phase's gate test suite (`test/test_phase_N_<name>.ml`) passes — `dune runtest` is green.
2. You confirm you have no more questions about what was built.

The gate tests are written **at the start of each phase** as the rubric. They fail initially; the phase is built until they pass. You're encouraged to add more tests beyond the rubric — those extend the gate, they don't replace it.
