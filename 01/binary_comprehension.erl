%% https://user.it.uu.se/~pergu/papers/erlang05.pdf
-module(binary_comprehension).
-compile(export_all).

test() -> 
  Pixels = <<0,0,0,255,255,255,170,53,42,109,214,169>>,
  [Black, White, Red, Green] = [ {R,G,B} || <<R:8, G:8, B:8>> <= Pixels ],
  % [{0,0,0},{255,255,255},{170,53,42},{109,214,169}]

  %% with Alpha
  Pixels1 = <<0,0,0,100, 255,255,255, 100, 170,53,42,50, 109,214,169,10>>,
  [Black, White, Red, Green] = [ {R,G,B, {alpha, A}} || <<R:8, G:8, B:8, A:8>> <= Pixels1 ],
  % [{0,0,0,{alpha,100}},
  %  {255,255,255,{alpha,100}},
  %  {170,53,42,{alpha,50}},
  %  {109,214,169,{alpha,10}}]

  %% Put it back into a binary
  << <<R:8, G:8, B:8, A:8>> || {R,G,B, {alpha, A}} <- [Black, White, Red, Green] >>,
  % <<0,0,0,100,255,255,255,100,170,53,42,50,109,214,169,10>>

  %% change values
  << <<(X+1)/integer>> || <<X>> <= <<3,7,5,4,7>> >>,
  % <<4,8,6,5,8>>

  << <<(X+1)/integer>> || <<X>> <= <<3,7,5,4,7>>, X rem 2 == 1 >>.
  % <<4,8,6,8>>



keep_0XX([{0,B1,B2} | Rest]) -> [{0,B1,B2} | keep_0XX(Rest)];
keep_0XX([{_,_,_} | Rest ]) -> keep_0XX(Rest);
keep_0XX([]) -> [].
%% Stream = <<0,1,2, 3,4,5, 6,7,8, 0,9,8, 0,77,55>>.
%% <<0,1,2,3,4,5,6,7,8,0,9,8,0,77,55>>
%% Lol = [ { A,B,C } || <<A:8,B:8,C:8>> <= Stream ].
%% [{0,1,2},{3,4,5},{6,7,8},{0,9,8},{0,77,55}]
%% binary_comprehension:keep_0XX(Lol).
%% [{0,1,2},{0,9,8},{0,77,55}]

%% or better yet
keep_0XX_c(List) -> [ {0,B1,B2} || {0,B1,B2} <- List ].
%% binary_comprehension:keep_0XX_c(Lol).
%% [{0,1,2},{0,9,8},{0,77,55}]

%% Size is read from first byte
%% <<Sz:8/integer,
%% Vsn:Sz/integer,
%% Msg/binary>> = <<16,2,154,42>>
%% Vsn.
%% 666

match_X(Binary) -> 
  case Binary of
    <<42:8/integer, X/binary>> -> handle_bin(X);
    <<Sz:8, V:Sz/integer, X/binary>> when Sz > 16 -> handle_int_bin(V, X);
    <<_:8, X:16/integer, Y:8/integer>> -> handle_int_int(X, Y)
  end.

handle_bin(X) -> io:format("handle_bin: X == ~p~n", [binary:bin_to_list(X)]).
handle_int_bin(V, X) -> io:format("handle_int_bin: {V, X} == {~p,~p}~n", [V, X]).
handle_int_int(X, Y) -> io:format("handle_int_int: {X, Y} == {~p,~p}~n", [X, Y]).

begin

end.