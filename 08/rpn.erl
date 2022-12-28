% Reverse Polish Notation calculator
% (1 + 2) - (3 * 4) / 4 == 1 2 + 3 4 * 4 / - == 0.0
% 2 + 2 - 3 == 2 2 + 3 - == -1

-module(rpn).
-compile(export_all).
% io:format("dbg: ~nSomeVar:~p~n" ++S, [SomeVar])).

rpn(L) -> 
  [Res] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
  Res.

% if we encountered operator, 
% replace the two last operands 
% from the top of the stack
% with the result of the operation
rpn("+", [N1,N2|Tail]) -> [N2+N1|Tail];
rpn("-", [N1,N2|Tail]) -> [N2-N1|Tail];
rpn("*", [N1,N2|Tail]) -> [N2*N1|Tail];
rpn("/", [N1,N2|Tail]) -> [N2/N1|Tail];
rpn(El, Stack) -> [read(El)|Stack].

read(El) -> 
  case string:to_float(El) of 
    {error, no_float} -> list_to_integer(El);
    % string:to_integer("2"). == {2,[]}
    % list_to_integer("2"). == 2

    {Float, _} -> Float
  end.