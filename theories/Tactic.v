(*******************************************************************************)
(*                           *                     Trakt                       *)
(*  _______        _    _    *            Copyright (C) 2022 MERCE             *)
(* |__   __|      | |  | |   *     (Mitsubishi Electric R&D Centre Europe)     *)
(*    | |_ __ __ _| | _| |_  *        Enzo Crance <enzo.crance@inria.fr>       *)
(*    | | '__/ _` | |/ / __| ***************************************************)
(*    | | | | (_| |   <| |_  * This file is distributed under the terms of the *)
(*    |_|_|  \__,_|_|\_\\__| *   GNU Lesser General Public License Version 3   *)
(*                           *  (see LICENSE file for the text of the license) *)
(*******************************************************************************)

From elpi Require Import elpi.

From Trakt Require Import InternalProofs.
From Trakt Require Export Database.

From Trakt.Elpi Extra Dependency "types.elpi" as types_elpi.
From Trakt.Elpi Extra Dependency "common.elpi" as common_elpi.
From Trakt.Elpi Extra Dependency "proof.elpi" as proof_elpi.
From Trakt.Elpi Extra Dependency "rewrite-identities.elpi" as rewrite_identities_elpi.
From Trakt.Elpi Extra Dependency "preprocess.elpi" as preprocess_elpi.
From Trakt.Elpi Extra Dependency "generalise-free-variables.elpi" as generalise_free_variables_elpi.
From Trakt.Elpi Extra Dependency "bool-to-prop.elpi" as bool_to_prop_elpi.
From Trakt.Elpi Extra Dependency "tactic.elpi" as tactic_elpi.
From Trakt.Elpi Extra Dependency "boolify-arrows.elpi" as boolify_arrows_elpi.
From Trakt.Elpi Extra Dependency "reorder-quantifiers.elpi" as reorder_quantifiers_elpi.

Elpi Tactic trakt.

Elpi Accumulate File types_elpi.
Elpi Accumulate Db embeddings.db.
Elpi Accumulate Db logic.db.
Elpi Accumulate Db symbols.db.
Elpi Accumulate Db relations.db.
Elpi Accumulate Db conversion.db.
Elpi Accumulate File common_elpi.
Elpi Accumulate File proof_elpi.
Elpi Accumulate File rewrite_identities_elpi.
Elpi Accumulate File preprocess_elpi.
Elpi Accumulate File generalise_free_variables_elpi.
Elpi Accumulate File bool_to_prop_elpi.
Elpi Accumulate File tactic_elpi.
Elpi Accumulate lp:{{
  solve InitialGoal NewGoals :-
    InitialGoal = goal Context _ InitialGoalTy _ [trm ETarget, trm LTarget, trm RuntimeRelData],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}), !,
    std.assert! (format-runtime-relation-data RuntimeRelData RuntimeRelCtx)
      "wrong runtime relations format",
    RuntimeRelCtx =>
      preprocess-extra InitialGoalTy Context (some ETarget) LTarget covariant true EndGoalTy Proof,
      refine {{ lp:Proof (_ : lp:EndGoalTy) }} InitialGoal NewGoals.

  solve InitialGoal NewGoals :-
    InitialGoal = goal Context _ InitialGoalTy _ [trm ETarget, trm LTarget],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}), !,
    [] =>
      preprocess-extra InitialGoalTy Context (some ETarget) LTarget covariant true EndGoalTy Proof,
      refine {{ lp:Proof (_ : lp:EndGoalTy) }} InitialGoal NewGoals.

  solve InitialGoal NewGoals :-
    InitialGoal = goal Context _ InitialGoalTy _ [trm LTarget, trm RuntimeRelData],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}), !,
    std.assert! (format-runtime-relation-data RuntimeRelData RuntimeRelCtx)
      "wrong runtime relations format",
    RuntimeRelCtx =>
      preprocess-extra InitialGoalTy Context none LTarget covariant true EndGoalTy Proof,
      refine {{ lp:Proof (_ : lp:EndGoalTy) }} InitialGoal NewGoals.

  solve InitialGoal NewGoals :-
    InitialGoal = goal Context _ InitialGoalTy _ [trm LTarget],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}), !,
    [] =>
      preprocess-extra InitialGoalTy Context none LTarget covariant true EndGoalTy Proof,
      refine {{ lp:Proof (_ : lp:EndGoalTy) }} InitialGoal NewGoals.

  solve _ _ :-
    coq.error "usage: trakt [target embedding type] <bool|Prop> [with rel <relations>]".
}}.
Elpi Typecheck.

Tactic Notation "trakt" constr(target) constr(logic_target) "with" "rel" constr(l) :=
  elpi trakt ltac_term:(target) ltac_term:(logic_target) ltac_term:(l).

Tactic Notation "trakt" constr(target) constr(logic_target) :=
  elpi trakt ltac_term:(target) ltac_term:(logic_target).

Tactic Notation "trakt" constr(logic_target) "with" "rel" constr(l) :=
  elpi trakt ltac_term:(logic_target) ltac_term:(l).

Tactic Notation "trakt" constr(logic_target) :=
  elpi trakt ltac_term:(logic_target).

Elpi Tactic trakt_pose.

