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


css(Vendors) -> 
  lists:foldr(fun({X,L},Acc) -> [X:vendors(css,L)|Acc];
                 ({X},Acc)   -> [X:vendors(css)|Acc]
              end, [], Vendors).

js(Vendors) -> 
  lists:foldr(fun({X,L},Acc) -> [X:vendors(js,L)|Acc];
                 ({X},Acc)   -> [X:vendors(js)|Acc]
              end, [], Vendors).

bindings(Identity, VendorsCSS, VendorsJS) ->               
  CSS = css(VendorsCSS),
  JS  = js(VendorsJS),
   [
    {identity, Identity},
    {app, [{name,?APP_NAME},
           {vsn,?APP_VSN},
           {credit, ?CREDIT}
           ]},
    {page,[{css,CSS},
           {title,"CMS Demo"},
           {js,JS}]}
   ].

bindings(VendorsCSS, VendorsJS) ->               
  CSS = gentelella:vendors(css,VendorsCSS),
  JS  = gentelella:vendors(js,VendorsJS),
   [
    {app, [{name,?APP_NAME},
           {vsn,?APP_VSN},
           {credit, ?CREDIT}
           ]},
    {page,[
           {css,CSS},
           {title,"CMS Demo"},
           {js,JS}]}
   ].