// RCC Rules
po( X, Y ) :- map_po( X, Y ).
po( Y, X ) :- map_po( X, Y ).

ntpp( X, Y ) :- map_ntpp( X, Y ).
ntppi( Y, X ) :- map_ntpp( X, Y ).

ec( X, Y ) :- map_ec( X, Y ).
ec( Y, X ) :- map_ec( X, Y ).

// Check if two regions are subregions of the same one
same_region( Region1, Region2 ) :-
 (ntpp( Region1, SuperRegion ) & ntpp( Region2, SuperRegion )).


//| ntpp( Region1, SuperRegion ) & map_ntpp( Region1, SuperRegion )
    

+!go_to( Target )
    :   .my_name( Me ) & same_region( Me, Target )
    <-  .print( "I want to go to ", Target, " and we are in the same region" );
        vesna.walk( Target, _ );
        .wait( {+movement( completed, destination_reached ) } );
        -at( Me, _ );
        +at( Me, Target );
        .print( "I arrived to ", Target ).

+!go_to( Target )
    :   .my_name( Me ) & ntpp( Me, MyRegion ) & ntpp( Target, TargetRegion ) & po( MyRegion, Door ) & po( Door, TargetRegion )
    <-  .print( "I want to go to ", TargetRegion, " and I know there is ", Door, " that can lead me there");
        vesna.walk( Door, _ );
        .wait( { +movement( completed, destination_reached ) } );
        .print( "I arrived to ", Door , " and I go inside" );
        vesna.walk( TargetRegion, _ );
        .wait( { +movement( completed, destination_reached ) } );
        .print( "I arrived to final region ", TargetRegion );
        -ntpp( Me, _ );
        +ntpp( Me, TargetRegion ).

+!go_to( Target )
    :   .my_name( Me ) & ntpp( Me, MyRegion ) & ntpp( Target, TargetRegion ) & ec( MyRegion, Corridor) & ec( Corridor, TargetRegion )
    <-  .print( "I want to go to ", TargetRegion, " and I know there is ", Corridor, " that can lead me there");
        Path = [ Corridor, TargetRegion ];
        !follow_path( Path );
        !go_to( Target ).

+!go_to( Target )
    :   .my_name( Me ) & ntpp( Me, MyRegion ) & ntpp( Target, TargetRegion )
    <-  .print( "I am really far away, I have to reason a bit logically...");
        if ( TargetRegion == office ){
           //.print( "Launched dfs exploration");
           //?find_path( MyRegion, Target, LPath );
           //!find_path_bfs( MyRegion, Target, Path );
           !find_path_greedy( MyRegion, Target, RPath );
        } else {
           //.print( "Launched dfs exploration");
           //?find_path( MyRegion, TargetRegion, LPath );
           //!find_path_bfs( MyRegion, TargetRegion, Path );
           !find_path_greedy( MyRegion, TargetRegion, RPath );
        }
        //.delete( MyRegion, LPath, RPath );
        .reverse(RPath, Path);
        .print( Path);
        !follow_path( Path ).
        //if ( not TargetRegion == office ) {
        //!go_to( Target );
        //}.



+!follow_path( [] )
    <-  .print( "Destination reached").

+!follow_path( [ Head | Tail ] )
    :   .my_name( Me )
    <-  .print( "Moving to ", Head, " : ", Tail );
        vesna.walk( Head );
        .wait( {+movement( completed, destination_reached ) } );
        -ntpp( Me, _ );
        +ntpp( Me, Head );
        !follow_path( Tail ).

// ARTIFACT INTERACTIONS
+!use( ArtName )
    :   .my_name( Me ) & ntpp( Me, MyRegion )
    <-  lookupArtifact( ArtName, ArtId );
        focus( ArtId );
        use( MyRegion )[ artifact_id( ArtId ) ].

-!use( ArtName )
    <-  .print( "I cannot use ", ArtName ).

+!free( ArtName )
    <-  lookupArtifact( ArtName, ArtId );
        stopFocus( ArtId );
        free[ artifact_id( ArtId ) ].

+!grab( ArtName )
    :   .my_name( Me ) & ntpp( Me, MyRegion )
    <-  lookupArtifact( ArtName, ArtId );
        grab( MyRegion )[ artifact_id( ArtId ) ].

-!grab( ArtName )
    <-  .print( "I cannot grab ", ArtName ).

+!release( ArtName )
    :   .my_name( Me ) & ntpp( Me, MyRegion )
    <-  lookupArtifact( ArtName, ArtId );
        release( MyRegion )[ artifact_id( ArtId ) ].

-!release( ArtName )
    <-  .print( "Cannot release ", ArtName ).


//dfs exploration
find_path( Start, Target, Path ) :- 
    find_path_recursive( Start, Target, [ Start ], Path ).

find_path_recursive( Target, Target, Visited, Visited ).
find_path_recursive( Current, Target, Visited, Path ) :- 
    ( po( Current, Next ) | ec( Current, Next ) ) & 
    not .member( Next, Visited ) & 
    find_path_recursive( Next, Target, [ Next | Visited ], Path ).


//bfs exploration
+!find_path_bfs( Start, Target, Path ) 
 <- .print( "Launched bfs exploration");
    !find_path_bfs_1(Target, [Start], [], [], [], Path).

+!find_path_bfs_1(Target, [], Next_L, List0, Visited, Path)
 <- !find_path_bfs_1(Target, Next_L, [], List0, Visited, Path).

+!find_path_bfs_1(Target, [H|T], Next_LH, List0, Visited, Path)
 <- .findall(N, (po(H,N) | ec(H,N)) & not .member(N, Visited), Next_LT);
 .concat(Next_LH, Next_LT, Next_L);
 !make_list(H, Next_LT, ListH);
 .concat(List0, ListH, List);
 if (.member(Target, Next_L)) {
    .reverse(List, ListR);
    !find_curr_path(Target, ListR, Path_rev);
    .reverse( [Target|Path_rev], Path );
 } else {
    !find_path_bfs_1(Target, T, Next_L, List, [H|Visited], Path);
  }.

+!make_list(A, [], []).
+!make_list(A, [H|T], [[A|H]|LT])
 <- !make_list(A,T,LT).

+!find_curr_path(H, [], []).
+!find_curr_path(H, [[K|L]|List_T], Path)
 <- if (L == H) {
    !find_curr_path(K, List_T, P);
    Path = [K|P];
 } else{
    !find_curr_path(H, List_T, P);
    Path = P;
 }.


//greedy search exploration (heuristic exploration)
+!find_path_greedy(Start, Target, [Target|Path])
 <- .print( "Launched greedy search exploration");
    .wait(distances_counted);
    !find_path_greedy_1(Target, Start, [], Path).

+!find_path_greedy_1(Target, Target, Visited, Visited) <- true.

+!find_path_greedy_1(Target, Start, Visited, Path)
 <- .findall(N, (po(Start,N) | ec(Start,N)) & not .member(N, Visited), Next_L);
    .findall(Dist, dist(R, Target, Dist) & .member(R, Next_L), Dist_L); 
    .sort(Dist_L, [Min_dist|_]); 
    ?(.member(Room, Next_L)) & dist(Room, Target, Min_dist); 
    !find_path_greedy_1(Target, Room, [Start|Visited], Path).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }