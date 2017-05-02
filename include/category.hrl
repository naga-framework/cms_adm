-ifndef(CATEGORY_HRL).
-define(CATEGORY_HRL, true).

-include_lib("kvs/include/kvs.hrl").
-include("cms_types.hrl").

-define(category_keys,[owner_id,name]).
-record(category, {?ITERATOR(feed),
           created        = 0  :: seconds(),
           modified       = 0  :: seconds(),
           author_id      = -1 :: fk(),
           name           = [] :: string(),
           title          = [] :: string(),
           desc           = [] :: string(),
           media          = [] :: list()
          }).

-endif.