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
    MOVE.B #0,$4100 # 0 initial number of Trees
    MOVE.B #0,$4200 # 0 initial number of WindMills
    MOVE.B #0,$4300 # 0 initial number of SolarPanels
    
    MOVE.B #0,$4400  # Used to check if the 10 Trees mission is completed or not
    MOVE.B #0,$4410  # Used to check if the 10 WindMills mission is completed or not
    MOVE.B #0,$4420  #Used to check if the 5 SolarPanels mission is completed or not
    
    
    MOVE.B #100,D5   # Money
    MOVE.B #0,D7     # Days
    MOVE.B #0,$4400  # TrasnfersNo
 
    MOVE.B #30,$4000  # 50 is the initial %nr of carbons in the atmoshere. score
    MOVE.B $4000,D3  # carbon
    
    
    LEA WELCOME, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BRA GAME_LOOP 
GAME_LOOP:
    CMP.B #0,D3 #if the number of carbons is equal to 0 the game ends if not it continues
    BEQ END_GAME
    BLT END_GAME
    
    CMP.B #100,D3
    BEQ YOUWON
    BGT YOUWON
    
    BSR CHECKIT
    BSR CLEAR_SCREEN
    BSR TOP_LINE
    BSR MENU
    BSR INPUT
    BSR CLEAR_SCREEN
    
    CMP.B #1,$2000
    BEQ SELL
    
    CMP.B #2,$2000
    BEQ BUY
    
    CMP.B #3,$2000
    BEQ QUESTS
    
    BSR CLEAR_SCREEN
    BRA GAME_LOOP
INPUT: 
    LEA SPACE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
    
    LEA YOURCHOISE_MSG,A1
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
    BSR TOP_LINE

    LEA BUY_MENU, A1 
    MOVE.B #14,D0
    TRAP #15
    
    BSR INPUT
    
    CMP.B #1,$2000
    BEQ BUYTREES
    
    CMP.B #2,$2000
    BEQ BUYWINDMILLS
    
    CMP.B #3,$2000
    BEQ BUYSOLLARPANELS
    
    BSR GAME_LOOP
BUYTREES:
    MOVE.B $4100,D6
    ADD #1,D6
    MOVE.B D6,$4100
    
    SUB #15,D5
    ADD #5,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BRA TRANSFERS
    BSR GAME_LOOP
BUYWINDMILLS:
    MOVE.B $4200,D6
    ADD #1,D6
    MOVE.B D6,$4200
    
    SUB #35,D5
    ADD #10,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR TRANSFERS
    BSR GAME_LOOP
BUYSOLLARPANELS:
    MOVE.B $4300,D6
    ADD #1,D6
    MOVE.B D6,$4300
    
    SUB #50,D5
    ADD #25,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR TRANSFERS
    BSR GAME_LOOP
SELL:
    BSR TOP_LINE
    
    LEA SELL_MENU, A1 
    MOVE.B #14,D0
    TRAP #15

    BSR INPUT
    
    CMP.B #1,$2000
    BEQ SELLTREES
    
    CMP.B #2,$2000
    BEQ SELLWINDMILLS
    
    CMP.B #3,$2000
    BEQ SELLSOLLARPANELS
    
    BSR GAME_LOOP
SELLTREES:
    MOVE.B $4100,D6
    SUB #1,D6
    MOVE.B D6,$4100
    
    ADD #25,D5
    SUB #5,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR TRANSFERS
    BSR GAME_LOOP
SELLWINDMILLS:
    MOVE.B $4200,D6
    SUB #1,D6
    MOVE.B D6,$4200 
   
    ADD #55,D5
    SUB #10,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR TRANSFERS
    BSR GAME_LOOP
SELLSOLLARPANELS:
    MOVE.B $4300,D6
    SUB #1,D6
    MOVE.B D6,$4300  
  
    ADD #55,D5
    SUB #25,D3
    
    LEA SUCCESS_MSG, A1 
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #100,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    BSR TRANSFERS
    BSR GAME_LOOP
CLEAR_SCREEN: 
    MOVE.B  #11,D0      CLEAR SCREEN
    MOVE.W  #$FF00,D1
    TRAP    #15 
    
    RTS
TRANSFERS:
    ADD.B #1,$4400 #TRANSFERS
    
    MOVE.B $4400,D6
    CMP.B #3,D6
    BEQ DAYSADD
    
    BRA GAME_LOOP
REPEAT:
    MOVE.B #0,$4400
    BRA DAYSCHANGE
DAYSADD:
    ADD #1,D7
    BRA REPEAT
