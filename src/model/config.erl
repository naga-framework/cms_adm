-module(config).
-include_lib("kvs/include/metainfo.hrl").
-include("cms.hrl").
-include("config.hrl").
-compile(export_all).
-define(db,cms_db).

metainfo() -> ?table(config     ,[]).


% -----------------------------------------------------------------------------
% 
% -----------------------------------------------------------------------------

init() ->
   [{features, features()},
    {status,   init},
    {node,     node()},
    {nodes,    nodes()},
    {app_name, ?APP_NAME},
    {app_vsn,  ?APP_VSN},
    {password, {sha256, <<"salt">>, 4096, 20}}
   ].

features() -> 
  [#feature{id={read,article}  ,name="Read an article."},
   #feature{id={write,article} ,name="Create/Edit/Delete article."},
   #feature{id={aprove,article},name="Aprove an article."},

   #feature{id={read,category} ,name="Read a category."},
   #feature{id={write,category},name="Create/Edit/Delete a category."},

   #feature{id={read,post}     ,name="Read a post."},
   #feature{id={write,post}    ,name="Create/Reply a post."}
  ].

% -----------------------------------------------------------------------------
% 
% -----------------------------------------------------------------------------

%%getter/setter a la boss_db
attribute_names()  -> ?db:attribute_names(?MODULE).
attribute_names(_) -> ?db:attribute_names(?MODULE).

attribute_types()  -> ?db:attribute_types(?MODULE).
attribute_types(_) -> ?db:attribute_types(?MODULE).

attribute_idx()    -> ?db:attribute_idx(?MODULE).
attribute_idx(_)   -> ?db:attribute_idx(?MODULE).

attributes(R)-> ?db:attributes(R).

get(Id)      -> kvs:get(config,Id).
get(F,R)     -> ?db:get_value(F,R).
set(F,V,R)   -> ?db:set_value(F,V,R).
new()        -> ?db:new_record(?MODULE).
new(L)       -> ?db:new(?MODULE,L).
to_maps(R)   -> ?db:to_maps(R).
to_json(R)   -> ?db:to_json(R).

prepare_json(L) -> prepare_json(L,[]).
prepare_json([],Acc)    -> Acc;
prepare_json([{K,undefined}|T],Acc) -> prepare_json(T,[{K,<<>>}]++Acc);
prepare_json([{K,V}|T],Acc) -> prepare_json(T,[{K,V}]++Acc).


save(R) -> kvs:put(R).
