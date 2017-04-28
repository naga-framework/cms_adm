-module(adm_dashboard).
-export([index/3, 
         event/1
        ]).
-default_action(index).
-actions([index]).

-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("naga/include/naga.hrl").
-include("cms.hrl").


%--------------------------------------------------------------------------------
% INDEX CONTROLLER
%--------------------------------------------------------------------------------
index(<<"GET">>, _, #{identity:=Identity} = Ctx)   -> 
  Bindings = adm_lib:bindings(Identity,?_CSS,?_JS),  
  {ok, Bindings}.

%--------------------------------------------------------------------------------
% EVENT HANDLING (ws)
%--------------------------------------------------------------------------------        
event(Event) -> 
  wf:info(?MODULE,"Unknown Event: ~p~n",[Event]).