(* Duplicated with coq_lsp *)
let coq_init ~debug =
  let load_module = Dynlink.loadfile in
  let load_plugin = Coq.Loader.plugin_handler None in
  Coq.Init.(coq_init { debug; load_module; load_plugin })

let sanitize_paths message =
  match Sys.getenv_opt "FCC_TEST" with
  | None -> message
  | Some _ ->
    let home_re = Str.regexp "coqlib is at: .*$" in
    Str.global_replace home_re "coqlib is at: [TEST_PATH]" message

let log_workspace ~io (dir, w) =
  let message, extra = Coq.Workspace.describe w in
  Fleche.Io.Log.trace "workspace" ("initialized " ^ dir) ~extra;
  let message = sanitize_paths message in
  Fleche.Io.Report.message ~io ~lvl:3 ~message

let load_plugin plugin_name = Fl_dynload.load_packages [ plugin_name ]
let plugin_init = List.iter load_plugin

let go args =
  let { Args.roots; display; debug; files; plugins } = args in
  (* Initialize event callbacks *)
  let io = Output.init display in
  (* Initialize Coq *)
  let debug = debug || Fleche.Debug.backtraces || !Fleche.Config.v.debug in
  let root_state = coq_init ~debug in
  let cmdline =
    { Coq.Workspace.CmdLine.coqcorelib =
        Filename.concat Coq_config.coqlib "../coq-core/"
    ; coqlib = Coq_config.coqlib
    ; ocamlpath = None
    ; vo_load_path = []
    ; ml_include_path = []
    ; args = []
    }
  in
  let roots = if List.length roots < 1 then [ Sys.getcwd () ] else roots in
  let workspaces =
    List.map (fun dir -> (dir, Coq.Workspace.guess ~cmdline ~debug ~dir)) roots
  in
  List.iter (log_workspace ~io) workspaces;
  let cc = Cc.{ root_state; workspaces; io } in
  (* Initialize plugins *)
  plugin_init plugins;
  Compile.compile ~cc files
