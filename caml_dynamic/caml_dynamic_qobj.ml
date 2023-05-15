module CamlDynamicQObj : sig
  (*bool emitDynamicSignal(char *signal, void **arguments);
    bool connectDynamicSlot(QObject *obj, char *signal, char *slot);
    bool connectDynamicSignal(char *signal, QObject *obj, char *slot);*)
  type t

  val create : unit -> t
  val create_slot : t -> name:string -> slot:(unit -> unit) -> unit
  val connect_slot : unit -> unit (*dummy*)
  val connect_signal : unit -> unit (*dummy*)
  val emit_signal : unit -> unit (*dummy*)
end = struct
  type 'a cppobj = [ `Cppobj ]
  type t = t cppobj

  external create_stub : unit -> t = "caml_create_camldynamicqobj"

  let create () = create_stub ()

  external create_slot_stub : t -> string -> (unit -> unit) -> unit
    = "caml_create__dynamic_slot"

  let create_slot t ~name ~slot = create_slot_stub t name slot
  let connect_slot () = ()
  let connect_signal () = ()
  let emit_signal () = ()
end
