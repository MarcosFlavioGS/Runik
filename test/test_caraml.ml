(* Test scaffolding. Real tests will be added per phase (lexer tests first). *)

let test_placeholder () = Alcotest.(check bool) "scaffolding works" true true

let () =
  Alcotest.run "caraml"
    [ ("scaffolding", [ Alcotest.test_case "placeholder" `Quick test_placeholder ]) ]