DAYSCHANGE:
    CMP.B #5,D7
    BEQ EVENT1
    CMP.B #6,D7
    BEQ EVENT2
    CMP.B #7,D7
    BEQ EVENT3
    CMP.B #8,D7
    BEQ EVENT4
    CMP.B #9,D7
    BEQ EVENT5
    CMP.B #10,D7
    BEQ EVENT6
    CMP.B #10,D7
    BGT EVENT7
    
    BRA GAME_LOOP
QUESTS:
    BSR TOP_LINE
    
    LEA ACHEVEMENTS,A1
    MOVE.B #14,D0
    TRAP #15
 
    BSR INPUT
    
    CMP.B #1,$2000
    BEQ GAME_LOOP    
    
TOP_LINE:
    LEA DAY_MSG,A1    # DAYS MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D7,D1       # DAYS
    MOVE.B #3,D0
    TRAP #15

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
    
    
    MOVE.B $4100,D6
  
    LEA TREES_MSG,A1    # TREE MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D6,D1         # TREE 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,$4100
    
    MOVE.B $4200,D6
    
    LEA WINDMILLS_MSG,A1    # WINDMILLS MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D6,D1         # WINDMILLS 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D1,$4200
    
    MOVE.B $4300,D6
    
    LEA SolarPanels_MSG,A1    # SolarPanels MSG
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.L D6,D1         # SolarPanels 
    MOVE.B #3,D0
    TRAP #15
    
    MOVE.B D6,$4300
    
    LEA SPACE_MSG,A1
    MOVE.B #14,D0
    TRAP #15
     
    RTS
END_GAME:
    BSR CLEAR_SCREEN
    
    LEA MESSAGE_WANNAREPEATE, A1 # DISPLAY WANT TO REPEATE?
    MOVE.B #14,D0
    TRAP #15
    
    LEA YOURCHOISE_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15
    
    CMP.B #1,D1 # IF YES STARTS AGAIN
    BEQ START
    BNE ENDL
YOUWON:
    BSR CLEAR_SCREEN
   
    LEA MESSAGE_YOUWON, A1
    MOVE.B #14,D0
    TRAP #15
 
    LEA YOURCHOISE_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    MOVE.B #4,D0 # INPUT A NR FROM THE KEYBOARD
    TRAP #15
    
    CMP.B #1,D1 # IF YES STARTS AGAIN
    BEQ START
    BNE ENDL
EVENT1: 
    SUB #15,D3
    
    BSR CLEAR_SCREEN
    
    LEA DAY5_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    RTS # DAY5 -15CARBON
EVENT2:
    ADD #5,D3
        
    BSR CLEAR_SCREEN
    
    LEA DAY6_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15    
    
    RTS # DAY6 +5CARBON
EVENT3:
    SUB #5,D3
        
    BSR CLEAR_SCREEN
    
    LEA DAY7_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    RTS # DAY7 -5CARBON
EVENT4:
    SUB #10,D3
        
    BSR CLEAR_SCREEN
    
    LEA DAY8_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    RTS # DAY8 -10CARBON
EVENT5:
    ADD #500,D5
        
    BSR CLEAR_SCREEN
    
    LEA DAY9_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15    
    
    RTS # DAY9 +500 MONEY
EVENT6:
    ADD #500,D5
    ADD #25,$D3
        
    BSR CLEAR_SCREEN
    
    LEA DAY10_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    RTS # DAY10 +500 MONEY AND +25 CARBON
EVENT7:
    ADD #20,D5
    SUB #5,D3
        
    BSR CLEAR_SCREEN
    
    LEA DAY11PLUS_MSG, A1
    MOVE.B #14,D0
    TRAP #15
    
    move.l   #500,D1     ; delay in 1/100th of seconds
    moveq    #23,D0
    trap     #15
    
    RTS # DAY 11+ +20 MONEY AND -5 CARBON
CHECKIT:
    MOVE.B $4100,D6
    CMP.B #10,D6
    BEQ TENTREESS

    MOVE.B $4200,D6
    CMP.B #10,D6
    BEQ TENWINDMILLSS
    
    MOVE.B $4300,D6
    CMP.B #5,D6
    BEQ TENSOLARPANELSS
    
    RTS
TENTREESS:
    CMP.B #0,$4400
    BEQ ADD50
    MOVE.B #1,$4400
ADD50:
    ADD 50,D5
TENWINDMILLSS:
    CMP.B #0,$4410
    BEQ ADD100
    ADD 100,D5
    MOVE.B #1,$4410
ADD100:
    ADD 50,D5
TENSOLARPANELSS:
    CMP.B #0,$4420
    BEQ ADD150
    MOVE.B #1,$4420
