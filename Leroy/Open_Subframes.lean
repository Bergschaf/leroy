import Leroy.Nucleus
import Mathlib.Topology.Bases
import Mathlib.Order.CompleteSublattice
import Leroy.Subframes
open CategoryTheory

variable {X Y E: Type u} [Order.Frame X] [Order.Frame Y] [Order.Frame E]


def e_U (U : E) (H : E) : E :=
  sSup {W : E | W ⊓ U ≤ H}

lemma e_U_idempotent (U : E) (H : E) : e_U U (e_U U H) = e_U U H := by
  simp [e_U]
  apply le_antisymm_iff.mpr
  apply And.intro
  . apply sSup_le_iff.mpr
    simp
    intro b h
    have h1 : sSup {W | W ⊓ U ≤ H} ⊓ U ≤ H := by
      simp [sSup_inf_eq]

    apply le_sSup
    simp
    apply_fun (. ⊓ U) at h
    dsimp at h
    let h3:= le_trans h h1
    simp at h3
    exact h3
    rw [Monotone]
    intro a b h
    exact inf_le_inf_right U h


  . apply sSup_le_iff.mpr
    simp
    intro b h
    apply le_sSup
    simp
    have h2 : H ≤ sSup {W | W ⊓ U ≤ H} := by
      apply le_sSup
      simp
    apply le_trans h h2

def e_U_increasing (U : E) (H : E) : H ≤ e_U U H := by
  simp only [e_U, Set.mem_setOf_eq, inf_le_left, le_sSup]

def e_U_preserves_inf (U: E) (H : E) (J : E) : e_U U (H ⊓ J) = e_U U H ⊓ e_U U J := by
  apply le_antisymm_iff.mpr
  apply And.intro
  . apply le_inf_iff.mpr
    apply And.intro
    . simp [e_U]
      intro b h1 h2
      apply le_sSup
      simp [h1, h2]
    . simp [e_U]
      intro b h1 h2
      apply le_sSup
      simp [h1, h2]
  . simp [e_U, sSup_inf_sSup]
    intro a b h1 h2
    apply le_sSup
    simp_all only [Set.mem_setOf_eq]
    apply And.intro
    · have h3 : a ⊓ b ⊓ U ≤ a ⊓ U := by
        simp
        refine inf_le_of_left_le ?h
        exact inf_le_left
      apply le_trans h3 h1
    · have h3 : a ⊓ b ⊓ U ≤ b ⊓ U := by
        simp
        rw [inf_assoc]
        apply inf_le_of_right_le
        exact inf_le_left
      apply le_trans h3 h2

def eckig (U : E) : Nucleus E where
  toFun := e_U U
  idempotent := e_U_idempotent U
  increasing := e_U_increasing U
  preserves_inf := e_U_preserves_inf U



def is_open (e : Nucleus E) : Prop :=
  ∃ u : E, eckig u = e
-- TODO typeclass
--class Open extends Subframe E where
--  is_open : ∃ u : E, eckig u = e


