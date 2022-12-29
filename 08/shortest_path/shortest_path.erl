-module(shortest_path).
-export([main/1]).

% unlike Fred I represent segments as 
% (A) --1-- (A1) --3-- (A2)  ..etc..
%  |         |          |
%  0         4          7
%  |         |          |
% (B) --2-- (B1) --5-- (B2)
% 
% which comes out as {A,X,B} <- top-down approach
% [{1,0,2}, {3,4,5}] 
% 
% whereas Fred's variant is
% [{1,2,4}, {3,5,7}]         <- 🤔 
get_paths(Filepath) -> 
  S = string:tokens(binary_to_list(element(2, file:read_file(Filepath))), "\r\n\t "),
  [list_to_integer(X) || X <- S].

chunk_paths(Paths) -> lists:reverse(chunk_paths(Paths, [])).

chunk_paths([], Acc) -> Acc;
chunk_paths([A,X,B|Tail], Acc) -> chunk_paths(Tail, [{A,X,B}|Acc]).


% first step, the only first step for each path is one step forward
sp({A,_,B}, []) -> 
  {{ a_path, {A, a, [{a, A}]} }, { b_bath, {B, b, [{b, B}]} }};

% each subsequent step we choose the best move and update acc
sp({A,X,B}, {{a_path, {Atotal, Apos, Apath}}, {b_bath, {Btotal, Bpos, Bpath}}}) -> 
  {Amove_cost, Apos_new, Amoves} = make_a_move({A,X,B}, Apos),
  {Bmove_cost, Bpos_new, Bmoves} = make_a_move({A,X,B}, Bpos),

  { { a_path, {Atotal+Amove_cost, Apos_new, Apath ++ Amoves} }, 
    { b_bath, {Btotal+Bmove_cost, Bpos_new, Bpath ++ Bmoves} } }.

% best move is the least expensive move to make
% based on the starting position
make_a_move({A,X,B}, Pos) -> 
  case Pos of
      a when A >= X+B -> {X+B, b, [{x, X}, {b, B}]};  
      a when A < X+B -> {A, a, [{a, A}]};  
      b when B >= X+A -> {X+A, a, [{x, X}, {a, A}]};  
      b when B < X+A -> {B, b, [{b, B}]}  
    end.

% run and pick the winner/s.
main(Filepath) ->
  Paths = get_paths(Filepath),
  L = chunk_paths(Paths),

  { { a_path, {Atotal, _, _} } = A, 
    { b_bath, {Btotal, _, _} } = B } = lists:foldl(fun sp/2, [], L),

  case {Atotal,Btotal} of
    {Atotal,Btotal} when Atotal =:= Btotal -> { { a_path, A }, { b_bath, B }};
    {Atotal,Btotal} when Atotal < Btotal -> { { a_path, A } };
    {Atotal,Btotal} when Atotal > Btotal -> { { b_path, B } }
  end.
