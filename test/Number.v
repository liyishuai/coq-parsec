From Parsec Require Import
     Number.

Goal parse (liftA2 pair parseDec parseHex) "23Fa0$" = inr (23, 4000)%N.
Proof. reflexivity. Qed.
