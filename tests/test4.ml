(* open Lablqml
   open Caml_dynamic.Caml_dynamic_qobj

   let test1 () =
     let app, engine = create_qapplication Sys.argv in

     let single = CamlDynamicQObj.create () in

     set_context_property
       ~ctx:(get_view_exn ~name:"rootContext")
       ~name:"runner"
       (CamlDynamicQObj.create_func single ~f(fun () -> Printf.printf "single func in OCaml\n%!") ~name:"runner"));

     let w = loadQml "./tests/test4.qml" engine in
     assert (w <> None);
     let _w =
       match w with Some w -> w | None -> failwith "can't create window"
     in

     QGuiApplication.exec app;
     ()

   let () = test1 () *)
