-module(atoms).
-compile(export_all).

test() -> 

  % ~
  io:format("~~~n"),

  % true
  io:format("~s~n", [atom =:= 'atom']),

  % true
  io:format("~s~n", ['lol is here' =/= 'is an atom']),

  % {[39,108,111,108,32,105,115,32,104,101,114,101,39,32,61,47,61,32,39,105,115,32,97,110,32,97,116,111,109,39],true}
  io:format("~w~n", [{ "'lol is here' =/= 'is an atom'", 'lol is here' =/= 'is an atom'}]),

  % {"'lol is here' =/= 'is an atom'",true}
  io:format("~p~n", [{ "'lol is here' =/= 'is an atom'", 'lol is here' =/= 'is an atom'}]).
  % 'Atoms can be cheated'.
