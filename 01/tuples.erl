% https://www.erlang.org/doc/reference_manual/data_types.html#tuple
-module(tuples).
-compile(export_all).

test(X,Y) -> 
  Point = {X,Y, { "something else" }},
  {A,B,C} = Point,
  io:format("~p ~p ~p ~n", [A,B,C]).

% access_first_element(Tuple) when is_tuple(Tuple) -> 
%   First = element(1, Tuple),
%   io:format("First is: ~p~n", [First]).

% access_first_element({First, Rest}) -> 
%   io:format("First is: ~p~n", [First]),
%   io:format("Rest is: ~p~n", [Rest]).

access_first_element(Tuple) ->
  case is_tuple(Tuple) of
    true -> 
      First = element(1, Tuple),
      io:format("First is: ~p~n", [First]);
    false -> 
      io:format("give me a tuple~n")
    end.

access_first_element() ->
  io:format("give me a tuple~n").
  
