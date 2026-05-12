# Phase 1 — The Lexer

> Status: **in progress**

## Goal

Turn a flat stream of characters (the contents of a `.cml` file) into a flat stream of **tokens** — the atoms the parser will work with later.

A token answers the question: *"what kind of thing is this chunk of characters?"*. It does **not** answer *"is this code syntactically valid?"* — that's the parser's job.

## What the lexer must do, conceptually

Given input like:

```
let x = 42;
```

…the lexer walks the string character by character and groups characters into tokens:

```
[LET]  [IDENT "x"]  [EQ]  [INT 42]  [SEMI]  [EOF]
```

Grouping rules (informal):

| You see…                        | You do…                                                              |
| ------------------------------- | -------------------------------------------------------------------- |
| a letter or `_`                 | keep reading letters/digits/`_` → it's an **identifier**             |
| an identifier matching a keyword| re-classify it as a **keyword** (e.g. `let`, `fun`)                  |
| a digit                         | keep reading digits → **integer literal**                            |
| `"`                             | read until the next `"` → **string literal**                         |
| an operator/punctuation char    | emit one (or two — `==`, `=>`) operator/punct tokens                 |
| whitespace                      | skip                                                                 |
| `#`                             | skip until end of line (Caraml uses `#` for line comments)           |
| end of input                    | emit `EOF` and stop                                                  |

A lexer is essentially a small state machine. Each loop iteration: peek the current character, dispatch to the right "sub-lexer" (lex_identifier, lex_number, ...), consume characters until that token is complete, append the token, repeat.

## Why "skim before lex"?

Open `main.cml` and list the tokens you'd expect, by hand. This is the most valuable single thing you can do before writing a line of code — it forces you to discover every distinct token type *that file* needs. You'll find things like:
`let`, `fun`, identifiers, type annotations (`:`), `=`, `;`, `{`, `}`, `(`, `)`, integer literals, string literals, `|...|` (anon-fn delimiters), `#` comments, `"{}"` (format string).

You don't have to lex *all* of these in Phase 1. Pick a minimum viable subset and grow it.

## Suggested minimum viable token set for Phase 1

Cover just enough to lex `let x = 42;` and similar:

- Keywords: `let`, `fun`
- Identifiers
- Integer literals
- Punctuation: `=`, `;`, `:`, `(`, `)`, `{`, `}`, `,`, `|`
- `EOF`
- Skip: whitespace, `#`-comments

Defer for later (still Phase 1, but as extensions): string literals, floats, multi-char operators, escape sequences inside strings.

## Design decisions to think about

These are the "why" questions worth sitting with before writing code.

1. **How to represent a token in OCaml.** A variant type is the natural fit:
   ```ocaml
   type token =
     | LET | FUN
     | IDENT of string
     | INT of int
     | EQ | SEMI | COLON
     | LPAREN | RPAREN | LBRACE | RBRACE
     | COMMA | PIPE
     | EOF
   ```
   Compare this to how the previous C implementation tried it (one struct with a `union` *and* a separate `identifier` field — clunky, easy to misuse). OCaml variants make each token's payload type-safe: you can't accidentally read `int_val` from a token that doesn't have one.

2. **Position tracking.** Will you record line and column with each token? You don't need it to *lex*, but you need it for good error messages later. Adding it now (`type token_with_pos = { tok : token; line : int; col : int }`) is cheaper than retrofitting.

3. **How to walk the input.** OCaml gives you several options:
   - A `string` plus an `int ref` index (closest to the C approach).
   - A `Buffer`/`Seq`/`Stream`-based reader.
   - A record holding `{ source : string; mutable pos : int; mutable line : int; mutable col : int }` — clean and idiomatic.
   I'd lean toward option 3. Pick one and own the tradeoff.

4. **How to test it.** Alcotest is wired up in `test/`. The lexer is the easiest phase to unit-test: input string → expected token list. Write the test *first* for each new token type if you want — TDD pairs well with lexing.

## Suggested next steps (do these in order)

1. **List the tokens in `main.cml` by hand.** Write your expected token stream as a comment or in your notes.
2. **Define the `token` variant type** in a new module `lib/token.ml`.
3. **Decide your lexer state representation** (the record from design point 3 is a good default).
4. **Write `init` and `peek`/`advance` helpers** — these are the primitives every other rule uses. Get them right first.
5. **Write `lex_identifier` and `lex_number`** — the two non-trivial sub-lexers. Everything else is single-char dispatch.
6. **Wire it up**: a top-level `lex : string -> token list` (or `Seq.t`, your call).
7. **Add a first alcotest case**: `lex "let x = 42;"` → expected list.

## Experiments to try

- Empty file → what comes out? (Just `[EOF]`, ideally.)
- File of only whitespace and comments → same.
- Unterminated string `"hello` → how do you want to fail? Exception? `result` type? An `ERROR` token?
- Force your buffer to start tiny and confirm it grows correctly (only relevant if you use a `Buffer`/array — `list` makes this a non-issue).
- Make a deliberately ambiguous input like `let123` — does it become `IDENT "let123"` or `LET` + `INT 123`? Which is right? Why?

## Acceptance criteria (phase gate)

This phase is complete when **`dune runtest`** is green for `test/test_phase_1_lexer.ml` **and** you have no remaining questions about the lexer.

The test file is **already there** — go read it. It's the rubric. It currently fails because `Lexer.lex` is a `failwith` stub; your job is to replace that stub.

What's been committed to the repo as part of the rubric:

- `lib/token.ml` — the `Token.t` variant type for Phase 1 (LET, FUN, IDENT, INT, EQ, SEMI, COLON, LPAREN, RPAREN, LBRACE, RBRACE, COMMA, PIPE, EOF), plus `equal`, `pp`, `to_string`. You can extend it (add constructors), but don't remove anything the tests use.
- `lib/lexer.ml` — signature `val lex : string -> Token.t list`, body is a `failwith` stub. **This is what you implement.**
- `test/test_phase_1_lexer.ml` — the gate. Covers empty input, comments, idents, ints, keywords, punctuation, small programs, whitespace tolerance.

You're welcome to add your own tests in a separate file or by extending the existing one. Those extend the gate; they don't replace it.

### Getting tests running

If you haven't yet:

```bash
opam install alcotest
dune runtest        # should print a wall of red — that's the starting state
```

## Open questions / log

*(We'll add to this section as questions come up while you build.)*

---

**Next time you sit down**: do step 1 (list tokens in `main.cml` by hand), then come back and we'll talk through your token variant before you commit to it.
