-module(quicksort).
-compile(export_all).

quicksort([]) -> []; 
quicksort([Pivot|Rest]) -> 
  {Smaller, Larger} = partition(Pivot, Rest, [], []),
  quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).

partition(_, [], Smaller, Larger) -> {Smaller, Larger};
partition(Pivot, [Head|Tail], Smaller, Larger) -> 
  if Head =< Pivot ->  partition(Pivot, Tail, [Head|Smaller], Larger);
     Head > Pivot ->  partition(Pivot, Tail, Smaller, [Head|Larger])
  end.

quicksort2([]) -> [];
quicksort2([Pivot|Rest]) -> 
  quicksort2([Smaller || Smaller <- Rest, Smaller =< Pivot])
  ++ [Pivot] ++ 
  quicksort2([Larger || Larger <- Rest, Larger > Pivot])
.
