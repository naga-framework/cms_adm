-module(adm_users).
-export([index/3, 
         profile/3,
         event/1
        ]).
-default_action(index).
-actions([index,profile]).

-include_lib("n2o/include/wf.hrl").
-include_lib("naga/include/naga.hrl").
-include_lib("kvs/include/feed.hrl").
-include("cms.hrl").

%--------------------------------------------------------------------------------
% INDEX CONTROLLER
%--------------------------------------------------------------------------------
index(<<"GET">>, _, #{identity:=Identity} = Ctx) -> 
  Bindings = adm_lib:bindings(Identity,?_CSS,?_JS),
  %%FIXME:pagination?
  Users = kvs:entries(kvs:get(feed,xuser), xuser, undefined),
  {ok, Bindings ++ [{users, Users}]}.

%--------------------------------------------------------------------------------
% PROFILE CONTROLLER
%--------------------------------------------------------------------------------
profile(<<"GET">>, _, #{identity:=Identity} = Ctx) -> 
  Bindings = adm_lib:bindings(Identity,?_CSS,?_JS),
  {ok, Bindings}.
      
%--------------------------------------------------------------------------------
% EVENT HANDLING
%--------------------------------------------------------------------------------
event(init) ->    
  io:format(">>>>ADM USERS EVT:init~n",[]);

event({update,userInfo,Email}) -> updateUserInfo(wf:user(),Email);
event({change,password,User})  -> changePassword(wf:user(),User);
event(Event) -> 
  wf:info(?MODULE,"Unknown Event: ~p~n",[Event]).


%--------------------------------------------------------------------------------
% INTERNAL
%--------------------------------------------------------------------------------
% updateUserInfo
% -------------------------------------------------------------------------------
updateUserInfo(Identity,Email) ->
  case acl:write(Identity,Email,firstname) =:= allow andalso 
       acl:write(Identity,Email,lastname)  =:= allow of
    true -> {ok, User} = xuser:find_by_email(Email),
            Id = User:get(id),
            {ok,U} = xuser:get(Id), 
            U1 = lists:foldl(fun(F,A)-> A:set(F,wf:q(F)) end,U,[firstname,lastname]),
            case catch U1:save() of
              {ok,New} -> identity:update(Identity,New), 
                adm_lib:notify(success,"Udpate profile", "profile updated.");
              Err -> adm_lib:notify(error,"Error udpate profile", wf:to_list(Err) )
            end;
    false-> adm_lib:notify(error,"Udpate profile", "not authorized.")
  end.

% -------------------------------------------------------------------------------
% changePassword
% -------------------------------------------------------------------------------
changePassword(Identity,Email) ->
  Identity = wf:user(),
  case acl:write(Identity,Email,password) =:= allow of
    true ->  Password = wf:q(password),
             Confirm = wf:q(confirm),
             case Password =:= Confirm of
              true -> {ok, U} = xuser:find_by_email(Email),
                      case catch U:update_password(Password) of
                        {ok,New} -> identity:update(Identity,New),  
                          adm_lib:notify(success,"Change password", "password updated.");
                        Err -> adm_lib:notify(error,"Error change password", wf:to_list(Err))
                      end;
              false-> adm_lib:notify(error,"Change password", "doesn't match.")
             end;
             
    false -> adm_lib:notify(error,"Udpate password", "not authorized.")
  end.