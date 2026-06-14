{ include( "playgrounds/office.asl" ) }

map_ntpp(alice, senior_office_2).
map_ntpp(cup1, common).

+!start
    :   .my_name( Me )
    <-  .setof(R, (map_po(R, _)|map_po(_, R)|map_ec(R, _)|map_ec(_, R)), Rooms);
        for (.member(R1, Rooms) & .member(R2, Rooms) & find_distance(R1, R2, D)){
            +dist(R1, R2 ,D);
        };
        +distances_counted;
        .print("Distancies counted");
        +ntpp( Me, senior_office_2 );
        +my_desk( senior_3_desk );
        .wait( 5000 );
        !grab( cup1 );
        !go_to( coffee_machine );
        !take_coffee( cup1 );
        !go_to_work;
        !release( cup1 ).



//.setof(R, (map_po(R, _)|map_po(_, R)|map_ec(R, _)|map_ec(_, R)), Rooms);
//        .print("List of rooms: ", Rooms);
//        for (.member(R1, Rooms) & .member(R2, Rooms) & find_distance(R1, R2, D)){
//            +dist(R1, R2 ,D);
//        };
//        +distancies_counted;
 //       .print("Distancies counted");



