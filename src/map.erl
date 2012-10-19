%%%---------------------------------------------------------------------
%%% Description module map
%%%---------------------------------------------------------------------
%%% Creates a map for the game and provides methods for displaying and
%%% updating.
%%%---------------------------------------------------------------------
%%% Exports
%%%---------------------------------------------------------------------
%%% default_map()
%%%   returns the default map
%%% print_map(Map)
%%%   prints the given map, map must be a list of lists of terrain
%%%   types 
%%%---------------------------------------------------------------------

-module(map).
-author("Brian E. Williams").

-compile([debug_info]).

-export([default_map/0, print_map/1, get_mp/1]).

-ifdef(TEST).
  -include_lib("eunit/include/eunit.hrl").
-endif.

-define(TYPES, [{forest, 2, $F}, {marsh, 3, $#}, {mountains, 4, $M}, 
				{river, 4, $W}, {clear, 1, $C}, {hills, 3, $H}, {rough, 3, $R}, 
                {station, 1, $*}, {empty, infinity, $ }]).

get_mp(Terrain) -> 
	{Terrain, MP, _Char} = lists:keyfind(Terrain, 1, ?TYPES),
	MP.

get_char(Terrain) -> 
	{Terrain, _MP, Char} = lists:keyfind(Terrain, 1, ?TYPES),
	Char.

default_map() ->
    [ [forest, forest, forest, forest, forest, river, forest, rough, rough, rough, mountains, hills, hills,
       forest, forest, hills, hills, forest, forest, forest], % row 1
      [forest, rough, forest, hills, rough, river, marsh, rough, hills, mountains, mountains, hills, hills,
	   hills, hills, hills, forest, hills, forest], % row 2
	  [rough, rough, hills, hills, rough, river, rough, mountains, mountains, hills, mountains, mountains, hills,
	   mountains, mountains, rough, hills, hills, forest, forest], % row 3
	  [rough, rough, hills, mountains, rough, river, forest, mountains, mountains, mountains, mountains, mountains, mountains, mountains,
	   rough, rough, mountains, hills, hills], % row 4
      [rough, rough, mountains, mountains, mountains, hills, river, river] ++
		  dup(6, mountains) ++ [rough, rough, mountains, rough, river, river], % row 5
      [rough, hills] ++ dup(3, mountains) ++ [river, marsh] ++ dup(4, river) ++
		  dup(5, mountains) ++ [marsh, river, marsh], % row 6
      [forest] ++ dup(4, hills) ++ [river, forest, clear, rough, forest, forest, river, clear] ++
		  dup(4, mountains) ++ [marsh, river, forest], % row 7
      [hills, hills, forest, hills, river, forest, hills, hills, forest, rough, clear, river,
	   rough, rough, mountains, mountains, forest, river, forest], % row 8
	  [clear] ++ dup(4, river) ++ [marsh, rough] ++ dup(3, hills) ++ [mountains, forest, river, mountains, mountains] ++
		  dup(3, forest) ++ [river, forest], % row 9
      [river] ++ dup(3, forest) ++ [river, marsh, rough] ++ dup(4, mountains) ++ [clear] ++ dup(6, river) ++
		  [rough], % row 10
      [forest, forest, mountains, mountains, river, forest] ++ dup(5, mountains) ++ 
		  [rough, river, marsh, forest, marsh, marsh, rough, rough, rough], % row 11
      dup(4, empty) ++ [rough] ++ dup(3, mountains) ++ dup(3, hills) ++ [river, forest, forest] ++
		  dup(5, empty),  % row 12 length 19
	  dup(5, empty) ++ [rough, rough, hills, hills, rough, hills, river, hills] ++
		  dup(7, empty),  % row 13
	  dup(4, empty) ++ [rough] ++  dup(3, mountains) ++ [rough, forest, river, marsh, hills] ++
		  dup(6, empty), % row 14
	  dup(5, empty) ++ [rough, rough, mountains, rough, forest, river, forest, marsh] ++
		  dup(7, empty), % row 15
	  dup(8, empty) ++ [marsh, river, forest] ++
		  dup(8, empty),          % 16
      dup(8, empty) ++ [forest, forest, river, forest] ++
		  dup(8, empty), % 17
      dup(8, empty) ++ [forest, station, river] ++ dup(8, empty)       % last row
    ].

dup(Count, Terrain) -> lists:duplicate(Count, Terrain).

print_map(Map) ->
    print_map(Map, 1).

print_map([], _Line) ->
    % io:format("Finished drawing."),
    ok;
print_map([First | Rest], Line) when Line rem 2 == 0->
    io:format(" "),    
    print_line(First, Line),
    print_map(Rest, Line+1);
print_map([First | Rest], Line) ->
    print_line(First, Line),
    print_map(Rest, Line+1).

print_line([], _Line) ->
    io:format("~n");
print_line([First | Rest], Line) ->
    io:format("~c ", [get_char(First)]),
    print_line(Rest, Line).


%% --------------------------------------------------------------------
%%% Eunit test functions
%% --------------------------------------------------------------------
-ifdef(TEST).

line_test() ->
  print_line([forest, rough, marsh], 1),
  io:format("Printed test line~n"),
  ok.
  
print_map_test() ->
  Twolines = [[forest, rough, marsh], [forest, rough, marsh]],
  print_map(Twolines, 1),
  ok.

print_empty_map_test() ->
  print_map([], 1),
  ok.

print_map_last_line_test() ->
  Oneline = [[forest, rough, marsh]],
  print_map(Oneline, 1),
  ok.

map_line_length_test() ->
	Map = default_map(),
	LinesWithIndex = lists:zip(lists:seq(1, length(Map)), Map),

	[?assertEqual({Index, 20}, {Index, length(Line)}) 
	 || {Index, Line} <- LinesWithIndex, Index rem 2 == 1 ],
    [?assertEqual({Index, 19}, {Index, length(Line)}) 
	 || {Index, Line} <- LinesWithIndex, Index rem 2 == 0 ].
	
dup_test() ->
	[] = dup(0, stuff),
	[stuff] = dup(1, stuff),
	[stuff, stuff] = dup(2, stuff),
	[stuff, stuff, stuff] = dup(3, stuff),
	[stuff1, stuff1, stuff2, stuff2] = dup(2, stuff1) ++ dup(2, stuff2),
	ok.

get_mp_test() ->
	[?assert(get_mp(Terrain) == MP) || {Terrain, MP, _Char} <- ?TYPES],
	ok.

get_char_test() ->
	[?assert(get_char(Terrain) == Char) || {Terrain, _MP, Char} <- ?TYPES],
	ok.

-endif.
