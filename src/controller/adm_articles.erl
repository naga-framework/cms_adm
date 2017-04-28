-module(adm_articles).
-export([index/3
        ,article/3
        ,event/1
        ]).
-default_action(index).
-actions([index]).

-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("naga/include/naga.hrl").
-include("cms.hrl").

%--------------------------------------------------------------------------------
% CONTROLLER
%--------------------------------------------------------------------------------
index(<<"GET">>, _, #{identity:=Identity} = Ctx) -> 
  Bindings = adm_lib:bindings(Identity,?_CSS,?_JS),
  Articles = kvs:entries(kvs:get(feed,article), article, undefined),
  {ok, Bindings ++ [{articles, Articles}]}.

article(<<"GET">>, [<<"add">>|R], #{identity:=Identity} = Ctx) ->
  Bindings = adm_lib:bindings(Identity,?_CSS,?_JS),
  Articles = kvs:entries(kvs:get(feed,article), article, undefined),
  {ok, Bindings ++ [{articles, Articles}]}.

%--------------------------------------------------------------------------------
% EVENT
%--------------------------------------------------------------------------------
event(Event) -> 
  wf:info(?MODULE,"Unknown Event: ~p~n",[Event]).