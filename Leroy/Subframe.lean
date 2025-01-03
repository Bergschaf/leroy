/-
Copyright (c) 2024 Christian Krause. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Krause
-/
import Mathlib.Order.CompleteSublattice
/-!
A Subframe is a CompleteSublattice where the parent type is a frame.
-/

variable (α β: Type*) [Order.Frame α] [Order.Frame β]

variable (S : CompleteSublattice α)

instance instFrame : Order.Frame S :=
  Order.Frame.ofMinimalAxioms ( Subtype.coe_injective.frameMinimalAxioms
    ⟨Order.Frame.inf_sSup_le_iSup_inf⟩ _ (fun _ _ ↦ rfl) (fun _ _ ↦ rfl)
     CompleteSublattice.coe_sSup' CompleteSublattice.coe_sInf' (rfl) (rfl))
