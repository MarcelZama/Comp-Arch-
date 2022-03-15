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
    MOVE.B #10,$4100 # 0 initial number of Trees
    MOVE.B #13,$4200 # 0 initial number of WindMills
    MOVE.B #15,$4300 # 0 initial number of SolarPanels
    MOVE.B #100,D5 #Money
 
    MOVE.B #50,$4000  # 50 is the initial %nr of carbons in the atmoshere. score
    MOVE.B $4000,D3  # carbon
    
    
    LEA WELCOME, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #200,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR CLEAR_SCREEN    #CMPA.L D3,A6 if the number of carbons is equal to 0 the game ends if not it continues

    BRA GAME_LOOP 
GAME_LOOP:
    MOVE.B $4000,D3 # move all the carbons numbers to 
    CMP.B #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BEQ END_GAME
    BGT TOP_LINE
    BGT MENU
    BGT INPUT
    
    CMP.B #1,$2000
    BEQ CLEAR_SCREEN
    BEQ SELL
    
    CMP.B #2,$2000
    BEQ CLEAR_SCREEN
    BEQ BUY
    
    BSR CLEAR_SCREEN
    BRA GAME_LOOP
INPUT: 
    LEA SPACE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 
    TRAP #15
    MOVE.B D1,$2000

    RTS
MENU:
    LEA SHOPMENU_LAYOUT, A1 # DISPLAY MENU
    MOVE.B #14,D0
    TRAP #15
    
    RTS
BUY:
    LEA BUY_MENU, A1 
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15
    
    CMP #1,D4
    
    RTS
BUYTRESS:
    MOVE.B $4100,D3
    ADD #1,D3
    MOVE.B D3,$4100
    
    SUB #150,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
BUYWINDMILLS:
    MOVE.B $4200,D3
    ADD #1,D3
    MOVE.B D3,$4200
    
    SUB #350,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
BUYSOLLARPANELS:
    MOVE.B $4300,D3
    ADD #1,D3
    MOVE.B D3,$4300
    
    SUB #500,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
SELL:
    LEA SELL_MENU, A1 
    MOVE.B #14,D0
    TRAP #15

    BRA INPUT
    
    CMP.B #1,D4
    BEQ SELLTREES
    CMP.B #2,D4
    BEQ SELLWINDMILLS
    CMP.B #3,D4
    BEQ SELLSOLLARPANELS

    RTS
SELLTREES:
    MOVE.B $4100,D3
    SUB #1,D3
    MOVE.B D3,$4100
    
    ADD #250,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
SELLWINDMILLS:
    MOVE.B $4200,D3
    SUB #1,D3
    MOVE.B D3,$4200 
   
    ADD #550,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
SELLSOLLARPANELS:
    MOVE.B $4300,D3
    SUB #1,D3
    MOVE.B D3,$4300  
  
    ADD #550,D5
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    RTS
CLEAR_SCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15 
    RTS
TOP_LINE:
    LEA MONEY_MSG,A1    # MONEY MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D5,D1       # MONEY
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,D5
    
    LEA SCORE_MSG,A1    # SCORE MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D3,D1         # SCORE
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,$4000
    
    
    MOVE.B $4100,D7
  
    LEA TREES_MSG,A1    # TREE MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D7,D1         # TREE 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,$4100
    
    MOVE.B $4200,D7
    
    LEA WINDMILLS_MSG,A1    # WINDMILLS MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D7,D1         # WINDMILLS 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,$4200
    
    MOVE.B $4300,D7
    
    LEA SolarPanels_MSG,A1    # SolarPanels MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D7,D1         # SolarPanels 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D7,$4300
    
    LEA SPACE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    
    RTS
    
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
EVENT1: 
    SUB #15,D3
    RTS # DAY5 -15CARBON
EVENT2:
    ADD #5,D3
    RTS # DAY6 +5CARBON
EVENT3:
    SUB #5,D3
    RTS # DAY7 -5CARBON
EVENT4:
    SUB #10,D3
    RTS # DAY8 -10CARBON
EVENT5:
    ADD #500,D5
    RTS # DAY9 +500 MONEY
EVENT6:
    ADD #500,D5
    ADD #25,$D3
    RTS # DAY10 +500 MONEY AND +25 CARBON
ENDL:                 
    MOVE.B #9,D0
    TRAP #15
        

    SIMHALT             ; halt simulator
