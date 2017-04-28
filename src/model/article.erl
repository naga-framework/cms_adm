-module(article).
-include_lib("kvs/include/metainfo.hrl").
-include("cms.hrl").
-include("article.hrl").
-compile(export_all).
-define(db,cms_db).

%-define(JSON(X), jiffy:encode(X)).

metainfo() -> ?table(article    ,?article_keys).


%%getter/setter a la boss_db
attribute_names()  -> ?db:attribute_names(?MODULE).
attribute_names(_) -> ?db:attribute_names(?MODULE).

attribute_types()  -> ?db:attribute_types(?MODULE).
attribute_types(_) -> ?db:attribute_types(?MODULE).

attribute_idx()    -> ?db:attribute_idx(?MODULE).
attribute_idx(_)   -> ?db:attribute_idx(?MODULE).

attributes(R)-> ?db:attributes(R).

public() -> [id,created,modified,publish_date,status,title,author].

get(F,R)     -> ?db:get_value(F,R).
set(F,V,R)   -> ?db:set_value(F,V,R).
new()        -> ?db:new_record(?MODULE).
new(L)       -> ?db:new(?MODULE,L).
to_maps(R)   -> ?db:to_maps(R).
to_json(R)   -> ?db:to_json(R).

prepare_json(L) -> prepare_json(L,[]).
prepare_json([],Acc)    -> Acc;
prepare_json([{K,undefined}|T],Acc) -> prepare_json(T,[{K,<<>>}]++Acc);
prepare_json([{K,V}|T],Acc) -> prepare_json(T,[{K,V}]++Acc).

% -----------------------------------------------------------------------------
% before/after[save] before/after[update] before/after[delete]
% -----------------------------------------------------------------------------
before_create(R) -> N = ?db:set_value(modified,naga:to_seconds(),R),
                    {ok, N}.

save(R)    -> ?db:save(R).


% -----------------------------------------------------------------------------
% render
% -----------------------------------------------------------------------------
% [id,version,container,feed_id,prev,next,feeds,guard,etc,
%  created,modified,publish_date,status,title,top_title,
%  sub_title,description,text,ps,media,views,referrers]
render(_,undefined)         -> <<>>;
render(_,V)                 -> V;

render(field,publish_date)  -> "Publish date";
render(field,sub_title)     -> "Subtitle";
render(field,top_title)     -> "Heading";
render(field,F)             -> wf:to_list(F).


% -----------------------------------------------------------------------------
% test 
% -----------------------------------------------------------------------------

init() ->
 Samples = [{"Man must explore, and this is exploration at its greatest",
   "Problems look mighty small from 150 miles up",
   {2014,9,24}},

  {"I believe every human has a finite number of heartbeats. I don't intend to waste any of mine.",
  "",
  {2014,9,18}},

  {"Science has not yet mastered prophecy",
   "We predict too much for the next year and yet far too little for the next ten.",
  {2014,8,24}},

  {"Failure is not an option",
  "Many say exploration is part of our destiny, but it’s actually our duty to future generations.",
  {2014,7,8}}],
  lists:foreach(fun({A,B,C}) ->
                 Params = [{created, C},
                           {modified, C},
                           {author_id, 1},
                           {publish_date, C},
                           {status, published},
                           {heading, A},
                           {subheading,B},
                           {content, body()},
                           {media, []}],
                 Article = article:new(Params),
                 Article:save()
                end, Samples).

body() ->
"Never in all their history have men been able truly to conceive of the world as one: a single sphere, a globe, having the qualities of a globe, a round earth in which all the directions eventually meet, in which there is no center because every point, or none, is center — an equal earth which all men occupy as equals. The airman's earth, if free men make it, will be truly round: a globe in practice, not in theory.

Science cuts two ways, of course; its products can be used for both good and evil. But there's no turning back from science. The early warnings about technological dangers also come from science.

What was most significant about the lunar voyage was not that man set foot on the Moon but that they set eye on the earth.

A Chinese tale tells of some men sent to harm a young girl who, upon seeing her beauty, become her protectors rather than her violators. That's how I felt seeing the Earth for the first time. I could not help but love and cherish her.

For those who have seen the Earth from space, and for the hundreds and perhaps thousands more who will, the experience most certainly changes your perspective. The things that we share in our world are far more valuable than those which divide us.

## The Final Frontier
There can be no thought of finishing for ‘aiming for the stars.’ Both figuratively and literally, it is a task to occupy the generations. And no matter how much progress one makes, there is always the thrill of just beginning.

There can be no thought of finishing for ‘aiming for the stars.’ Both figuratively and literally, it is a task to occupy the generations. And no matter how much progress one makes, there is always the thrill of just beginning.

<blockquote>The dreams of yesterday are the hopes of today and the reality of tomorrow. Science has not yet mastered prophecy. We predict too much for the next year and yet far too little for the next ten.</blockquote>

Spaceflights cannot be stopped. This is not the work of any one man or even a group of men. It is a historical process which mankind is carrying out in accordance with the natural laws of human development.

## Reaching for the Stars
As we got further and further away, it [the Earth] diminished in size. Finally it shrank to the size of a marble, the most beautiful you can imagine. That beautiful, warm, living object looked so fragile, so delicate, that if you touched it with a finger it would crumble and fall apart. Seeing this has to change a man.

![Yes](/media/post-sample-image.jpg)

Space, the final frontier. These are the voyages of the Starship Enterprise. Its five-year mission: to explore strange new worlds, to seek out new life and new civilizations, to boldly go where no man has gone before.

As I stand out here in the wonders of the unknown at Hadley, I sort of realize there’s a fundamental truth to our nature, Man must explore, and this is exploration at its greatest.

Placeholder text by <a href=\"http://spaceipsum.com/\">Space Ipsum</a>. Photographs by <a href=\"https://www.flickr.com/photos/nasacommons/\">NASA on The Commons</a>.
".