-module(socket_examples).
-export([nano_get_url/0, nano_get_url/1]).

nano_get_url() ->
  nano_get_url("www.google.com").

nano_get_url(Host) ->
  {ok, Socket} = gen_tcp:connect(Host,80,[binary, {packet, 0}]),
  ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
  receive_data(Socket, []).

receive_data(Socket, SoFar) ->
  receive 
    {tcp, Socket, Bin} ->
      receive_data(Socket, [SoFar|Bin]);
    {tcp_closed, Socket} ->
      % list_to_binary(lists:reverse(SoFar))
      B = list_to_binary(SoFar),
      % io:format("~p~n", [B])
      string:tokens(binary_to_list(B),"\r\n")
  end.