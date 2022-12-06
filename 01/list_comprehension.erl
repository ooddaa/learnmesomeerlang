-module(list_comprehension).
-compile(export_all).

extract_odd(List) when is_list(List) -> 
  [X || X <- List, X rem 2 =/= 0];

extract_odd(_) -> 
  io:format("give me a List!~n").

extract_even(List) when is_list(List) -> 
  [X || X <- List, X rem 2 =:= 0];

extract_even(_) -> 
  io:format("give me a List!~n").

get_menu() -> 
  [
   {steak, 9.99, meat},
   {kangaroo, 8.25, meat},
   {kitten, 7.98, pet},
   {whale, 6.9, meat},
   {nothing, 5.41, nothing},
   {water, 0.01, beverage}
  ].

within_pricerange(Menu, From, To) when is_float(From), is_float(To) -> 
  [{Dish, Price} || {Dish, Price, _} <- Menu, Price >= From, Price =< To].

filter_by_type(Menu, T) -> 
  [X || X = {_, _, Type} <- Menu, Type =:= T].

show_meat(Menu) -> 
  [{Dish, Price} || {Dish, Price, meat} <- Menu].