ADD150:
    ADD 150,D5
ENDL: 
    BSR CLEAR_SCREEN
         
    LEA GOODBYE, A1
    MOVE.B #14,D0
    TRAP #15
          
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
                     
GOODBYE:             DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
                     DC.B '                _____  ____   ____  _____  ______     ________ ', $0D,$0A
                     DC.B '               / ____|/ __ \ / __ \|  __ \|  _ \ \   / /  ____|', $0D,$0A
                     DC.B '              | |  __| |  | | |  | | |  | | |_) \ \_/ /| |__   ', $0D,$0A
                     DC.B '              | | |_ | |  | | |  | | |  | |  _ < \   / |  __|  ', $0D,$0A
                     DC.B '              | |__| | |__| | |__| | |__| | |_) | | |  | |____ ', $0D,$0A
                     DC.B '               \_____|\____/ \____/|_____/|____/  |_|  |______|', $0D,$0A
                     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
                     DC.B '                                                              _____', $0D,$0A
                     DC.B '                                                          ,-:` \; ,` -, ', $0D,$0A
                     DC.B '                                                        . -;_,;   :-;_, .', $0D,$0A
                     DC.B '                                                       /;    /    ,  _`.-\', $0D,$0A
                     DC.B '                                                      |  `. (`     /` ` \`|', $0D,$0A
                     DC.B '                                                      |:.  `\`-.   \_   / |', $0D,$0A
                     DC.B '                                                      |     (   `,  .`\ ; |', $0D,$0A
                     DC.B '                                                       \     | .      `- /', $0D,$0A
                     DC.B '                                                        `.   ;/        ."', $0D,$0A
                     DC.B '                                                           `-._____."', $0D,$0A,0

MESSAGE_EARTH:       DC.B '     STILL FIGHTING THE CLIMAT CHANGE',0
MESSAGETWO_EARTH:    DC.B '     THE TEMPERATURE RISEN TOO MUCH',0
MESSAGE              DC.B '     HEY YOU SAVED THE WORLD, YOU WON A BILLION EURO !!!!                                            ,joke.', 0

MESSAGE_YOUWON:      DC.B '  ___  __   __  _   __  ___   __  _____  _  _  _     __  _____  _   __   __  _ ', $0D,$0A
                     DC.B ' / _/ /__\ |  \| | / _]| _ \ /  \|_   _|| || || |   /  \|_   _|| | /__\ |  \| |', $0D,$0A
                     DC.B '| \__| \/ || |   || [/\| v /| /\ | | |  | \/ || |_ | /\ | | |  | || \/ || |   |', $0D,$0A
                     DC.B ' \__/ \__/ |_|\__| \__/|_|_\|_||_| |_|   \__/ |___||_||_| |_|  |_| \__/ |_|\__|', $0D,$0A
                     DC.B '                             __   __  __    _  _  ', $0D,$0A
                     DC.B '                             \ `v  / /__\  | || | ', $0D,$0A
                     DC.B '                              `. .  | \/ | | \/ |', $0D,$0A
                     DC.B '                               !_!   \__/   \__/ ', $0D,$0A
                     DC.B '                     _   _    __    __  _      _    _    _ ', $0D,$0A
                     DC.B '                    | | | |  /__\  |  \| |    / \  / \  / \', $0D,$0A
                     DC.B '                    |  V  | | \/ | | |   |    \_/  \_/  \_/', $0D,$0A
                     DC.B '                    !_/ \_!  \__/  |_|\__|    (_)  (_)  (_) ', $0D,$0A
                     DC.B '', $0D,$0A
                     DC.B '', $0D,$0A
                     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
                     DC.B '     Want to try one more time?', $0D,$0A
                     DC.B '     Press 1 for YES.', $0D,$0A
                     DC.B '     Press 0 for NO.', $0D,$0A,0

MESSAGE_WANNAREPEATE DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
                     DC.B '     Hey,already lost? Want to try one more time?', $0D,$0A
                     DC.B '     Press 1 for YES.', $0D,$0A
                     DC.B '     Press 0 for NO.', $0D,$0A, 0

SELL_MENU:            DC.B '    SELL MENU:', $0D,$0A
                      DC.B '    Press 1 To Sell Trees (Price 25).', $0D,$0A
                      DC.B '    Press 2 To Sell WindMills (Price 55).', $0D,$0A
                      DC.B '    Press 3 To Sell SolarPanels (Price 55).', $0D,$0A, 0
                      
