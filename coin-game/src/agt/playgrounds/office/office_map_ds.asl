{ include( "office_map.asl" ) }

// RCC Rules
po( X, Y ) :- map_po( X, Y ).
po( Y, X ) :- map_po( X, Y ).

ec( X, Y ) :- map_ec( X, Y ).
ec( Y, X ) :- map_ec( X, Y ).

//Counting heuiristic distances between rooms for Greedy Search
find_distance(Start, Target, D):-
 find_distance_recursive( Start, Target, [ Start ], D ).

find_distance_recursive( Target, Target, _, 0 ).
find_distance_recursive( Current, Target, Visited, D ) :- 
 ( po( Current, Next ) | ec( Current, Next ) ) & 
 not .member( Next, Visited ) & 
 find_distance_recursive( Next, Target, [ Next | Visited ], D1 ) &
 D = D1 + 1.

