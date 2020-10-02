From Parsec Require Export
     Number.

(** https://www.rfc-editor.org/rfc/rfc5234.html#appendix-B.1 *)

Definition isbit : ascii -> bool := in_string "01".
Definition isalpha (a : ascii) : bool := isupper a ||| islower a.
Definition ischar  (a : ascii) : bool := (("001" <=? a) &&& (a <=? "127"))%char.
Definition isctl   (a : ascii) : bool := ((a <=? "031") ||| (a =? "127"))%char.

Definition parseHTAB   : parser ascii := expect "009"%char.
Definition parseLF     : parser ascii := expect "010"%char.
Definition parseCR     : parser ascii := expect "013"%char.
Definition parseSP     : parser ascii := expect " "%char.
Definition parseDQUOTE : parser ascii := expect """"%char.

Open Scope parser_scope.

Definition parseCRLF : parser unit := parseCR;; parseLF;; ret tt.
Definition parseWSP  : parser ascii := parseSP <|> parseHTAB.
Definition parseLWSP : parser unit :=
  many (parseWSP <|> (parseCRLF ;; parseWSP));; ret tt.