Elpi Accumulate File types_elpi.
Elpi Accumulate Db embeddings.db.
Elpi Accumulate Db logic.db.
Elpi Accumulate Db symbols.db.
Elpi Accumulate Db relations.db.
Elpi Accumulate Db conversion.db.
Elpi Accumulate File common_elpi.
Elpi Accumulate File proof_elpi.
Elpi Accumulate File rewrite_identities_elpi.
Elpi Accumulate File preprocess_elpi.
Elpi Accumulate File generalise_free_variables_elpi.
Elpi Accumulate File bool_to_prop_elpi.
Elpi Accumulate File tactic_elpi.
Elpi Accumulate lp:{{
  solve Goal NewGoals :-
    Goal = goal _ _ GoalTy _ [trm ETarget, trm LTarget, trm H, str S, trm RuntimeRelData],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}),
    (H = global _ ; def H _ _ _ ; decl H _ _), !,
    coq.string->name S Name,
    std.assert! (format-runtime-relation-data RuntimeRelData RuntimeRelCtx)
      "wrong runtime relations format",
    coq.typecheck H T ok,
    RuntimeRelCtx =>
      preprocess-extra T [] (some ETarget) LTarget contravariant false T' P,
      refine (let Name T' (app [P, H]) (t\ {{ _ : lp:GoalTy }})) Goal NewGoals.

  solve Goal NewGoals :-
    Goal = goal _ _ GoalTy _ [trm ETarget, trm LTarget, trm H, str S],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}),
    (H = global _ ; def H _ _ _ ; decl H _ _), !,
    coq.string->name S Name,
    coq.typecheck H T ok,
    [] =>
      preprocess-extra T [] (some ETarget) LTarget contravariant false T' P,
      refine (let Name T' (app [P, H]) (t\ {{ _ : lp:GoalTy }})) Goal NewGoals.
  
  solve Goal NewGoals :-
    Goal = goal _ _ GoalTy _ [trm LTarget, trm H, str S, trm RuntimeRelData],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}),
    (H = global _ ; def H _ _ _ ; decl H _ _), !,
    coq.string->name S Name,
    std.assert! (format-runtime-relation-data RuntimeRelData RuntimeRelCtx)
      "wrong runtime relations format",
    coq.typecheck H T ok,
    RuntimeRelCtx =>
      preprocess-extra T [] none LTarget contravariant false T' P,
      refine (let Name T' (app [P, H]) (t\ {{ _ : lp:GoalTy }})) Goal NewGoals.
    
  solve Goal NewGoals :-
    Goal = goal _ _ GoalTy _ [trm LTarget, trm H, str S],
    (LTarget = {{ Prop }} ; LTarget = {{ bool }}),
    (H = global _ ; def H _ _ _ ; decl H _ _), !,
    coq.string->name S Name,
    coq.typecheck H T ok,
    [] =>
      preprocess-extra T [] none LTarget contravariant false T' P,
      refine (let Name T' (app [P, H]) (t\ {{ _ : lp:GoalTy }})) Goal NewGoals.
  
  solve _ _ :-
    coq.error {std.string.concat "\n" [
      "usage:",
      "  trakt_pose [target embedding type] <bool|Prop> :",
      "             <source constant> as <name for preprocessed term>",
      "             [with rel <relations>]"
    ]}.
}}.
Elpi Typecheck.

Tactic Notation "trakt_pose" constr(et) constr(lt) ":" constr(h) "as" ident(s) :=
  elpi trakt_pose ltac_term:(et) ltac_term:(lt) ltac_term:(h) ltac_string:(s).

Tactic Notation "trakt_pose"
  constr(et) constr(lt) ":" constr(h) "as" ident(s) "with" "rel" uconstr_list_sep(l, ",") :=
    elpi trakt_pose ltac_term:(et) ltac_term:(lt) ltac_term:(h) ltac_string:(s) ltac_term_list:(l).

Tactic Notation "trakt_pose" constr(lt) ":" constr(h) "as" ident(s) :=
  elpi trakt_pose ltac_term:(lt) ltac_term:(h) ltac_string:(s).

Tactic Notation "trakt_pose"
  constr(lt) ":" constr(h) "as" ident(s) "with" "rel" uconstr_list_sep(l, ",") :=
    elpi trakt_pose ltac_term:(lt) ltac_term:(h) ltac_string:(s) ltac_term_list:(l).

Elpi Tactic trakt_boolify_arrows.

Elpi Accumulate File types_elpi.
Elpi Accumulate Db logic.db.
Elpi Accumulate File common_elpi.
Elpi Accumulate File proof_elpi.
Elpi Accumulate File boolify_arrows_elpi.
Elpi Accumulate lp:{{
  solve ((goal _ _ GoalTy _ []) as InitialGoal) NewGoals :- !, std.do! [
    coq.elaborate-skeleton GoalTy _ EGoalTy ok,
    boolify-arrows EGoalTy covariant true GoalTy' Proof,
    build Proof CoqProof,
    refine {{ lp:CoqProof (_ : lp:GoalTy') }} InitialGoal NewGoals
  ].

  solve _ _ :-
    coq.error "usage: trakt_boolify_arrows.".
}}.
Elpi Typecheck.

Tactic Notation "trakt_boolify_arrows" := elpi trakt_boolify_arrows.

Elpi Tactic trakt_reorder_quantifiers.

Elpi Accumulate File types_elpi.
Elpi Accumulate File common_elpi.
Elpi Accumulate File reorder_quantifiers_elpi.
Elpi Accumulate lp:{{
  solve ((goal _ _ GoalTy _ []) as InitialGoal) NewGoals :- !, std.do! [
    coq.elaborate-skeleton GoalTy _ EGoalTy ok,
    reorder-goal EGoalTy Proof,
    coq.elaborate-skeleton Proof _ EProof ok,
    refine {{ lp:EProof _ }} InitialGoal NewGoals
  ].

  solve _ _ :-
    coq.error "usage: trakt_reorder_quantifiers.".
}}.
Elpi Typecheck.

Tactic Notation "trakt_reorder_quantifiers" := elpi trakt_reorder_quantifiers.
