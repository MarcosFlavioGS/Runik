(* Driver: top-level entry point of the interpreter.
   For now, just a placeholder until the lexer is in place. *)

let run = function
  | _ :: path :: _ -> Printf.printf "Caraml: would run %s (lexer not implemented yet)\n" path
  | _ -> prerr_endline "Usage: caraml <file.cml>"
