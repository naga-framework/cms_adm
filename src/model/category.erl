-module(category).
-include_lib("kvs/include/metainfo.hrl").
-include("cms.hrl").
-include("category.hrl").
-compile(export_all).
-define(db,cms_db).


metainfo() -> ?table(category   ,?category_keys).

%%getter/setter a la boss_db
attribute_names()  -> ?db:attribute_names(?MODULE).
attribute_names(_) -> ?db:attribute_names(?MODULE).

attribute_types()  -> ?db:attribute_types(?MODULE).
attribute_types(_) -> ?db:attribute_types(?MODULE).

attribute_idx()    -> ?db:attribute_idx(?MODULE).
attribute_idx(_)   -> ?db:attribute_idx(?MODULE).

attributes(R)-> ?db:attributes(R).

get(F,R)     -> ?db:get_value(F,R).
set(F,V,R)   -> ?db:set_value(F,V,R).
new()        -> ?db:new_record(?MODULE).
new(L)       -> ?db:new(?MODULE,L).
to_maps(R)   -> ?db:to_maps(R).
to_json(R)   -> ?db:to_json(R).

prepare_json(L) -> prepare_json(L,[]).

prepare_json([],Acc)    -> Acc;
prepare_json([{K,undefined}|T],Acc) -> prepare_json(T,[{K,<<>>}]++Acc);
prepare_json([{'$_data',_}|T],Acc) -> prepare_json(T,Acc);
prepare_json([{K,V}|T],Acc) -> prepare_json(T,[{K,V}]++Acc).

% -----------------------------------------------------------------------------
% 
% -----------------------------------------------------------------------------
before_create(R) -> N = ?db:set_value(modified,naga:to_seconds(),R),
                    {ok, N}.

save(R)    -> ?db:save(R).

% -----------------------------------------------------------------------------
% 
% -----------------------------------------------------------------------------
exist(N) -> case kvs:index(category,name,N) of [] -> false;[R|_] -> {ok,R} end. 
 