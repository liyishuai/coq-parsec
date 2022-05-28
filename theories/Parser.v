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
     Functor
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
  FunctorNotation
  ListNotations
  MonadNotation.
Open Scope string_scope.
Open Scope monad_scope.
Open Scope program_scope.
#[global]
Existing Instance Monad_stateT.

#[global]
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

  Definition parser := stateT (list P) (sum (option string)).
  Bind Scope parser_scope with parser.

  Definition anyToken : parser P :=
    xs <- get;;
    match xs with
    | []    => raise None
    | x::xs' => put xs';; ret x
    end.

  Definition peek : parser P :=
    xs <- get;;
    match xs with
    | []  => raise None
    | x::_ => ret x
    end.

  Definition guard {T} (f : T -> bool) (pT : parser T) : parser T :=
    t <- pT;;
    if f t
    then ret t
    else raise $ Some "Guard failed".

  Definition satisfy (f : P -> bool) : parser P :=
    x <- anyToken;;
    if f x
    then ret x
    else raise $ Some $ "Unsatisfying: " ++ to_string x.

  Definition maybe {T} (p : parser T) : parser (option T) :=
    Some <$> p <|> ret None.

  Fixpoint many_ {T} (acc : list T) (fuel : nat) (p : parser T) : parser (list T) :=
    match fuel with
    | O => raise $ Some "many_: out of fuel."
    | S fuel' => (t <- p;; many_ (t::acc) fuel' p) <|> ret (rev' acc)
    end.

  Definition many' {T} : nat -> parser T -> parser (list T) := many_ [].

  Definition many {T} : parser T -> parser (list T) := many' bigNumber.

  Definition many1 {T} (p : parser T) : parser (list T) := liftA2 cons p (many p).

  Definition manyN {T} (n : nat) (p : parser T) : parser (list T) :=
    sequence (repeat p n).

  Definition firstExpect {T} (t : P) (pr : parser T) : parser T :=
    (satisfy (fun x => t = x?);; pr).

  Definition ifFirst {T} (t : P) (pr : parser T) : parser T :=
    (guard (fun x => t = x?) peek;; pr)
      <|> raise (Some $ "ifFirst: " ++ to_string t ++ "not found.").

  Open Scope parser_scope.

  Definition chooseFrom {T} : list (parser T) -> parser T :=
    fold_right (fun p acc => p <|> acc) $ raise $ Some "chooseFrom: failed.".

  Definition expect (t : P) : parser P :=
    firstExpect t $ ret t.

  Fixpoint untilMulti_ (fuel : nat) (acc lt : list P) : parser (list P) :=
    match fuel with
    | O => raise $ Some "untilMulti_: out of fuel."
    | S fuel' =>
      (x <- satisfy (fun x => forallb (fun t => t <> x?) lt);;
       untilMulti_ fuel' (x :: acc) lt)
        <|> ret (rev' acc)
    end.

  Definition untilMulti' (fuel : nat) (lt : list P) : parser (list P) :=
    (res <- untilMulti_ fuel [] lt;; peek;; ret res)
      <|> raise None.

  Definition untilMulti : list P -> parser (list P) := untilMulti' bigNumber.

  Definition until (t : P) : parser (list P) := untilMulti [t].

End Parser.

Arguments anyToken     {_}.
Arguments chooseFrom   {_ _}.
Arguments expect       {_ _ _}.
Arguments firstExpect  {_ _ _ _}.
Arguments ifFirst      {_ _ _ _}.
Arguments guard        {_ _}.
Arguments many         {_ _}.
Arguments many1        {_ _}.
Arguments manyN        {_ _}.
Arguments maybe        {_ _}.
Arguments parser       {_}.
Arguments peek         {_}.
Arguments satisfy      {_ _}.
Arguments until        {_ _ _}.
Arguments untilMulti   {_ _ _}.

Definition parse {T} (p : parser T) (str : string) : option string + T * string :=
  match runStateT p (list_ascii_of_string str) with
  | inl e => inl e
  | inr (s, l) => inr (s, string_of_list_ascii l)
  end.
