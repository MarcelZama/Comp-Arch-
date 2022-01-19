*-----------------------------------------------------------
* Title      :   Part1
* Written by :   Marcel Zama
* Date       :   19/01/2022
* Description:   a. Ask user for gamer points 
*                b. Stores a gamers points in a memory location 
*                c. Displays points on screen
*-----------------------------------------------------------
    ORG    $1000
    
START:  

    LEA MESSAGE,A1
    MOVE.B #14,D0
    TRAP #15
    
    MOVE #4,D0
    TRAP #15
    
     LEA text,A1
     MOVE #14,D0
     TRAP #15
    
    MOVE.B #3,D0
    TRAP #15
 
    SIMHALT 
MESSAGE DC.B 'Please input your points: ',0
text DC.B 'Your points are: ',0
    END    START

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
