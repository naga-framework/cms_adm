-ifndef(CMS_HRL).
-define(CMS_HRL, true).

-define(APP,cms).
-define(APP_NAME,"cms").
-define(APP_VSN,"v0.0.1").
-define(JSON(X), jiffy:encode(X)).

-define(TABLES, [config,xuser,acl,article,attachment,category]). %%naga:models()

-define(attrs(X), record_info(fields,X)).
-define(table(X,Keys), #table{name=X ,container=feed,fields=?attrs(X),keys=Keys}).

-record(feature,{id,name}).

-endif.
