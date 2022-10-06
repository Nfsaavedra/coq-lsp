type t

val marshal_in : in_channel -> t
val marshal_out : out_channel -> t -> unit
val of_coq : Vernacstate.t -> t
val to_coq : t -> Vernacstate.t
val compare : t -> t -> int
val mode : st:t -> Pvernac.proof_mode option
val parsing : st:t -> Vernacstate.Parser.t
val lemmas : st:t -> Vernacstate.LemmaStack.t option
val in_state : st:t -> f:('a -> 'b) -> 'a -> 'b

(* Error recovery *)
val drop_proofs : st:t -> t