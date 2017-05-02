-module(adm_lib).

-compile(export_all).

-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("naga/include/naga.hrl").
-include("cms.hrl").

-define(CREDIT,"CMS with Gentelella "
               "Bootstrap Admin Template, powered by "
               "<a href='http://github.com/naga-framework/naga'>naga-framework</a>").

notify(Type,Title,Msg) -> gentelella:pnotify(Type,Title,Msg).

redirect(Sec,Redirect) ->
  wf:wire(wf:f("setTimeout(function(){window.location='~s';}, ~B);",
          [Redirect,1000*Sec])). 

refresh() -> wf:wire("window.location=window.location;"). 

bindings(Identity) ->               
 [
  {identity, Identity},
  {app, [{name,?APP_NAME},
         {vsn,?APP_VSN},
         {credit, ?CREDIT}
         ]},
  {page,[{title,"CMS Demo"}]}
 ].