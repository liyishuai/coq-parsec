From Parsec Require Import
     Core.
From Coq Require Import
     String.

Definition parseLastChunk : parser unit :=
  many1 (expect "0"%char);;
  parseCRLF.

Definition parseChunk : parser string :=
  n <- guard (negb ∘ Nat.eqb O) (N.to_nat <$> parseHex);;
  parseCRLF;;
  cs <- manyN n anyToken;;
  parseCRLF;;
  ret (string_of_list_ascii cs).

Definition parseChunkedBody : parser string :=
  catch (data <- concat "" <$> many parseChunk;;
         parseLastChunk;;
         parseCRLF;;
         ret data)
        (fun e => parseChunk;; raise e).

Definition crlf : string := String "013" $ String "010" "".

Goal parse parseChunkedBody (String "3" $ crlf ++ "123" ++ crlf ++
        (String "0" $ crlf ++ crlf)) = inr ("123", "").
Proof. reflexivity. Qed.

Goal parse parseChunkedBody (String "3" $ crlf ++ "12") = inl None.
Proof. reflexivity. Qed.
