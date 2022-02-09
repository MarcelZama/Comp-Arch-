   ORG    $1000
   
EXIT          EQU 0      USED TO EXIT ASSEMBLY PROGRAM
MIN_TREES     EQU 0      MIN NUMBER OF TREES
MAX_TREES     EQU 9      MAX NUMBER OF TREES
MIN_WINDMILLS EQU 0      MIN WEAPONS
MAX_WINDMILLS EQU 5      MAX WEAPONS
WIN_POINT     EQU 100    POINTS ACCUMILATED ON WIN
LOSE_POINT    EQU 0      POINTS DEDUCTED ON A LOSS
MINE_LOC      EQU 100    USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP


*START OF GAME
START:    
    MOVE.B #50,$4000  # 50 is the initial %nr of carbons in the atmoshere.
    MOVE.B $4000,D3
    
    CMP #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BNE END_GAME
    BRA GAME_LOOP
GAME_LOOP:
    MOVE.B $4000,D3 # move all the carbons numbers to 
    CMP #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BNE END_GAME
    BSR INPUT
    BSR UPDATE
    BSR DRAW
    BRA GAME_LOOP
INPUT:
    Mess
    MOVE.B #4,D0
    TRAP #15
    MOVE.B D1,$2000
    
    BSR     POTIONS         BRANCH TO POTION INPUT SUBROUTINE
    BSR     WEAPONS         BRANCH TO WEAPONSS INPUT SUBROUTINE
    RTS
UPDATE:
    MOVE.B $2010,D4
    SUB #10,D4
    MOVE.B D4,$2010
    
    CMP #0,D4
    BEQ CHANGE_GSM
HUD:

    BSR     ENDL
    BSR     DECORATE
    LEA     HUD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.B  (A3),D1     RETRIEVE THE VALUE A3 POINT TO AND MOVE TO D1
    MOVE.B  #3,D0       MOVE LITERAL 3 TO D0
    TRAP    #15         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    BSR     DECORATE
    RTS
DECORATE:
    MOVE.B  #60, D3
    BSR     ENDL
DRAW:
    RTS
CHANGE_GSM:
    MOVE.B #0,$2000
    BRA DRAW
END_GAME:
    LEA MESSAGE_WANNAREPEATE, A1 # DISPLAY WANT TO REPEATE?
    MOVE.B #14,D0
    TRAP #15
    
    LEA MESSAGE_YES, A1 # DISPLAY 1 FOR YES
    MOVE.B #14,D0
    TRAP #15
    
    LEA MESSAGE_NO, A1 # DISPLAY 0 FOR NO
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15
    
    CMP #1,D1 # IF YES STARTS AGAIN
    BNE START
    
*ADD ONE MORE LINE
ENDL:                 
    MOVEM.L D0/A1,-(A7)
    MOVE    #14,D0
    LEA     CRLF,A1
    TRAP    #15
    MOVEM.L (A7)+,D0/A1
    RTS
    MOVE.B D1,$2000


    SIMHALT             ; halt simulator

MESSAGE_EARTH:       DC.B 'STILL FIGHTING THE CLIMAT CHANGE',0
MESSAGETWO_EARTH:    DC.B 'THE TEMPERATURE RISEN TOO MUCH',0
MESSAGE              DC.B 'HEY YOU SAVED THE WORLD, YOU WON A BILLION EURO !!!!                                            ,joke.', 0
MESSAGE_WANNAREPEATE DC.B 'Hey,already lost? Want to try one more time?',0
MESSAGE_YES          DC.B 'Press 1 for YES.',0
MESSAGE_NO           DC.B 'Press 0 for NO.',0

TREES_MSG:         DC.B 'NUMBER OF TREES : ',0
WINDMILLS_MSG:         DC.B 'NUMBER OF TREES : ',0
HUD_MSG:        DC.B    'SCORE : ',0

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
