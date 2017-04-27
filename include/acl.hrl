-ifndef(ACL_HRL).
-define(ACL_HRL, true).

-include_lib("kvs/include/kvs.hrl").
-include("cms_types.hrl").

-record(acl, {?CONTAINER}).

-define(access_keys,[entry_id,acl_id]).  
-record(access, {?ITERATOR(acl),
        entry_id=[]  ::fk(),
        acl_id=[]    ::fk(),
        accessor=[]  ::term(),
        action=[]    ::term()
        }).

-endif.
