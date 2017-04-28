-module(acl).
-include_lib("kvs/include/metainfo.hrl").
-include_lib("kvs/include/kvs.hrl").
-include_lib("kvs/include/metainfo.hrl").
-include_lib("kvs/include/group.hrl").
-include_lib("kvs/include/feed.hrl").
-include("cms.hrl").
-include("acl.hrl").
-include("user.hrl").

-compile(export_all).
-define(db,cms_db).

metainfo() -> [#table{name=acl,container=true,fields=record_info(fields,acl),keys=[id,accessor]},
              ?table(access   ,?access_keys)].

%%getter/setter a la boss_db
attribute_names()  -> ?db:attribute_names(access).
attribute_names(_) -> ?db:attribute_names(access).

attribute_types()  -> ?db:attribute_types(access).
attribute_types(_) -> ?db:attribute_types(access).

attribute_idx()    -> ?db:attribute_idx(access).
attribute_idx(_)   -> ?db:attribute_idx(access).

attributes(R)-> ?db:attributes(R).


get(F,R)     -> ?db:get_value(F,R).
set(F,V,R)   -> ?db:set_value(F,V,R).
new()        -> ?db:new_record(access).
new(L)       -> ?db:new(access,L).
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
revoke(User,Feature) -> acl:define_access({user,User:get(email)}, {feature, Feature}, disable).
grant(User,Feature)  -> acl:define_access({user,User:get(email)}, {feature, Feature}, allow).

admin(U)    -> grant(U,admin).
author(U)   -> grant(U,author).
moderator(U)-> grant(U,moderator).

revoke(User) -> [revoke(User,F)||F<-config:features()].

is_admin(U) when is_tuple(U)   -> is_admin(U:get(email)); 
is_admin(Email) when is_list(Email)  -> acl:check_access({user,Email},{feature,admin}) =:= allow.

is_author(U) when is_tuple(U)  -> is_author(U:get(email));   
is_author(Email) when is_list(Email) -> acl:check_access({user,Email},{feature,author}) =:= allow.

is_moderator(U) when is_tuple(U)  -> is_moderator(U:get(email));
is_moderator(Email) when is_list(Email) -> acl:check_access({user,Email},{feature,moderator}) =:= allow.

is_blocked(U) when is_tuple(U)  -> is_blocked(U:get(email));
is_blocked(Email) when is_list(Email) -> acl:check_access({user,Email},{feature,blocked}) =:= allow.


write(#{is_admin:=true},_Obj,_Field) -> allow;
write(#{user:=#{email:=Email}}=_Identity,Obj,Field) -> 
    Feature = {write,Obj,Field}, 
    acl:check_access({user,Email},{feature,Feature}).

% -----------------------------------------------------------------------------
% 
% -----------------------------------------------------------------------------

next_id(K) -> case kvs:index(access,acl_id,K) of
                [] -> kvs:next_id(access,1);
                [#access{id=Id}] -> Id end.

define_access(Accessor, Resource, Action) ->
    Id = next_id({Accessor, Resource}),
    Entry = #access{ id=Id, acl_id={Accessor, Resource}, accessor=Accessor, action=Action},
    case kvs:add(Entry) of
        {error, exist} -> kvs:put(Entry#access{action=Action});
        {error, no_container} -> skip;
        {ok, E} -> E end.

index(Key) -> case kvs:index(access,acl_id, Key) of 
                [] -> {error, nofound};
                [R]-> {ok, R} end.

check(Keys) ->
    Acls = lists:flatten([ kvs:index(access,acl_id, Key) || Key <- Keys]),
    case Acls of
        [] -> none;
        [#access{action = Action} | _] -> Action end.

check_access(#{user := #{email:=Email}}, Feature) ->
    Query = [ {{user,Email},Feature} ],
    check(Query);

check_access(#xuser{email = Email}, Feature) ->
    Query = [ {{user,Email},Feature} ],
    check(Query);


check_access({user, Email}, Feature) ->
    case kvs:index(xuser,email, Email) of
        [] -> [];
        [U|_] -> check_access(U, Feature) end.


