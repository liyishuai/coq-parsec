From Parsec Require Export
     Number.

(** https://www.rfc-editor.org/rfc/rfc5234.html#appendix-B.1 *)

Definition isbit : ascii -> bool := in_string "01".
Definition isalpha (a : ascii) : bool := isupper a || islower a.
Definition ischar  (a : ascii) : bool := (("001" <=? a) && (a <=? "127"))%char.
Definition isctl   (a : ascii) : bool := ((a <=? "031") || (a =? "127"))%char.

Definition parseHTAB   : parser unit := expect "009"%char.
Definition parseLF     : parser unit := expect "010"%char.
Definition parseCR     : parser unit := expect "013"%char.
Definition parseSP     : parser unit := expect " "%char.
Definition parseDQUOTE : parser unit := expect """"%char.

Open Scope parser_scope.

Definition parseCRLF : parser unit := parseCR;; parseLF.
Definition parseWSP  : parser unit := parseSP <|> parseHTAB.
Definition parseLWSP : parser unit :=
  many (parseWSP <|> (parseCRLF ;; parseWSP));; ret tt.