WELCOME:             DC.B '        	 __      __       .__                               ', $0D,$0A
                     DC.B '        	/  \    /  \ ____ |  |   ____  ____   _____   ____  ', $0D,$0A
                     DC.B '        	\   \/\/   // __ \|  | _/ ___\/  _ \ /     \_/ __ \ ', $0D,$0A    
                     DC.B '        	 \        /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/ ', $0D,$0A
                     DC.B '        	  \__/\  /  \___  >____/\___  >____/|__|_|  /\___  >', $0D,$0A
                     DC.B '        	       \/       \/          \/            \/     \/ ', $0D,$0A
                     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
                     DC.B '                        Welcome to my Project C00260146', $0D,$0A, $0D,$0A
                     DC.B '    This game is about,how can we humankinds save the planet we live on.', $0D,$0A
                     DC.B '    The planet we ruined. The planet that suffers because of us....', $0D,$0A, $0D,$0A
                     DC.B '    Enjoy the GamePlay!!!!', $0D,$0A,$0D,$0A
                     DC.B '   _____              .___       ___.          ', $0D,$0A
                     DC.B '  /     \ _____     __| _/____   \_ |__ ___.__.', $0D,$0A
                     DC.B ' /  \ /  \\__  \   / __ |/ __ \   | __ <   |  |', $0D,$0A
                     DC.B '/    Y    \/ __ \_/ /_/ \  ___/   | \_\ \___  |', $0D,$0A
                     DC.B '\____|__  (____  /\____ |\___  >  |___  / ____|', $0D,$0A
                     DC.B '        \/     \/      \/    \/       \/\/     ', $0D,$0A
                     DC.B '    _____                             .__    __________                      ', $0D,$0A
                     DC.B '   /     \ _____ _______   ____  ____ |  |   \____    /____    _____ _____   ', $0D,$0A
                     DC.B '  /  \ /  \\__  \\_  __ \_/ ___\/ __ \|  |     /     /\__  \  /     \\__  \  ', $0D,$0A
                     DC.B ' /    Y    \/ __ \|  | \/\  \__\  ___/|  |__  /     /_ / __ \|  Y Y  \/ __ \_', $0D,$0A
                     DC.B ' \____|__  (____  /__|    \___  >___  >____/ /_______ (____  /__|_|  (____  /', $0D,$0A
                     DC.B '         \/     \/            \/    \/               \/    \/      \/     \/ ', $0D,$0A,0

MESSAGE_EARTH:       DC.B 'STILL FIGHTING THE CLIMAT CHANGE',0
MESSAGETWO_EARTH:    DC.B 'THE TEMPERATURE RISEN TOO MUCH',0
MESSAGE              DC.B 'HEY YOU SAVED THE WORLD, YOU WON A BILLION EURO !!!!                                            ,joke.', 0
MESSAGE_WANNAREPEATE DC.B 'Hey,already lost? Want to try one more time?', $0D,$0A
                     DC.B 'Press 1 for YES.', $0D,$0A
                     DC.B 'Press 0 for NO.', $0D,$0A, 0

SELL_MENU:            DC.B 'SELL MENU:', $0D,$0A
                      DC.B 'Press 1 To Sell Trees (Price 5).', $0D,$0A
                      DC.B 'Press 2 To Sell WindMills (Price 8).', $0D,$0A
                      DC.B 'Press 3 To Sell SolarPanels (Price 25).', $0D,$0A, 0
                      
BUY_MENU:             DC.B 'BUY MENU:', $0D,$0A
                      DC.B 'Press 1 To Buy Trees (Price 3).', $0D,$0A
                      DC.B 'Press 2 To Buy WindMills (Price 5).', $0D,$0A
                      DC.B 'Press 3 To Buy SolarPanels (Price 15).', $0D,$0A, 0

SHOPMENU_LAYOUT          DC.B 'MENU:', $0D,$0A
                         DC.B 'Press 1 if you want to sell something.', $0D,$0A
                         DC.B 'Press 2 if you want to buy  something.', $0D,$0A, 0


TREES_MSG:         DC.B  $0D,$0A,$0D,$0A   
                   DC.B '          TREES : ', 0
WINDMILLS_MSG:     DC.B '             WindMills : ', 0
SolarPanels_MSG:   DC.B '        Solar Panels : ', 0
SCORE_MSG:         DC.B '           SCORE : ', 0
MONEY_MSG:         DC.B '                        MONEY : ', 0
SPACE_MSG:         DC.B '', $0D,$0A, 0
YOURCHOISE_MSG:    DC.B 'What do you want to choose? --> ', 0

SUCCESS_MSG:       DC.B '.d8888b 888  888 .d8888b .d8888b .d88b. .d8888b .d8888b  ',$0D,$0A
                   DC.B '88K     888  888d88P"   d88P"   d8P  Y8b88K     88K      ',$0D,$0A
                   DC.B '"Y8888b.888  888888     888     88888888"Y8888b."Y8888b. ',$0D,$0A
                   DC.B '     X88Y88b 888Y88b.   Y88b.   Y8b.         X88     X88 ',$0D,$0A
                   DC.B ' 88888P  "Y88888 "Y8888P "Y8888P "Y8888  88888P  88888P  ',$0D,$0A, 0
    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
