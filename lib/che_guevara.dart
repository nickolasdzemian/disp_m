import 'package:neptun_m/db/db.dart';

List<Equalal> equalal0 = [];
List<Equalal> equalal1 = [];

// *******************************************************************************************************************
//                                              Comandante Che Guevara
//
//
//                                                !IQOMQMQQQQQMQM^                                               
//                                         |MMQMQMQQMMQMQMQMMMMQQMMQMQMQQQ^                                      
//                                     MMMQQMQMQMQMQMQMMMQMMQMMMMQMMMMQMQMQMQI                                   
//                                  MMQQMQMQMMMMMMMQMMMQMMMMQMMMMQMMMQMMQMMMQMMQQQQ6.                            
//                               |MQMQQMQMMQMMMMMQMMQMQ  M!^MMMMMQMMQMMMMMMMMMMQMQMMQQMQQM|                      
//                            !MMQMQMQMMQMQMQMMMMMQMQMQ.  |MQMMMMQMQMQMMMMMMMMMMQMMQMQMQMQQQQ6                   
//                           QQMQMMQMQMQMQMMMMMMMQMMMMMQMMQMMQMMMQMMQMMMMMMMMMMQMQMQMQMMQQMQMQQQQ                
//                          QMMQMQMQMMMMMMMMMQMMMQMQMMMQMMMQMQMMMMMQMMMMMMMMMQMMQMQMQMMQQMQMMQMQQQQQ             
//                        |QMMQMQQMQMQMQMMMQMMMQMMQMMMMMMMMMMQMMMQMQMMMMMMQMMMMQMQMQMQMQMQMQMQMQQMQQM.           
//                        QMMQMQQMQMMQMQMMMMQMQMQMQMQMQMQMQQMMQMMQMMQMQMMMQMQMQMQMQMMQMQMQMQMMQMQMQQMQ           
//                        QMQMQMQMMQMQMQMQQMQMQMMQQMQMMQMMMQQQMMQMQMQMQMQMQMMMMQMQMQMQMQMQMQMQMQMQMMQQQ          
//                       ^MQMQMQMQMQMQMMQQMMO.                     ^IQMMMQMQMMQMMQQMMQMQMQMQQMQMQMQMMQMQQ        
//                      IQMQQMMQMQQMMQM6                                    .OMQMQMQMQMQMQMMQMQMQMQMQMQMQQ6      
//                      QMMQQMMQQMQQ!.                                         . .6MMQMQMQMQMQMMQMQQMQMMQQMQ     
//                      OQMQMQMQMQMI.                                        ..   ...^OQMQMQMQMMQQMMQQMMQMQM     
//                       QQMQMQMMM6|.                                           . ....!6OQQMMQQMQMQMQMQMQMMQI    
//                       ^QMQQMQMQO|..                                         ..   .^!|6QMMQQMQMMQMQQMMQMQMQ^   
//                        6MQQMQMQQ! . ^|II^.. .  . ..       ^  .^!|6O66OQQQQMQQQMQO!!|IIQQMMQQMQMMQMQMQQMQMQQ^  
//                       6MQMQQMMQO^!MMQQMQQQQMQMQMMQQM|! . ..^|OQMQMQQMQMQMQMQMQMQMQMQOIOQQMQQMQMQMQMQMQMQMQQ.  
//                      IQMQMQMMQQ6|6QQO6II6MMMQMMQMQMQQO.     ^QMMMQMQQMQMQMMQMQQMMQQMQOQQMMQQMMQMMMMQMQMQQQ|   
//                     OMQMQMQQMQM6^66I|QMMMMQQMQMMMQMMQ6      ^QMMQMQMQQMMQMMQMQMQMQMQMQQMMQQMQMMQMQMMMQMMQQ    
//                  IQMQMMQMQMQMQM|!|6OQQMMQQQMQ!   .|.^^     .!OOO!I!|  QMQ6IQMQMQMQMQMQMQQMQQMQMQMQMQMQMQM.    
//             ^6MQMMQMMMQMMMQMQM|!!!|OMQQO6I|^^^ . .^^..    .66OO6I^^^^^|III66OQQMQMQQMQMQMQMMQMQMMQMQMMQ6QI!   
//       ^I6QMMMQQMQMQMMMQMQMQMMM.... .   .                   IO666I!^^....^.!6O66666OOOQQMQMMQMQMMQMMQQMQO^!6   
//   .      6!.QQQMMQMQMMQMQMQQM6^.                           .|I!!^     . ..!|!I||III^IQMQMQMMMQQMQQMQMQMMQ^.   
//         .|!.IQMQMQMQMQMQMQQMM6.                             ^IO6|.   ...^.^^!.!!||II6QQQMQMMQMQOMQMQMQMQMQQQ  
//          IO !6QMQMQMQMMMQMQQMQ^.                           |I!. |.         .!|I|IIIOOMMQMQMQMQMQQQMQMQMMQQMQMO
//           IQMQMQMQMMQMMMQMMQQMI..                 |QQQ6||!!OQQMMQ|        .^^!6I66OQMQMQMMQMMMMQMQMQMQQMQMMQQQ
//            .6MMQQMQMQMQMQMQMMQO!  .              ^IIQM |QMOI6QQMMOIQ     .^!|6OQQQMQMQMMQMQMQMQMQMQQMQMMQQMQQ!
//            .OQQMQMQMQMMQMQMMQQQ6^...              .^^^.    !|QOO66I!    .!|6OOQQMQQMQMQMQMQMQMQMQMQMMQMQQMMQ|.
//            ^QMQQMQMMQMQMQMQMQQMOI..                 !|..^ .^IQQO^   .  .^!IOQQQQQMQMMQMMMQMQQMQOMQMMQMQMQMQQQ 
//             OMQMQMQMQQMQMQMQMMQQO!.                |66.^   ^QMMQMQI|!!...^|OI6OQQMQMMQMMMQMMQMMQMQMQMMQMQQMMQ 
//      .      QQQMQQMQMMQMQMQMQQMQOI|.          ..||!^I.     .|QMQMMQMQQ66|!^!|OQQMQMQMMMMMQMQMQMMQMQMQMQMQQMQM 
//     6      IQQMQMQMQMMQMMMQQMQMQQ66|       6O6|QO. .|OOOQQQMQMQMQMQMMQMQQQOOQQQMQQMQMQMQMMQMMQQMQMMMQMQMMQQMM 
//      6Q6IMQOQMQQQMQMQMMQMQMQMQMQQO66^.   .OQII!6OQMMMQQOQMQQQMMMMMQMMQMQQMMQQMQQQMQMMMMMMMMMQQMQMQMQMMMQQMMQM 
//            ^.    QQMMQMQQMQMQMQMQO66|..  !MO!    ...    ..  .!O6OO666IMQMMQMQMQQMQMMQMMMMMQMQMMMMQMMQMQMQMQQI 
//          .O      .MMMMQMQMMQMQMQQMOQ6O!  6Q6.    ^!!|I6QOQMQMMQMMQQQQQQMMQMMQMQMMQMQMMMMQMQMQQMQMQMMQMMQMQMQ. 
//          QQO.   OQMMMQMQMMQMQMQMQMQQQO!   .. ..^^^!|6QMQMQMQMQMQQQMQQQQMMMQMQMQMQMQMQMMQMMQMQMQMMMQMQMQMQQQI  
//          ^MQMQMQQQMQMQMQMQMMQMQMQMQMQQM|^. .. ...          . .!|IOOOQQQQQMMQMQQMMQMMQMQMQMQMMQMMMQMQMQMQQMO   
//         ^  .QMQMQMQMQMQMQMQMQMMQMQMMQQ|^!|6I^.                 ...!|OQQQMQMQQMQMMMMMMQMMMMMQMQMQMMQMQMQM|M.   
//          6I^6|MQQMMMQMMQMQMMQMQMQQMQMQM66QOO!!                ...^II6QMQQMMQMQMQMQMQMQMQMQMQMQMQMQMQMQO6O^.   
//           |QMQMQMQMQMQMQMQMMQMQMQQMQMMQQMQMQMQ|^.  ..  ....^^!II6QMQQMQMMQMQMQMQMQMQQMQMQMMQMQMMQMQMQMMQM6!   
//            ^QMQMMQMMQQMQMQMMQMQQMQMMQQQMQQMQMQMQQQOOOI||I||OOQQMMQMQQMQMQMQMQMMQMQMQMMQMMQQMMQMQMQMQMQQMQ|    
//                 .MOIQQMQQMMQMQQMMQQMQMMQQMQMQQMQMMQMQQMQMMQMQMMMQMQMQMQMQMQQMQMQMMQMQMMQMQMMQMMMQMQQMQMM^     
//                 QO!QQOMMQMQMQMQMQQMMQQMQ6MQMQMQMMQMQMQMQMMMQMMQMQMQMMQMQMMMMQMQMQMQMQMQMQMQQQO||IMMQMQQ|      
//                 ||     MMQMQMQQMMQQMQMMQMIQQQQMQMQMQMQMQMQMQMMQMMQMQMQMQMQMMQQMMQQMMQMQMQMQQMQM!^.Q MQQ.      
//                         M6MQMQQMQMQMQMQMQMQQQQMQMMQQMMQMMQMQMQMMMMQMQMQMQMQQMMQMQMQMQMQMQQQQMQM| ^6QQQ .      
//                     ..^QQQMQMMQQMQMMQMQQMQMQMMQQMQMQMMMQMQMMMMQMMQMMQMQMQQMQMMQQMQMMQMQMMQMQ|                 
//            .II|^!|!!!^^6QQMMQMQMQMQMQQMQMMQMQQMMQMQMQMQMQMQQMQMMMQMQMQMQQMQQQMQMQQMQMQMMQQMM                  
//     .^!I|^!|!|!!|II^^!!!|QMQMQMQMQMQMQMQMQMQMQQMQMMQMQMMQMMMMMQMMQMQMQQMQMQQQMQMMQMMQMQMQMQM                  
//      ...^^^^!^!!!I|!!|I|||I6OQQQQQMQQQOQOOOQOQ!6OQOMQMQMQOOQQQMQQMMMQQO6OMQQMQMMMQMQMQMQMQMQ                  
// .      . ...^!^!^!^!!!||^!|III6OQQOOQQQQOI^|OQ6.   .!MQQ|!.|QQ!I!QMMQMQQQQMQMMMMMQMQMQMQMMQM           .      
// ^^^..^..^^!!^!^|I|I||||!!^!||I||6I6IQQQMQOOQII6QQO6|^..!6II.QQO M6QMQQIMQMQQMQMMQMQMMMMQMQQMQO         .     .
// ..^^^^^!|III6O66|I!|||!|I|!^||!|III6||I6OQQQQQQOOQQO6II!..^.^QQQ|MMQQQOQQQMQQQMQQMMMQMMQQ|OMOOQ!      .. . ...
//   ...^.^!|6OQOQQQ66I|!!^^!^^^!|I6III||!|IIOOQQQQQQQQQOQQ6II||^6O6QMQMQOMQQQQMMQQMOQO|6OOOO^.!.^^^ .   ........
// .   ..^^^^^!|666OOOI|!^^^.!^!^!|OO6O6II!|II66QOQQQMQQQQQMQQOO6I6QMQMMQOQMQQQMQQMQQQOOQOQQ6I^.^^.^!.  .........
// .......^!!^^^!|I6I6II|!^...^!^^^|6OOO6|!||I6666OOQQQMQQQQMQQOOO6QQ6I|6!QQMQQMQQQQQQQQOOO6I||^. . .^^^.|I!^^.^^
// .^.^..^..^^||!||||6OO6I!|^^^!!^!!!IQQOI||||I666OOQQQQQQQQQQOQQQQQOQ6OOOMQMQOQQQQQQOO66I||I|||^.....^^!.^I!!^^^
// ..^^^^^.^.^.^^I|III666666I!!^^^^!!!IOQI6I|||I|6OOOOQQQQQQQQQ6OOOOOOOMQMQMMQQQQQOOO6I6III|||||^^^....^!!.^^^^!!
// ...^..^^^^^...^.^!|III6666III^^^!^!!IQQO|!!||I6Q66OOQQQQQQMQQQOQQ6O66MQQMQMQ6I66666IIII||||!!^!^^.^.^.!!.^!^^!
//   .....^.^..^....^.^!^!!|!I666I|^^!^!6OQQO|!|I|6II66QQQQQQQQOQQQMO6IIMQOQO6I6666II||||II||!|!|!^^^.^..^!!.^!!!
//  . . .^......^....^..^..^^.^!^^!!^!I|IOOQQO66I|!|I66OOOQQOQOQOQOOQ66IOQOQQ66IIII6II||I|||!||!^!!^^!^^^^!!!^^!!
// ..  .......... ......^...^..^.^^^^^^^!|66QQOI6|||||I666I66O66OQQOOII||QOOO||III|||||!I||!|!!|!!^!^^^.^^!!!!^!!
// ..   .  ..... ........ ......^...^.^..^^I66OO6I!!|!|III6I|6II666O6II|!MIMQ|I|||I|I|||!!!!||!!^^^!!^!!^^^!!!^!!
//  . . .  .. . .... ...... .. .. .......^.^!6666I|||!!!|!||||II|I6O6I|!!O!66!|I|!||!^!!!!!!^^!^^!^^^^^^^^^!!^!|6
//   .     . . . .   . ..  . . . . ..  ....^.^|II|!!^^^!^!^!^!!||^!|||!!^|!6Q!!!!|^!^!^!!^^^^!^^^.^^^^.^^.^!^!^!|
//                   .    . . .  .  .    . . ..^!I^^^^.^^^^^^!^!^!!!||!^^^!!6|^!^!^^!^^^^^.^^^.^^^^..^...^^.^^!!!
//                                         . . . ^|!.^....^^^.^..^.^!!^.^.I^||^.^.^.^.^.^^^....^.^.........^.^^!|
//                                                .^!^.. .......^..^.^^ . I.I!..^.....  ...      Che Guevara
//
//
// 
// *******************************************************************************************************************