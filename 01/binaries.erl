%% https://www.erlang.org/doc/man/binary.html
%% binary == contain whole octets of bits 
-module(binaries).
-compile(export_all).

test() -> 
  <<A:8>> = <<0>>, % one byte 
  Color = 16#E54E37,
  Red = <<Color:24>>,
  <<R:8,G:8,B:8>> = Red,
  <<First:8, Rest/binary>> = Red. % same as <<First:8, Rest/bytes>> = Color. <<First:8, Rest:16/bits>> = Color.

%% <<25:Size/unit:Unit>> and multiply Size by Unit to figure out 
%% how much space it should take to represent the value.

ops() ->
  2#001 = 2#100 bsr 2, % 1
  2#010 = 2#001 bsl 1, % 2
  2#01110 = 2#01010 bor 2#00100. % 14

tcp_packet(Packet) ->
  <<SourcePort:16, DestinationPort:16, AckNumber:32,
  DataOffset:4, _Reserved:4, Flags:8, WindowSize:16,
  CheckSum:16, UrgentPointer:16,
  Payload/binary>> = Packet.

binary_strings() ->
  %% people tend to use binary strings when storing text that 
  %% won’t be manipulated too much or when space efficiency is a real issue.
  "lol" = binary:bin_to_list(<<"lol">>),
  binary:bin_to_list(<<"erlang">>, {1,3}), % "rla" or [114,108,97] in list notation.
  binary:list_to_bin([114, 108, 97]), % "rla" or erlang:list_to_binary/1

  %% deliberate copying
  binary:copy(<<"lolol">>, 5), % <<"lolollolollolollolollolol">>

  %% match
  binary:match(<<"erlang is cool">>, [<<"ang">>],[]),
  % {3,3}
  binary:matches(<<"erlang is cool and cooler than js">>, [<<"ang">>, <<"cool">>],[]),
  % [{3,3},{10,4},{19,4}]

  %% part
  Bin = <<1,2,3,4,5,6,7,8,9,10>>,
  binary:part(Bin, {byte_size(Bin), -2}), % last 2 bytes <<9,10>>

  %% referenced_byte_size(Binary) -> Integer >= 0
  %% https://www.erlang.org/doc/man/binary.html#referenced_byte_size-1 
  %% Binary sharing occurs whenever binaries are taken apart.
  Color = <<16#E54E37:24>>,
  <<R:8,G:8,B:8>> = Color,
  byte_size(Color), % 3
  binary:referenced_byte_size(R). % 1

%% say hi to 64bit architecture!
% 197> O = binary:copy(<<1>>, 130).
% <<1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
%   1,...>>
% 198> <<First:65/binary, Last/binary>> = O.
% <<1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
%   1,...>>
% 199> {byte_size(Last), binary:referenced_byte_size(Last)}.
% {65,130}
% 200> {byte_size(First), binary:referenced_byte_size(First)}.
% {65,130} <- here First spills over 64bits and referencing the parent binary
% if we didn't need the Last part, we'd need to explicitly binary:copy(First). 
% to release referenced memory of unused Last. (needed to check if Last wasn't 
% indeed used by any other process - @ooddaa how to do it? 
% 201> f(Last).
% ok
% 202> f(First).
% ok
% 203> f(O).
% ok
% 204> O = binary:copy(<<1>>, 130).
% <<1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
%   1,...>>
% 205> <<First:63/binary, Last/binary>> = O.
% <<1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
%   1,...>>
% 206> {byte_size(First), binary:referenced_byte_size(First)}.
% {63,63} <- here First does not spill over 64bits and does not reference the parent binary
% 207> {byte_size(Last), binary:referenced_byte_size(Last)}.
% {67,130}
% 208>

