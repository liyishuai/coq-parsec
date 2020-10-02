From Parsec Require Export
     Core.

(* https://httpwg.org/http-core/draft-ietf-httpbis-semantics-latest.html#rule.token.separators *)

Definition istchar (a : ascii) : bool :=
  isalpha a || isdigit a || in_string "!#$%&'*+-.^_`|~" a.

Definition parseToken : parser string :=
  string_of_list_ascii <$> many1 (satisfy istchar).

Goal parse parseToken "GET / HTTP/1.1" = inr "GET".
Proof. reflexivity. Qed.

Goal string_of_list_ascii <$>
     parse (manyN 3 (satisfy isdigit)) "412404 Not Found" = inr "412".
Proof. reflexivity. Qed.

Goal string_of_list_ascii <$>
     parse (manyN 3 (satisfy isdigit)) "40" = inl None.
Proof. reflexivity. Qed.
