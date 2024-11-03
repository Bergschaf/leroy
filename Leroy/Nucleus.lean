import Leroy.Basic
open CategoryTheory

variable {X Y E: Type u} [TopologicalSpace X] [TopologicalSpace Y] [TopologicalSpace E]

class Nucleus (e : O X ⥤ O X) where
  idempotent (x : O X) : e.obj (e.obj x) = x
  increasing (x : O X) : x ⟶ e.obj x
  preserves_inf (x y : O X) : e.obj (x ⊓ y) = e.obj x ⊓ e.obj y

--- obacht leroy hat entwender E oder X vertauscht oder f_untenstern und f_obenstern
lemma nucleus_properties (e : O E ⥤ O E) [Nucleus e] : ∃ (X : Type (u + 1)),∃ (h : TopologicalSpace X), ∃ f : C(X, E), e = (f_obenstern f) ⋙ (f_untenstern f) := by


structure Subframe (X : Type*) [TopologicalSpace X] where
  e : O X ⥤ O X
  nucleus : Nucleus e

-- Leroy CH 3
instance : LE (Subframe X) where
  le x y := ∀ v : O X, y.e.obj v ≤ x.e.obj v

def Image (s : Subframe X) : Set (O X) :=
  {v : O X | s.e.obj v = v}



-- können wir Embedding einfach verwenden?