BUY_MENU:             DC.B '    BUY MENU:', $0D,$0A
                      DC.B '    Press 1 To Buy Trees (Price 15).', $0D,$0A
                      DC.B '    Press 2 To Buy WindMills (Price 35).', $0D,$0A
                      DC.B '    Press 3 To Buy SolarPanels (Price 50).', $0D,$0A, 0

SHOPMENU_LAYOUT          DC.B '     MENU:', $0D,$0A
                         DC.B '     Press 1 if you want to sell something.', $0D,$0A
                         DC.B '     Press 2 if you want to buy  something.', $0D,$0A
                         DC.B '     ', $0D,$0A
                         DC.B '     Press 3 if you want to see the list of Quests.', $0D,$0A, 0

DAY5_MSG:     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 5 ,Something teribble happened ,a forest burned in fire', $0D,$0A
              DC.B 'the quality of the air dropped down with 15 marks.', $0D,$0A, 0
              
DAY6_MSG:     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 6 ,People came to help you,they collected all the rubish around you farm,', $0D,$0A
              DC.B 'this increased the air quality with 5 marks.', $0D,$0A, 0
              
DAY7_MSG:     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 7 ,Becouse of the wind all the rubbish came back.', $0D,$0A, 0
              
DAY8_MSG:     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 8 ,Becouse of the hot temperature all the rubbish around the farm burned in fire.', $0D,$0A, 0

DAY9_MSG:     DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 9 ,People collected 500 Money and donated them to you to help fight the Climate Change.', $0D,$0A, 0

DAY10_MSG:    DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is Day 10 ,People collected 500 Money more and posted on instagram pictures', $0D,$0A
              DC.B 'how they planted trees in their yard this increased the air quality by 25.', $0D,$0A, 0

DAY11PLUS_MSG: DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A
              DC.B 'It is another new day ,People donate you less (only 20 Money) and none helps you anymore', $0D,$0A
              DC.B ' with the rubbish this is why the quality of air dropped down with 5 marks.', $0D,$0A, 0

TREES_MSG:         DC.B  $0D,$0A,$0D,$0A   
                   DC.B '          TREES : ', 0
WINDMILLS_MSG:     DC.B '             WindMills : ', 0
SolarPanels_MSG:   DC.B '        Solar Panels : ', 0
DAY_MSG:           DC.B '       Days: ', 0
SCORE_MSG:         DC.B '           SCORE : ', 0
MONEY_MSG:         DC.B '                        MONEY : ', 0
SPACE_MSG:         DC.B '', $0D,$0A, $0D,$0A, $0D,$0A, $0D,$0A, 0
YOURCHOISE_MSG:    DC.B '', $0D,$0A
                   DC.B '     What do you want to choose? --> ', 0

SUCCESS_MSG:       DC.B '',$0D,$0A,$0D,$0A,$0D,$0A
                   DC.B '   .d8888b 888  888 .d8888b .d8888b .d88b. .d8888b .d8888b  ',$0D,$0A
                   DC.B '   88K     888  888d88P"   d88P"   d8P  Y8b88K     88K      ',$0D,$0A
                   DC.B '   "Y8888b.888  888888     888     88888888"Y8888b."Y8888b. ',$0D,$0A
                   DC.B '        X88Y88b 888Y88b.   Y88b.   Y8b.         X88     X88 ',$0D,$0A
                   DC.B '    88888P  "Y88888 "Y8888P "Y8888P "Y8888  88888P  88888P  ',$0D,$0A, 0
                   
ACHEVEMENTS:       DC.B '',$0D,$0A, $0D,$0A
                   DC.B '   Quests:',$0D,$0A,$0D,$0A
                   DC.B '   Collect 10 Trees (reward 25 coins)',$0D,$0A
                   DC.B '   Collect 10 WindMills (reward 50 coins)',$0D,$0A
                   DC.B '   Collect 5 SolarPanels (reward 50 coins)',$0D,$0A,$0D,$0A
                   DC.B '   Win the game (reward "My Respect")',$0D,$0A
                   DC.B '',$0D,$0A
                   DC.B '',$0D,$0A
                   DC.B '   Press 1 to go back to the main menu.',$0D,$0A,0

LORE:              DC.B '                       HISTORY',$0D,$0A,$0D,$0A,$0D,$0A,$0D,$0A
                   DC.B '          You are a farmer hwo loves to work on the field,but becouse of all the climate change',$0D,$0A
                   DC.B '          and the temperature rise you lost a lot of your crops. You woke up one morning and decided',$0D,$0A
                   DC.B '          that you need to do something,something to help the planet.',$0D,$0A,$0D,$0A
                   DC.B '          You are a farmer hwo loves to work on the field,but becouse of all the climate change',$0D,$0A
    END    START        ; last line of source























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
