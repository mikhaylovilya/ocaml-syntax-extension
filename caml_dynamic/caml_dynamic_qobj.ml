module CamlDynamicQObj : sig
  type 'a mycppobj = [ `Cppobj ]
  type t

  val create : unit -> t
  val create_func : t -> name:string -> f:(unit -> unit) -> unit
  val to_lablqml_cppobj : t -> t mycppobj

  (* val create_slot : t -> name:string -> slot:(unit -> unit) -> unit
     val connect_slot : unit -> unit
     val connect_signal : unit -> unit
     val emit_signal : unit -> unit *)
  (*bool emitDynamicSignal(char *signal, void **arguments);
    bool connectDynamicSlot(QObject *obj, char *signal, char *slot);
    bool connectDynamicSignal(char *signal, QObject *obj, char *slot);*)
end = struct
  type 'a mycppobj = [ `Cppobj ]
  type t = t mycppobj

  external create_stub : unit -> t = "caml_create_camldynamicqobj"

  let create () = create_stub ()

  external create_func_stub : t -> string -> (unit -> unit) -> unit
    = "caml_create_func"

  let create_func t ~name ~f = create_func_stub t name f
  let to_lablqml_cppobj : t -> t mycppobj = fun x -> x
end
