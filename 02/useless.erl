-module(useless).
-import(io, [format/1]).
-export([add/2, sub/2, mult/2, 
  divide/2, 
  hello/0, hello2/0,
  greet_and_add_2/1
]).
-vsn(999).
-author(oda). % proplists:get_value(author, useless:module_info(attributes)). -> [oda]
-define(HELLO, "hello").
-define(DIVIDE(X,Y), X/Y).

-ifdef(DEBUGMODE).
-define(DEBUG(S), io:format("dbg: " ++S)).
-else.
-define(DEBUG(S), ok).
-endif.

-ifdef(TESTMODE).
  test() -> test_stuff(). 
-endif.

add(A,B) ->
  A + B.

sub(A,B) ->
  A - B.

mult(A,B) ->
  A * B.

divide(A,B) ->
  % c("useless.erl", [debug_info, export_all, {d, 'DEBUGMODE'}]).
  ?DEBUG("division: " ++ integer_to_list(A) ++ " / " ++ integer_to_list(B) ++ " = "),
  ?DIVIDE(A,B).

hello() ->
  io:fwrite(?HELLO ++ "~n").

%% uses io:format
hello2() ->
  format("yo~n").

greet_and_add_2(X) ->
  hello(),
  add(X,2).

private_stuff() ->
  ok.

test_stuff() ->
  io:format("testing~n").