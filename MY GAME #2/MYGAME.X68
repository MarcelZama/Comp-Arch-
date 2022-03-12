   ORG    $1000
   
EXIT          EQU 0      USED TO EXIT ASSEMBLY PROGRAM
MIN_TREES     EQU 0      MIN NUMBER OF TREES
MAX_TREES     EQU 9      MAX NUMBER OF TREES
MIN_WINDMILLS EQU 0      MIN WindMIlls
MAX_WINDMILLS EQU 5      MAX WindMIlls
WIN_POINT     EQU 100    POINTS ACCUMILATED ON WIN
LOSE_POINT    EQU 0      POINTS DEDUCTED ON A LOSS
MINE_LOC      EQU 100    USED BELOW FOR SOME SIMPLE COLLISION DETECTION USING CMP 10


*START OF GAME
START:    
    MOVE.B #50,$4000  # 50 is the initial %nr of carbons in the atmoshere.
    MOVE.B $4000,D3
    
    LEA WELCOME, A1 
    MOVE.B #14,D0
    TRAP #15
    
    
    
    CMP #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BNE END_GAME
    BRA GAME_LOOP 
GAME_LOOP:
    MOVE.B $4000,D3 # move all the carbons numbers to 
    CMP #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BNE END_GAME
    BSR MENU
    BSR CLEAR_SCREEN
    BSR INPUT
    BSR UPDATE
    BSR DRAW
    BRA GAME_LOOP
INPUT: 
    MOVE.B #4,D0 
    TRAP #15
    MOVE.B D1,$2000

    RTS
MENU:
    LEA SHOPMENU_LAYOUT, A1 # DISPLAY MENU
    MOVE.B #14,D0
    TRAP #15
    
     LEA BUY_OPTION_MSG, A1 # INPUT 1 TO BUY 
    MOVE.B #14,D0
    TRAP #15
    
     LEA SELL_OPTION_MSG, A1 # INPUT 0 FOR SELL
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15 
    
    CMP #1,D4 #IF 1 GO TO BUY MENU
    BEQ BUY
    
    CMP #0,D4 #IF 0 GO TO SELL MENU
    BEQ SELL
BUY:

SELL:
    LEA SELL_MENU, A1 
    MOVE.B #14,D0
    TRAP #15
    
    LEA TREES_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    LEA WINDMILLS_MSG, A1
    MOVE.B #14,D0 
    TRAP #15
    
    LEA SolarPanels_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    

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
CLEAR_SCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15 
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
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15
    
    CMP #1,D1 # IF YES STARTS AGAIN
    BNE START
    BSR ENDL
    
*ADD ONE MORE LINE
ENDL:                 
    MOVE.B #9,D0
    TRAP #15


    SIMHALT             ; halt simulator
WELCOME:             DC.B '                     Welcome to my Projetc C00260146', $0D,$0A
                     DC.B 'This game is about,how can we humankinds save the planet we live on.', $0D,$0A
                     DC.B 'The planet we ruined. The planet that suffers because of us.', $0D,$0A, $0D,$0A, 0
                     DC.B 'Enjoy the GamePlay!', $0D,$0A, 0
  

MESSAGE_EARTH:       DC.B 'STILL FIGHTING THE CLIMAT CHANGE',0
MESSAGETWO_EARTH:    DC.B 'THE TEMPERATURE RISEN TOO MUCH',0
MESSAGE              DC.B 'HEY YOU SAVED THE WORLD, YOU WON A BILLION EURO !!!!                                            ,joke.', 0
MESSAGE_WANNAREPEATE DC.B 'Hey,already lost? Want to try one more time?', $0D,$0A
                     DC.B 'Press 1 for YES.', $0D,$0A
                     DC.B 'Press 0 for NO.', $0D,$0A, 0

SELL_MENU:            DC.B 'SELL MENU:',0
BUY_MENU:             DC.B 'BUY MENU:',0

SHOPMENU_LAYOUT          DC.B 'MENU:',0
BUY_OPTION_MSG:            DC.B 'Press 1 if you want to sell something.',0
Sell_OPTION_MSG:           DC.B 'Press 2 if you want to buy  something.', $0D,$0A, 0


TREES_MSG:         DC.B 'NUMBER OF TREES : ',0
WINDMILLS_MSG:     DC.B 'NUMBER OF WindMills: ',0
SolarPanels_MSG:    DC.B 'NUMBER OF Solar Panels: ',0
HUD_MSG:        DC.B    'SCORE : ',0

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