def Opens (E : Type*) [Order.Frame E] := {e : Nucleus E // is_open e}

instance : Coe (Opens E) (Nucleus E) where
  coe x := Subtype.val x

instance : Coe (Set (Opens E)) (Set (Nucleus E)) where
  coe x := Subtype.val '' x


-- Leroy Lemme 6


lemma leroy_6a (x : Nucleus E) (U : E) : x ≤ eckig U ↔ (x U = ⊤) := by
  apply Iff.intro
  . intro h
    simp[le] at h
    let h1 := h U
    have h2 : (eckig U) U = ⊤ := by
      simp [eckig, e_U]
    exact eq_top_mono (h U) h2
  . intro h
    simp [eckig, le]
    intro v
    simp [ e_U]
    intro b h1
    apply_fun x.toFun at h1
    rw [x.preserves_inf] at h1
    simp at h1
    rw [h] at h1
    simp at h1
    apply le_trans (x.increasing b) h1
    exact Nucleus.monotone x








lemma leroy_6b {U V : E} : e_U (U ⊓ V) = e_U U ∘ e_U V := by
  ext x
  simp [e_U]
  apply le_antisymm
  . apply sSup_le_sSup
    simp only [Set.setOf_subset_setOf]
    intro a h
    apply le_sSup
    simp
    rw [inf_assoc]
    exact h
  . apply sSup_le_sSup
    simp only [Set.setOf_subset_setOf]
    intro a h
    apply_fun (fun x ↦ x ⊓ V) at h
    dsimp at h
    have h1 : sSup {W | W ⊓ V ≤ x} ⊓ V ≤ x := by
      rw [sSup_inf_eq]
      simp only [Set.mem_setOf_eq, iSup_le_iff, imp_self, implies_true]
    rw [inf_assoc] at h
    exact Preorder.le_trans (a ⊓ (U ⊓ V)) (sSup {W | W ⊓ V ≤ x} ⊓ V) x h h1
    rw [Monotone]
    exact fun ⦃a b⦄ a_1 => inf_le_inf_right V a_1

lemma e_U_comm {U V : E} : e_U U ∘ e_U V = e_U V ∘ e_U U := by
  ext x
  simp [e_U]
  apply le_antisymm
  . apply sSup_le_sSup
    simp only [Set.setOf_subset_setOf]
    intro a h
    apply le_sSup
    simp
    apply_fun (fun x ↦ x ⊓ V) at h
    dsimp at h
    have h1 : sSup {W | W ⊓ V ≤ x} ⊓ V ≤ x := by
      rw [sSup_inf_eq]
      simp only [Set.mem_setOf_eq, iSup_le_iff, imp_self, implies_true]
    rw [inf_assoc]
    rw [inf_comm V U]
    rw [← inf_assoc]
    exact Preorder.le_trans (a ⊓ U ⊓ V) (sSup {W | W ⊓ V ≤ x} ⊓ V) x h h1
    rw [Monotone]
    exact fun ⦃a b⦄ a_1 => inf_le_inf_right V a_1
  . apply sSup_le_sSup
    simp only [Set.setOf_subset_setOf]
    intro a h
    apply le_sSup
    simp
    apply_fun (fun x ↦ x ⊓ U) at h
    dsimp at h
    have h1 : sSup {W | W ⊓ U ≤ x} ⊓ U ≤ x := by
      rw [sSup_inf_eq]
      simp only [Set.mem_setOf_eq, iSup_le_iff, imp_self, implies_true]
    rw [inf_assoc]
    rw [inf_comm U V]
    rw [← inf_assoc]
    exact Preorder.le_trans (a ⊓ V ⊓ U) (sSup {W | W ⊓ U ≤ x} ⊓ U) x h h1
    rw [Monotone]
    exact fun ⦃a b⦄ a_1 => inf_le_inf_right U a_1

lemma eckig_preserves_inclusion {U V : E} : U ≤ V ↔ eckig U ≤ eckig V := by
  apply iff_iff_implies_and_implies.mpr
  apply And.intro
  . intro h
    simp [eckig, le, e_U]
    intro v b h1
    apply le_sSup
    simp
    have h2 : b ⊓ U ≤ b ⊓ V := by
      exact inf_le_inf_left b h
    exact Preorder.le_trans (b ⊓ U) (b ⊓ V) v h2 h1
  . intro h
    simp [eckig, le, e_U] at h
    let h1 := h V U
    simp at h1
    apply_fun (fun x ↦ x ⊓ U) at h1
    dsimp at h1
    have h2 : sSup {W | W ⊓ U ≤ V} ⊓ U ≤ V := by
      rw [sSup_inf_eq]
      simp only [Set.mem_setOf_eq, iSup_le_iff, imp_self, implies_true]
    have h3 : U ≤ U ⊓ U := by
      simp only [le_refl, inf_of_le_left]
    apply le_trans h3
    exact Preorder.le_trans (U ⊓ U) (sSup {W | W ⊓ U ≤ V} ⊓ U) V h1 h2
    rw [Monotone]
    exact fun ⦃a b⦄ a_1 => inf_le_inf_right U a_1



lemma eckig_preserves_inf (U V : E) : eckig (U ⊓ V) = eckig U ⊓ eckig V := by
  apply le_antisymm
  . sorry
  . rw [leroy_6a]



    simp [eckig, min, sInf, sSup, e_V_nucleus, e_V]
    apply eq_top_iff.mpr
    apply le_sSup
    simp only [Set.mem_setOf_eq, top_le_iff]
    intro x_i h1 h2
    apply (leroy_6a x_i (SemilatticeInf.inf U V)).mp
    simp [eckig, e_U]
    intro v b h3
    sorry








/-
  simp [eckig, leroy_6b, min, sInf, sSup, e_V_nucleus, e_V]
  ext x
  simp [e_U, eckig, min, sInf, sSup, e_V_nucleus, e_V]
  apply le_antisymm
  . apply sSup_le_sSup
    simp only [Set.setOf_subset_setOf]
    intro b h x_i h1 h2
    simp [le, e_U] at h1 h2

    apply le_sSup
    simp
    intro n h1 h2
    simp [le, e_U] at h1 h2
    have h3 := h1 (sSup {W | SemilatticeInf.inf W V ≤ x}) b h
    apply_fun (fun x ↦ x ⊓ V) at h3
    dsimp at h3
    have h4 := h2 (n (sSup {W | SemilatticeInf.inf W V ≤ x}) ⊓ V) b h3
    have h5 : n (n (sSup {W | SemilatticeInf.inf W V ≤ x}) ⊓ V) ≤ n x := by
      have h6 : (n (sSup {W | SemilatticeInf.inf W V ≤ x}) ⊓ V) ≤ x := by
        sorry
      apply_fun (fun x ↦ n x) at h6
      simp at h6
      exact h6
      exact n.monotone
    exact
      Preorder.le_trans b (n (n (sSup {W | SemilatticeInf.inf W V ≤ x}) ⊓ V)) (n x)
        (h2 (n (sSup {W | SemilatticeInf.inf W V ≤ x}) ⊓ V) b h3) h5
-/


--instance : Min (Opens X) where
--  min U V :=
