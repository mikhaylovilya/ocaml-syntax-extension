module QDynamic : sig
  type t

  val create : unit -> t
  val add_slot : t -> name:string -> slot:(unit -> unit) -> unit
end = struct
  type t = Cppobj

  external create_stub : unit -> t = "caml_create_qdynamic"

  let create () = create_stub ()

  external add_slot_stub : t -> string -> (unit -> unit) -> unit
    = "caml_add_slot"

  let add_slot t ~name ~slot = add_slot_stub t name slot
end
