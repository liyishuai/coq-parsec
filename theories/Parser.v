From Coq Require Export
     Basics
     Bool
     DecidableClass
     List
     String.
From ExtLib Require Export
     Applicative
     EitherMonad
     Extras
     List
     Monad
     MonadExc
     MonadState
     Traversable
     StateMonad.
From Ceres Require Export
     Ceres.
Export
  FunNotation
  ListNotations
  MonadNotation.
Open Scope string_scope.
Open Scope monad_scope.
Open Scope program_scope.

Program Instance Decidable_not {P} `{Decidable P} : Decidable (~ P) := {
  Decidable_witness := negb Decidable_witness
}.
Next Obligation.
  split; intro.
  - apply negb_true_iff in H0.
    eapply Decidable_complete_alt; intuition.
  - erewrite Decidable_sound_alt; intuition.
Qed.

Notation "P '?'" := (decide P) (at level 100).

Definition bigNumber : nat := 5000.

Declare Scope parser_scope.
Delimit Scope parser_scope with parser.
Infix "<|>" := (fun p q => catch p (const q)) (at level 60) : parser_scope.

Section Parser.

  Variable P : Set.
  Context `{Serialize P}.
  Context `{forall p q : P, Decidable (p = q)}.

  Definition parser := stateT (list P) (sum string).
  Bind Scope parser_scope with parser.

  Definition anyToken : parser P :=
    xs <- get;;
    match xs with
    | []    => raise "oneStep: expects a token."
    | x::xs' => put xs';; ret x
    end.

  Definition peek : parser P :=
    xs <- get;;
    match xs with
    | []  => raise "peek: expects a token."
    | x::_ => ret x
    end.

  Definition satisfy (f : P -> bool) : parser P :=
    x <- anyToken;;
    if f x
    then ret x
    else raise $ "Dissatisfying: " ++ to_string x.

  Fixpoint many_ {T} (acc : list T) (fuel : nat) (p : parser T) : parser (list T) :=
    match fuel with
    | O => raise "many_: out of fuel."
    | S fuel' =>
      (t <- p;; many_ (t::acc) fuel' p) <|> ret (rev' acc)
    end.

  Definition many' {T} : nat -> parser T -> parser (list T) := many_ [].

  Definition many {T} : parser T -> parser (list T) := many' bigNumber.

  Definition many1 {T} (p : parser T) : parser (list T) := liftA2 cons p (many p).

  Definition manyN {T} (n : nat) (p : parser T) : parser (list T) :=
    sequence (repeat p n).

  Definition firstExpect {T} (t : P) (pr : parser T) : parser T :=
    (satisfy (fun x => t = x?);; pr)
      <|> raise ("firstExpect: " ++ to_string t ++ " not found.").

  Definition ifFirst {T} (t : P) (pr : parser T) : parser T :=
    x <- peek;;
    if t = x?
    then pr
    else raise ("ifFirst: " ++ to_string t ++ "not found.").

  Open Scope parser_scope.

  Definition chooseFrom {T} : list (parser T) -> parser T :=
    fold_right (fun p acc => p <|> acc) $ raise "chooseFrom: failed.".

  Definition expect (t : P) : parser unit :=
    firstExpect t $ ret tt.

  Fixpoint untilMulti_ (fuel : nat) (acc lt : list P) : parser (list P) :=
    match fuel with
    | O => raise "untilMulti_: out of fuel."
    | S fuel' =>
      (x <- satisfy (fun x => forallb (fun t => t <> x?) lt);;
       untilMulti_ fuel' (x :: acc) lt)
        <|> ret (rev' acc)
    end.

  Definition untilMulti' (fuel : nat) (lt : list P) : parser (list P) :=
    (res <- untilMulti_ fuel [] lt;; peek;; ret res)
      <|> raise ("untilMulti': " ++ to_string lt ++ " not found.").

  Definition untilMulti : list P -> parser (list P) := untilMulti' bigNumber.

  Definition until (t : P) : parser (list P) := untilMulti [t].

End Parser.

Arguments anyToken     {_}.
Arguments chooseFrom   {_ _}.
Arguments expect       {_ _ _}.
Arguments firstExpect  {_ _ _ _}.
Arguments ifFirst      {_ _ _ _}.
Arguments many         {_ _}.
Arguments many1        {_ _}.
Arguments manyN        {_ _}.
Arguments parser       {_}.
Arguments peek         {_}.
Arguments satisfy      {_ _}.
Arguments until        {_ _}.
Arguments untilMulti   {_ _}.

Definition parse {T} (p : parser T) (str : string) : string + T :=
  evalStateT p (list_ascii_of_string str).
