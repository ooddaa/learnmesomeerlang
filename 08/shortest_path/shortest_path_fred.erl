-module(shortest_path_fred).
-export([main/1]).

% to run do
% erlc shortest_path_fred.erl
% erl -noshell -run shortest_path_fred main paths_f_book
main(Filepath) -> 
  Map = parse_input(Filepath),
  io:format("~p~n", [optimal_map(Map)]),
  erlang:halt(0).
  
optimal_map(Map) -> 
  {A,B} = lists:foldl(fun shortest_step/2, {{ 0, [] }, { 0, [] }}, Map),
  {Dist, Paths} = if hd(element(2,A)) =/= {x,0} -> A;
                      hd(element(2,B)) =/= {x,0} -> B
                    end,
  {Dist, lists:reverse(Paths)}.

shortest_step({A,B,X}, {{DistA, PathA}, {DistB, PathB}}) -> 
  % ends up on A road
  OptA1 = {DistA + A, [{a, A} | PathA]}, % PathA because we started from DistA
  OptA2 = {DistB + B + X, [{x, X}, {b, B} | PathB]},
  
  % ends up on B road
  OptB1 = {DistB + B, [{b, B} | PathB]},
  OptB2 = {DistA + A + X, [{x, X}, {a, A} | PathA]},

  {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

% parse input
parse_input(Filepath) -> 
  {ok, F} = file:read_file(Filepath),
  chunk(to_tokens(F), []).

to_tokens(L) when is_list(L) -> 
  S = string:tokens(L, "\r\n\t "),
  [list_to_integer(X) || X <- S];
to_tokens(L) -> to_tokens(binary_to_list(L)).

chunk([], Acc) -> lists:reverse(Acc);
chunk([A,X,B|Tail], Acc) -> chunk(Tail, [{A,X,B}|Acc]).

