-module(cms_adm).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1, main/1]).
-compile(export_all).
-include("cms.hrl").

main(A)    -> mad_repl:sh(A).
start(_,_) -> supervisor:start_link({local,cms_adm }, cms_adm,[]).
stop(_)    -> ok.
init([])   -> ensure_loaded(),
              ensure_dir(),
              kvs:join(),
              init_cms(),
              admin(wf:config(cms,   adm_email,"admin@localhost.com"),
                    wf:config(cms,adm_username,"admin"),
                    wf:config(cms,adm_password,"123456")),
              naga:watch([cms_adm]),
              sup().
sup()      -> { ok, { { one_for_one, 5, 100 }, [] } }.

log_modules() -> [n2o_client,
                  n2o_nitrogen,
                  n2o_stream,
                  wf_convert,
                  cms_adm,
                  cms_adm_lib,
                  adm_articles,
                  adm_auth,
                  adm_error,
                  adm_users,
                  cms_adm_routes].

ensure_loaded() ->
  case application:get_key(cms,modules) of 
    undefined -> skip;
    {ok,Modules} -> [code:ensure_loaded(M)||M<-Modules] 
  end.

ensure_dir() ->
  Data = wf:config(cms_adm, data_dir, filename:join([".","data"]) ),
  DB   = filename:join([Data, "db"]),
  file:make_dir(Data),
  file:make_dir(DB).

init_cms() ->
  case config:get(status) of 
    {error,not_found} -> 
      lists:map(fun({K,V}) -> 
                  Cfg = config:new([{key,K},{value,V}]),
                  Cfg:save()
                end,config:init());
    _ -> skip 
  end.

admin() ->        
  Email = getinput("   email: "),
  Name  = getinput("username: "),
  Pass  =  getpass("password: "),
  admin(Email,Name,Pass).

admin(Email,Name,Pass) ->
  User  = xuser:new([{email,Email},
                     {username,Name},
                     {password,Pass}]),
  case User:save() of
    {ok, U} ->
      acl:grant(U,{write,Email,firstname}),
      acl:grant(U,{write,Email,lastname}),
      acl:grant(U,{write,Email,password}),

      acl:grant(U, author),
      acl:grant(U,{create,category}),
      acl:grant(U,{create,article}),

      acl:grant(U, admin),
      acl:grant(U,{add,user}),
      acl:grant(U,{block,user}),
      acl:grant(U,{reset,password});

    Err -> Err
  end.


getinput(Prompt) -> 
    Input = io:get_line(Prompt),
    case lists:reverse(Input) of
        [$\n | Rest] ->
            lists:reverse(Rest);
        _ ->
            Input
    end.

getpass(Prompt) -> 
    InitialIOOpts = io:getopts(),
    ok = io:setopts([{echo, false}]),
    Input = io:get_line(Prompt),
    ok = io:setopts(InitialIOOpts),
    io:format("\n"),
    case lists:reverse(Input) of
        [$\n | Rest] ->
            lists:reverse(Rest);
        _ ->
            Input
    end.