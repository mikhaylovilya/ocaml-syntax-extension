open Lablqml

type t

module CamlDynamicQObj : sig
  (* type 'a mycppobj = [ `Cppobj ] *)
  type t

  (* val create : unit -> t *)
  val create_func : name:string -> f:(unit -> unit) -> t
  val to_lablqml_cppobj : t -> t cppobj
  (* val to_lablqml_cppobj : t -> t mycppobj *)
end = struct
  (* type 'a mycppobj = [ `Cppobj ] *)
  (* type t = t mycppobj *)
  type nonrec t = t cppobj

  (* external create_stub : unit -> t = "caml_create_camldynamicqobj" *)

  (* let create () = create_stub () *)

  external create_func_stub : string -> (unit -> unit) -> t = "caml_create_func"

  let create_func ~name ~f = create_func_stub name f
  let to_lablqml_cppobj : t -> t cppobj = Obj.magic
end
