-module(identity).
-compile(export_all).

new(User) when is_tuple(User) ->
  Email = User:get(email),
  #{
   is_author => acl:is_author(Email),
is_moderator => acl:is_moderator(Email),
   is_admin  => acl:is_admin(Email),  
   is_blocked=> acl:is_blocked(Email),
   user      => User:to_maps()
  }.