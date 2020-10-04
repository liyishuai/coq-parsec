From Parsec Require Export
     Core.

(** https://httpwg.org/http-core/draft-ietf-httpbis-semantics-latest.html#rule.token.separators *)

Definition istchar (a : ascii) : bool :=
  isalpha a ||| isdigit a ||| in_string "!#$%&'*+-.^_`|~" a.

Definition parseToken : parser string :=
  string_of_list_ascii <$> many1 (satisfy istchar).

Goal parse parseToken "GET / HTTP/1.1" = inr ("GET", " / HTTP/1.1").
Proof. reflexivity. Qed.

(** https://www.rfc-editor.org/rfc/rfc3986.html#section-2.1 *)
Definition parsePctEncoded : parser string :=
  liftA2 String (expect "%"%char)
         (string_of_list_ascii <$> manyN 2 (satisfy ishexdig)).

Goal parse parsePctEncoded "%123" = inr ("%12", "3").
Proof. reflexivity. Qed.

Goal parse (string_of_list_ascii <$> manyN 3 (satisfy isdigit))
     "412404 Not Found" = inr ("412", "404 Not Found").
Proof. reflexivity. Qed.

Goal parse (string_of_list_ascii <$> manyN 3 (satisfy isdigit))
     "40" = inl None.
Proof. reflexivity. Qed.

Fixpoint expectString (s : string) : parser string :=
  match s with
  | "" => ret ""
  | String a s' => liftA2 String (expect a) (expectString s')
  end.

Goal parse (expectString "HTTP") "" = inl None.
Proof. reflexivity. Qed.
