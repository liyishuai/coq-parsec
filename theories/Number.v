From Coq Require
     Bool
     DecimalString
     HexadecimalString.
From Coq Require Export
     Ascii
     NArith
     ZArith.
From ExtLib Require Export
     Functor
     String.
From Parsec Require Export
     Parser.
Export FunctorNotation.
Open Scope lazy_bool_scope.

Definition isupper (a : ascii) : bool :=
  (("A" <=? a) &&& (a <=? "Z"))%char.

Definition islower (a : ascii) : bool :=
  (("a" <=? a) &&& (a <=? "z"))%char.

Definition toupper (a : ascii) : ascii :=
  if islower a
  then ascii_of_N (N_of_ascii a - 32)
  else a.

Definition tolower (a : ascii) : ascii :=
  if isupper a
  then ascii_of_N (N_of_ascii a + 32)
  else a.

Definition in_string (s : string) (a : ascii) : bool :=
  existsb (Ascii.eqb a) (list_ascii_of_string s).

Definition isdigit : ascii -> bool :=
  in_string "0123456789".

Definition ishexdig (a : ascii) : bool :=
  isdigit a ||| in_string "abcdefABCDEF" a.

Definition map_string (f : ascii -> ascii) : string -> string :=
  string_of_list_ascii ∘ map f ∘ list_ascii_of_string.

Definition parseDec : parser N :=
  s <- string_of_list_ascii <$> many (satisfy isdigit);;
  match DecimalString.NilZero.uint_of_string s with
  | Some i => ret (N.of_uint i)
  | None => peek;; raise (Some "Not a decimal number.")
  end.

Definition parseHex : parser N :=
  s <- map_string tolower ∘ string_of_list_ascii <$> many (satisfy ishexdig);;
  match HexadecimalString.NilZero.uint_of_string s with
  | Some i => ret (N.of_hex_uint i)
  | None => peek;; raise (Some "Not a hexadecimal number.")
  end.
