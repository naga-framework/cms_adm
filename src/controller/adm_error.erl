-module(adm_error).
-export(['404'/3]).
-actions(['404']).
-default_action('404').
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include("cms.hrl").

%--------------------------------------------------------------------------------
% CONTROLLER
%--------------------------------------------------------------------------------
'404'(_, _, Ctx)   -> 
  CSS =[bootstrap3,fontawesome,nprogress,gentelella],
  JS  =[jquery,bootstrap3,fastclick,nprogress,gentelella],
  {ok, adm_lib:bindings(CSS,JS)}.
