(** Token type — the output of the lexer, the input of the parser.

    This is the Phase 1 minimum-viable token set. You can (and will) add more
    constructors as the language grows — strings, floats, more keywords,
    operators, etc. Don't remove anything that the phase-1 tests rely on. *)

type t =
  | LET
  | FUN
  | IDENT of string
  | INT of int
  | EQ
  | SEMI
  | COLON
  | LPAREN
  | RPAREN
  | LBRACE
  | RBRACE
  | COMMA
  | PIPE
  | EOF

let equal = ( = )

let to_string = function
  | LET -> "LET"
  | FUN -> "FUN"
  | IDENT s -> Printf.sprintf "IDENT(%s)" s
  | INT n -> Printf.sprintf "INT(%d)" n
  | EQ -> "EQ"
  | SEMI -> "SEMI"
  | COLON -> "COLON"
  | LPAREN -> "LPAREN"
  | RPAREN -> "RPAREN"
  | LBRACE -> "LBRACE"
  | RBRACE -> "RBRACE"
  | COMMA -> "COMMA"
  | PIPE -> "PIPE"
  | EOF -> "EOF"

let pp fmt t = Format.pp_print_string fmt (to_string t)
