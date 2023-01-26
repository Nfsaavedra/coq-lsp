(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *   INRIA, CNRS and contributors - Copyright 1999-2018       *)
(* <O___,, *       (see CREDITS file for the list of authors)           *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(************************************************************************)
(* Coq Language Server Protocol                                         *)
(* Copyright 2019 MINES ParisTech -- LGPL 2.1+                          *)
(* Copyright 2019-2023 Inria -- LGPL 2.1+                               *)
(* Written by: Emilio J. Gallego Arias                                  *)
(************************************************************************)

module Config : sig
  type t = Fleche.Config.t [@@deriving yojson]
end

module Types : sig
  module Range : sig
    type t = Fleche.Types.Range.t [@@deriving yojson]
  end
end

val mk_diagnostics :
  uri:string -> version:int -> Fleche.Types.Diagnostic.t list -> Yojson.Safe.t

val mk_progress :
  uri:string -> version:int -> Fleche.Progress.Info.t list -> Yojson.Safe.t
