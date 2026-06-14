//{ include( "vesna.asl" ) }
{ include( "playgrounds/office.asl" ) }

map_ntpp(cup1, reception).
map_ntpp(bob, reception).

+!start
    :   .my_name( Me )
    <-  +ntpp( Me, reception );
        +my_desk( junior_10_desk );
        .wait( 2000 );
        !grab( cup1 );
        !go_to( coffee_machine );
        !take_coffee( cup1 );
        !go_to_work;
        !release( cup1 ).




