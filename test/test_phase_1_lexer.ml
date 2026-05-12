(** Phase 1 — Lexer rubric.

    A phase is "done" when this whole suite passes.

    These tests fix the *behavior* of the lexer, not its implementation. How
    you structure the lexer internally (state record, mutable index, recursive
    helpers, char-by-char or regex-driven) is up to you. *)

open Caraml

let token : Token.t Alcotest.testable = Alcotest.testable Token.pp Token.equal

let check_tokens msg expected input =
  Alcotest.(check (list token)) msg expected (Lexer.lex input)

(* --- trivial inputs --------------------------------------------------- *)

let test_empty () = check_tokens "empty input → EOF only" [ EOF ] ""

let test_whitespace_only () =
  check_tokens "only whitespace → EOF only" [ EOF ] "   \t\n   "

let test_comment_only () =
  check_tokens "only a comment → EOF only" [ EOF ] "# this is a comment\n"

let test_comment_then_token () =
  check_tokens "comment then code" [ LET; EOF ] "# nothing to see here\nlet"

(* --- identifiers ------------------------------------------------------ *)

let test_simple_ident () =
  check_tokens "plain identifier" [ IDENT "foo"; EOF ] "foo"

let test_ident_with_digits_and_underscores () =
  check_tokens "ident may contain digits and underscores after first char"
    [ IDENT "_foo_bar123"; EOF ] "_foo_bar123"

let test_ident_starting_like_keyword () =
  check_tokens "let123 is one IDENT, not LET + INT" [ IDENT "let123"; EOF ]
    "let123"

(* --- integer literals ------------------------------------------------- *)

let test_int_literal () = check_tokens "42 → INT 42" [ INT 42; EOF ] "42"

let test_zero () = check_tokens "0 → INT 0" [ INT 0; EOF ] "0"

let test_multi_digit_int () =
  check_tokens "multi-digit int" [ INT 12345; EOF ] "12345"

(* --- keywords --------------------------------------------------------- *)

let test_keyword_let () = check_tokens "'let' is LET, not IDENT" [ LET; EOF ] "let"

let test_keyword_fun () = check_tokens "'fun' is FUN, not IDENT" [ FUN; EOF ] "fun"

(* --- punctuation ------------------------------------------------------ *)

let test_all_punct_adjacent () =
  check_tokens "all minimum-viable punctuation, no whitespace"
    [ EQ; SEMI; COLON; LPAREN; RPAREN; LBRACE; RBRACE; COMMA; PIPE; EOF ]
    "=;:(){},|"

(* --- realistic programs ---------------------------------------------- *)

let test_let_binding () =
  check_tokens "let x = 42;"
    [ LET; IDENT "x"; EQ; INT 42; SEMI; EOF ]
    "let x = 42;"

let test_two_let_bindings_multiline () =
  check_tokens "two let bindings on separate lines"
    [ LET; IDENT "x"; EQ; INT 1; SEMI;
      LET; IDENT "y"; EQ; INT 2; SEMI;
      EOF ]
    "let x = 1;\nlet y = 2;"

let test_function_skeleton () =
  check_tokens "function declaration skeleton from main.cml"
    [ LET; FUN; IDENT "arg1"; IDENT "arg2"; LBRACE; RBRACE; EOF ]
    "let fun arg1 arg2 { }"

let test_typed_param () =
  check_tokens "typed parameter: (n: number)"
    [ LPAREN; IDENT "n"; COLON; IDENT "number"; RPAREN; EOF ]
    "(n: number)"

(* --- mixed whitespace tolerance -------------------------------------- *)

let test_extra_whitespace () =
  check_tokens "extra whitespace between tokens is ignored"
    [ LET; IDENT "x"; EQ; INT 42; SEMI; EOF ]
    "  let    x   =   42  ;  "

let test_inline_comment () =
  check_tokens "comment between tokens is ignored"
    [ LET; IDENT "x"; EQ; INT 42; SEMI; EOF ]
    "let x = # the answer\n42;"

(* --- suite ------------------------------------------------------------ *)

let () =
  Alcotest.run "phase-1-lexer"
    [
      ( "trivial",
        [
          Alcotest.test_case "empty" `Quick test_empty;
          Alcotest.test_case "whitespace only" `Quick test_whitespace_only;
          Alcotest.test_case "comment only" `Quick test_comment_only;
          Alcotest.test_case "comment then token" `Quick test_comment_then_token;
        ] );
      ( "identifiers",
        [
          Alcotest.test_case "simple" `Quick test_simple_ident;
          Alcotest.test_case "with digits/underscores" `Quick
            test_ident_with_digits_and_underscores;
          Alcotest.test_case "starting like keyword" `Quick
            test_ident_starting_like_keyword;
        ] );
      ( "integers",
        [
          Alcotest.test_case "42" `Quick test_int_literal;
          Alcotest.test_case "0" `Quick test_zero;
          Alcotest.test_case "multi-digit" `Quick test_multi_digit_int;
        ] );
      ( "keywords",
        [
          Alcotest.test_case "let" `Quick test_keyword_let;
          Alcotest.test_case "fun" `Quick test_keyword_fun;
        ] );
      ( "punctuation",
        [ Alcotest.test_case "all adjacent" `Quick test_all_punct_adjacent ] );
      ( "programs",
        [
          Alcotest.test_case "let binding" `Quick test_let_binding;
          Alcotest.test_case "two let bindings" `Quick
            test_two_let_bindings_multiline;
          Alcotest.test_case "function skeleton" `Quick test_function_skeleton;
          Alcotest.test_case "typed param" `Quick test_typed_param;
        ] );
      ( "whitespace tolerance",
        [
          Alcotest.test_case "extra whitespace" `Quick test_extra_whitespace;
          Alcotest.test_case "inline comment" `Quick test_inline_comment;
        ] );
    ]
