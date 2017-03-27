    org $2000

*-------------------------------------------------------
*Choose to be Commander Sheppard or Reapers Arturas Janaviucs Student ID :C00219371

*-------------------------------------------------------

*-------------------------------------------------------
*Validation values to be used, modify as needed Name: 
*Add additional validation values as required
*-------------------------------------------------------
exit        EQU 0      used to exit assembly program
min_fuel    EQU 120    min fuel requirement
min_ship    EQU 1      min number of ships
max_ship    EQU 9      max number of ships
min_crew    EQU 6      min crew
min_rate    EQU 1      min rate of fuel use based of speed
max_rate    EQU 5      max rate e.g. Flank Speed       
hit_point   EQU 5      points accumilated on enemy ship strike
miss_point  EQU 8      points deducted for ordinace miss
mine_loc    EQU 100    example for a hit
credit_amount   EQU 100   amount of money player has to spend
no_of_ships     EQU 10  number of ships the player has
ship_cost       EQU 200  cost per ship
fuel_amount     EQU 210 fuel per ship
fuel_cost       EQU 220 cost per fuel
crew_amount     EQU 20

*Start of Game
start:
    move.b  #100,$4000 put score/health in memory location $4000
    lea     $4000,A3   assign address A3 to that memory location

    move.l  #5000, credit_amount
    move.l  #1500, ship_cost
    move.b  #100,   fuel_amount
    move.b  #5, fuel_cost

    
    
    bsr     welcome    branch to the welcome subroutine
    bsr     choice
    bsr     input      branch to the input subroutine
    bsr     planet     branch to the planet subroutine
    bsr     game       branch to the game subroutine
   
*Game loop
    org     $3000      the rest of the program is to be located from 3000 onwards

*-------------------------------------------------------
*-------------------Game Subroutine---------------------
*-------------------------------------------------------
game:
    bsr     gameloop   branch to gameloop subroutine
    rts                return from game: subroutine
          
end:
    simhalt
*-------------------------------------------------------
*-------------------Welcome Subroutine------------------
*-------------------------------------------------------
welcome:
    bsr     endl            branch to endl subroutine
    lea     welcome_msg,A1  assign message to address register A1
    move.b  #14,D0          move literal 14 to DO
    trap    #15             trap and interpret value in D0
    bsr     endl            branch to endl subroutine
    rts               *return from welcome: subroutine
    
    
choice:
    bsr     endl                    choose between shephard and reapers
    bsr     decorate
    lea     choice_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     endl
    move.b  #4,D0
    trap    #15
    cmp     #1,D1
    beq     shepard
    cmp     #2,D1
    beq     reapers
    bne     choice
    bsr     decorate
    rts
shepard:
    bsr endl
    bsr decorate                    this is executed if u input 1 and choose shepard
    lea shepard_msg,A1
    move.b  #14,D0
    trap    #15
    bsr decorate
    rts
    
        
reapers:
    bsr endl
    bsr decorate                    this is what is executed if u input 2 and choose reapers
    lea repear_msg,A1
    move.b  #14,D0
    trap    #15
    bsr decorate
    rts
*-------------------------------------------------------
*---------Gameplay Input Values Subroutine--------------
*-------------------------------------------------------    
input:
    bsr     input_welcome   branch to input message subroutine

    bsr     fuel
    bsr     crew            branch to crew input subroutine
    rts
input_welcome:
    bsr     endl
    bsr     decorate
    lea     input_msg, A1
    move.b  #14, D0
    trap    #15                 this displays the welcome message
    bsr     endl
    lea     credit_msg, A1
    move.b  #14, D0
    trap    #15
    move.l  credit_amount, D1
    move.b  #3, D0
    trap    #15
    rts
    
    

*-------------------------------------------------------
*----------------Gameloop (main loop)-------------------
*------------------------------------------------------- 
gameloop:
    bsr     update          branch to update game subroutine 
    bsr     clear_screen    clears the screen         
    bsr     draw            branch to draw screen subroutine
    bsr     clear_screen    clears the screen
    bsr     gameplay       branch to gameplay subroutine
    bsr     clear_screen    clears the screen
    bsr     hud             branch to display HUD subroutine
    bsr     clear_screen    clears the screen
    bsr     replay          branch to replay game subroutine
    bsr     clear_screen    clears the screen
    rts                     return from gameloop: subroutine

*-------------------------------------------------------
*---------------Update Mission Progress-----------------
*  Move to battle location, engage enemy, fire and take
*  fire, complete mission and return to base
*------------------------------------------------------- 
update:
    bsr     endl            print a CR and LF
    bsr     decorate        decorate with dots using a loop
    lea     update_msg,A1   
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
*-------------------------------------------------------
*---------------Draw Mission Updates--------------------
* Draw the game progress information, status regarding
* mission
*------------------------------------------------------- 
draw:
    bsr     endl
    bsr     decorate
    lea     draw_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts
    
    
    
*-------------------------------------------------------
*-----------------------Ship Fuel-----------------------
*------------------------------------------------------- 
fuel:
    bsr     endl
    bsr     decorate
    lea     fuel_msg,A1        this is used for the fuel variable
    move.b  #14,D0
    trap    #15
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Ships Crew----------------------
* Number of crew onboard
*-------------------------------------------------------   
crew:
    bsr     endl
    bsr     decorate
    lea     crew_msg,A1
    move.b  #14,D0              branch for taking crew input 
    trap    #15
    move.b  #4, D0
    trap    #15
    move.l  D1, crew_amount
    bsr     decorate
    rts
*-------------------------------------------------------
*-----------------------Planet selection----------------------
* thoosing which planet to go to
*-------------------------------------------------------      
    
planet:
    bsr     endl
    bsr     decorate
    lea     planet_msg,A1
    move.b  #14,D0                  branch to choose between first 3 planets in the game
    trap    #15
    move.b  #4, D0
    trap    #15
    move.b  #1, D2
    cmp     D2, D1
    beq     gorgon
    move.b  #2, D3
    cmp     D3, D1
    beq     hydra
    move.b  #3, D4
    cmp     D4, D1
    beq     pheonix
    bne     planet
    bsr     decorate
    rts
gorgon:
    bsr endl
    bsr decorate
    lea gorgon_msg,A1
    move.b #14,D0                   branch that executes the gorgon mission
    trap   #15  
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    bsr decorate
    bsr choice1mission1
    rts
hydra:
    bsr endl
    bsr decorate
    lea hydra_msg,A1                branch that executes the hydra mission
    move.b #14,D0
    trap   #15
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    bsr decorate
    bsr hydramission1
    rts
pheonix:
    bsr endl
    bsr decorate
    lea pheonix_msg,A1
    move.b #14,D0           branch that executes the pheonix mission
    trap   #15
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    bsr decorate
    bsr pheonixmission1
    rts
*-------------------------------------------------------
*-----------------------Missions ----------------------
* Gorgon
*-------------------------------------------------------    
choice1mission1:
    bsr     endl
    bsr     decorate
    lea     gorgonstory1_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  #4, D0
    trap    #15
    move.b  #1, D2
    cmp     D2, D1                      this is the first mission for gorgon and the choices
    beq     fight
    move.b  #2, D3
    cmp     D3, D1
    beq     talk
    bne     choice1mission1
    bsr     decorate
    rts
    
    
fight:
    bsr endl
    bsr decorate
    lea gorgonchoice1_msg,A1            choice 1
    move.b #14,D0
    trap #15
    bsr decorate
    bsr gorgonmission2
    rts

talk:
    bsr endl
    bsr decorate
    lea gorgonchoice2_msg,A1        choice 2
    move.b #14, D0
    trap #15
    bsr decorate
    bsr gorgonmission2
    rts
gorgonmission2:
    bsr     endl
    bsr     decorate
    lea     gorgonstory2_msg,A1     this is the 2nd mission for gorgon and the choices
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    move.b  #1, D2
    cmp     D2, D1
    beq     abandonplanet
    move.b  #2, D3
    cmp     D3, D1
    beq     saveplanet
    bne     gorgonmission2
    rts
abandonplanet:
    bsr endl
    bsr decorate
    lea gorgonstory2choice1_msg,A1      choice 1 sub the fuel variable if moving from planet
    move.b  #14,D0
    trap    #15
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    bsr decorate
    bsr lumeryamission1
    rts
saveplanet:
    bsr endl
    bsr decorate
    lea gorgonstory2choice2_msg,A1      choice 2
    move.b #14,D0
    trap   #15
    bsr decorate
    bsr gameending1
    rts
*-------------------------------------------------------
*-----------------------Ending ----------------------
* game endings
*-------------------------------------------------------  
gameending1:
    bsr endl
    bsr decorate
    lea ending1_msg,A1  
    move.b  #14,D0          the first ending in the game
    trap    #15
    move.b  #4,D0
    bsr decorate
    rts

    
    
*-------------------------------------------------------
*-----------------------Missions ----------------------
* Lumerya
*-------------------------------------------------------      
lumeryamission1:
    bsr     endl
    bsr     decorate
    lea     lumeryastory1_msg,A1            this is the first mission for Lumerya
    move.b  #14,D0
    trap    #15
    trap    #15
    move.b  #4,D0
    trap    #15
    move.b  #1,D2
    cmp     D2,D1
    beq     gethelp
    move.b  #2,D3
    cmp     D3,D1
    beq     fightlumerya
    bne     lumeryamission1
    bsr     decorate
    rts   
    
gethelp:
    bsr endl
    bsr decorate
    lea ending2_msg,A1
    move.b  #14,D0
    trap    #15                 choice 1
    move.b  #4,D0
    trap    #15
    bsr decorate
    rts
fightlumerya:
    bsr endl
    bsr decorate                choice2
    lea ending3_msg,A1  
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    bsr decorate
    rts    
    
    
*-------------------------------------------------------
*-----------------------Missions ----------------------
* Hydra
*-------------------------------------------------------   

hydramission1:
    bsr     endl                            this is 1st mission for hydra
    bsr     decorate
    lea     hydrastory1_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  #4, D0
    trap    #15
    move.b  #1, D2
    cmp     D2, D1
    beq     backtogorgon
    move.b  #2, D3
    cmp     D3, D1
    beq     random
    bne     hydramission1
    bsr     decorate
    rts
backtogorgon:
    bsr endl
    bsr decorate
    lea hydrachoice1_msg,A1                     choice1
    move #14,D0
    trap #15
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    bsr decorate
    bsr choice1mission1
    rts

random:
    bsr endl
    bsr decorate
    lea hydrachoice2_msg,A1                 choice 2
    move #14, D0
    trap #15
    bsr decorate
    bsr imhotepmission1
    rts

 *-------------------------------------------------------
*-----------------------Missions ----------------------
* Pheonix
*-------------------------------------------------------   
pheonixmission1:
    bsr     endl
    bsr     decorate
    lea     pheonixstory1_msg,A1                this is the 1st mission for pheonix
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    move.b  #1,D2
    cmp     D2,D1
    beq     fight1
    move.b  #2,D3
    cmp     D3,D1
    beq     run
    bne     pheonixmission1
    bsr     decorate
    rts
fight1:
    bsr     endl
    bsr     decorate
    lea     pheonixchoice1_msg,A1           choice 1
    move    #14,D0
    trap    #15
    move.l  crew_amount, D5
    move.b  #2, D6
    sub     D6, D5
    move.l  D5, crew_amount
    bsr     decorate
    bsr     imhotepmission1
    rts
run:
    bsr     endl
    bsr     decorate
    lea     pheonixchoice2_msg,A1           choice 2
    move    #14,D0
    trap    #15
    move.l fuel_amount, D5
    move.l #10, D6
    sub    D6, D5
    move.l D5, fuel_amount
    move.l  credit_amount, D5
    move.b  #200, D6
    add     D6, D5
    move.l  D5, credit_amount
    bsr     decorate
    bsr     imhotepmission1
    rts
*-------------------------------------------------------
*-----------------------Missions ----------------------
* Imhotep
*-------------------------------------------------------   
imhotepmission1:
    bsr     endl
    bsr     decorate
    lea     imhotepstory1_msg,A1        this is the mission for imhotep
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    move.b  #1,D2
    cmp     D2,D1
    beq     hideout
    move.b  #2,D3
    cmp     D3,D1
    beq     negotiate
    bne     imhotepmission1
    bsr     decorate
    rts
hideout:
    bsr endl
    bsr decorate
    lea ending5_msg,A1              option1
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    bsr decorate
    rts
negotiate:
    bsr endl
    bsr decorate
    lea ending4_msg,A1              option2
    move.b  #14,D0
    trap    #15
    move.b  #4,D0
    trap    #15
    bsr decorate
    rts
*-------------------------------------------------------
*---Game Play (Mission Progress, Battle Maneuvers)------
*------------------------------------------------------- 
gameplay:
    bsr     endl
    bsr     decorate
    lea     gameplay_msg,A1
    move.b  #14,D0
    trap    #15
    bsr     decorate
    bsr     collision
    rts

*-------------------------------------------------------
*-----------------Heads Up Display (Score)--------------
* Retrieves the score from memory location
*-------------------------------------------------------   
hud:

    bsr     endl
    bsr     decorate
    lea     hud_msg,A1
    move.b  #14,D0
    trap    #15
    move.b  (A3),D1     retrieve the value A3 point to and move to D1
    move.b  #3,D0       move literal 3 to D0
    trap    #15         intrepret value in D0, which 3 which displays D1
    bsr     decorate
    rts

*-------------------------------------------------------
*-----------------------Taking Fire---------------------
* This could be used for collision detection, if 
*-------------------------------------------------------
collision:
    move.b  #mine_loc,D1
    cmp     #100,D1 is( x == 100)?
	bne     collision_miss if x is equal to 100, then hit
collision_hit:
    *hit
    lea     hit_msg,A1
    move    #14,D0
    trap    #15
    rts
    
collision_miss:
    *miss
    lea     miss_msg,A1
    move    #14,D0
    trap    #15
    rts

*-------------------------------------------------------
*--------------------------Loop-------------------------
*-------------------------------------------------------
loop:
    move.b  #5, D3 loop counter D3=5
next:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     next    repeat until D0=0

*-------------------------------------------------------
*------------------Screen Decoration--------------------
*-------------------------------------------------------
decorate:
    move.b  #60, D3
    bsr     endl
out:
    lea     loop_msg,A1
    move.b  #14,D0
    trap    #15
	sub     #1,D3   decrement loop counter
    bne     out	    repeat until D0=0
    bsr     endl
    rts
    
clear_screen: 
    move.b  #11,D0      clear screen
    move.w  #$ff00,D1
    trap    #15
    rts
*-------------------------------------------------------
*------------------------Replay-------------------------
*-------------------------------------------------------
replay:
    bsr     endl
    lea     replay_msg,A1
    move.b  #14,D0
    trap    #15
    
    move.b  #4,D0
    trap    #15

    cmp     #exit,D1
    beq     end         if SR Z register contains 1 beq => Branch Equals
    bsr     gameloop

endl:
    movem.l D0/A1,-(A7)
    move    #14,D0
    lea     crlf,A1
    trap    #15
    movem.l (A7)+,D0/A1
    rts
    
*-------------------------------------------------------
*-------------------Data Delarations--------------------
*-------------------------------------------------------

crlf:           dc.b    $0D,$0A,0
welcome_msg:    dc.b    '************************************************************'
                dc.b    $0D,$0A
                dc.b    'MASS Effect, command and conqure your fleet of ships'
                dc.b    $0D,$0A
                dc.b    '************************************************************'
                dc.b    $0D,$0A,0
input_msg:      dc.b    'Purchase ships and resources for your mission',0
                    
                        
credit_msg      dc.b    'The amount of credits you currently have is: ',0
fuel_msg:       dc.b    'You start the game with 100 fuel',0


                
ships_msg:      dc.b    'Ships cost 1500 credits each'
                dc.b    $0D,$0A    
                dc.b    'Number of mission ships wanted : ',0
rate_msg:       dc.b    'One Third[1], Two Thirds[2], Standard speed[3], ' 
                dc.b    $0D,$0A
                dc.b    'Full Speed[4], Flank Speed[5] units fuel per click'
                dc.b    $0D,$0A
                dc.b    'Enter Speed : ',0
distance_msg:   dc.b    'Mission distance e.g. 40 (with 100 units of fuel  '
                dc.b    $0D,$0A
                dc.b    'One Third speed 20 units remain for manuvouirs) ships '
                dc.b    $0D,$0A
                dc.b    'without fuel are lost.'
                dc.b    $0D,$0A
                dc.b    'Enter mission distance : ',0
crew_msg:       dc.b    'Each ships need at least 5 crew members'
                dc.b    $0D,$0A
                dc.b    'The cost per crew member is 200 credits'
                dc.b    $0D,$0A
                dc.b    'Enter number of crew required: ',0
planet_msg:     dc.b    'You need to choose which planet to go to'
                dc.b    $0D,$0A
                dc.b    'Press 1 to go to Gorgon'
                dc.b    $0D,$0A
                dc.b    'Press 2 to go to Hydra' 
                dc.b    $0D,$0A
                dc.b    'Press 3 to go to Pheonix'
                dc.b    $0D,$0A
                dc.b    'Enter your choice:',0
gorgon_msg:     dc.b    'You have chosen to go to Gorgon',0
hydra_msg:      dc.b    'You have chosen to go to Hydra',0
pheonix_msg:    dc.b    'You have chosen to go to Pheonix',0


gorgonstory1_msg:  dc.b    'You get on to Gordon and you find aliens that are living on this planet'
                dc.b    $0D,$0A
                dc.b    'They seem to be less advanced than the population from ur home planet'
                dc.b    $0D,$0A
                dc.b    'You are faced with the choice to fight them to try and take over their planet'
                dc.b    $0D,$0A
                dc.b    'Or you can try and make an alliance with them'
                dc.b    $0D,$0A
                dc.b    'Press 1 to fight'
                dc.b    $0D,$0A
                dc.b    'Press 2 to talk'
                dc.b    $0D,$0A
                dc.b    'Enter your choice:',0
gorgonchoice1_msg: dc.b    'You have succesfully destoyed the weak enemy forces and taken over the planet',0
gorgonchoice2_msg: dc.b    'You have tried to form an alliance but the planet residents have atacked '
                dc.b    $0D,$0A
                dc.b    'You in negotations and you loose a crew member',0
gorgonstory2_msg: dc.b 'Since you have taken over the planet the planet goes into disarray'
                dc.b    $0D,$0A
                dc.b  'And you discover that the aliens were essential for the planets existence'
                dc.b    $0D,$0A
                dc.b  'You have a choice to either abandon the dying planet '
                dc.b    $0D,$0A
                dc.b  'Or try to recover by using ur farming skills'
                dc.b    $0D,$0A
                dc.b   'Press 1 to abandon'
                dc.b    $0D,$0A
                dc.b   'Press 2 to try and recover'
                dc.b    $0D,$0A
                dc.b    'Enter your choice:',0                
gorgonstory2choice1_msg: 
                dc.b   'Since you have chosen to abandon the planet'
                dc.b    $0D,$0A
                dc.b   'You end up wandering in space trying to look for a planet'
                dc.b    $0D,$0A
                dc.b   'You find a planet called Lumerya',0
gorgonstory2choice2_msg:
                dc.b   'Since you have chosen to try and save the planet you end up'
                dc.b    $0D,$0A
                dc.b   'Extending the lifespan of the planet but not saving it',0
ending1_msg:
                dc.b   'Since you have failed to save the planet'
                dc.b    $0D,$0A
                dc.b   'Now it is too late and you cannot escape and you'
                dc.b    $0D,$0A
                dc.b    'Die together with the planet'
                dc.b    $0D,$0A
                dc.b    'I am sorry but your jorney ends here',0 


ending2_msg:    dc.b   'You get to know the people of Hydra'
                dc.b    $0D,$0A
                dc.b   'With the help of people from Lumerya'
                dc.b    $0D,$0A
                dc.b   'You end up enjoying ur life on Hydra and decide to stay'
                dc.b    $0D,$0A
                dc.b   'You start a family and lead a happy life'
                dc.b    $0D,$0A
                dc.b   'You also setup a restaurant that starts prospering'
                dc.b    $0D,$0A
                dc.b   'Your journey ends here',0            
                               
ending3_msg:    dc.b   'Since lumerya is way too strong'
                dc.b    $0D,$0A
                dc.b   'They capture you and your crew members'
                dc.b    $0D,$0A
                dc.b   'Then they start using you for experiments'
                dc.b    $0D,$0A
                dc.b   'You get an over powered super power but'
                dc.b    $0D,$0A
                dc.b   'But since the power is too strong you end up going rambo'
                dc.b    $0D,$0A
                dc.b   'And you end up destroying the univers'
                dc.b    $0D,$0A
                dc.b   'Your journey ends here',0
                
ending4_msg:    dc.b   'During negotiation the negotiations break down'
                dc.b    $0D,$0A
                dc.b   'And then a massive fight breaks out'
                dc.b    $0D,$0A
                dc.b   'You end up getting overwhelmed and die'
                dc.b    $0D,$0A
                dc.b   'Your journey ends here',0
                
ending5_msg:    dc.b   'You are succesful in setting up ur hideout'
                dc.b    $0D,$0A
                dc.b   'But secluded from society you start dark thoughts'
                dc.b    $0D,$0A
                dc.b   'And you setup a terrorist organisation'
                dc.b    $0D,$0A
                dc.b   'And you spend the rest of ur life terrorising other planets'
                dc.b    $0D,$0A
                dc.b   'Until eventualy you get nuked by Lumeryra',0               
                
                                  
          
hydrastory1_msg: dc.b   'You get on Hydra and you get zerged instantly'
                dc.b    $0D,$0A
                dc.b    'The planet is advanced but they cant talk properly '             
                dc.b    $0D,$0A
                dc.b    'Any form of negotiation is out of the question'
                dc.b    $0D,$0A
                dc.b    'You are forced to escape from the planet '
                dc.b    $0D,$0A
                dc.b    'Now you are faced with a choice between going back to Gorgon'
                dc.b    $0D,$0A
                dc.b    'Or go to a new planet'
                dc.b    $0D,$0A
                dc.b    'Press 1 to go to Gorgon'
                dc.b    $0D,$0A
                dc.b    'Press 2 to go to a random planet'
                dc.b    $0D,$0A
                dc.b    'Enter your choice:',0
hydrachoice1_msg:
                dc.b    'You have chosen to go to gorgon',0
hydrachoice2_msg:
                dc.b    'You wander around in space after escaping'
                dc.b    $0D,$0A
                dc.b    'You end up a planet called Imhotep',0    
pheonixstory1_msg: dc.b 'You get on to pheonix they instantly offer you money so they can buy you'
                dc.b    $0D,$0A
                dc.b    'You have a choice between fighting them or trying to flee with the money'
                dc.b    $0D,$0A
                dc.b    'Press 1 to fight'
                dc.b    $0D,$0A
                dc.b    'Press 2 to flee with the money'
                dc.b    $0D,$0A
                dc.b    'Enter your choice:',0
pheonixchoice1_msg: 
                dc.b 'You have lost and are forced to retreat 2 crew members die'
                dc.b    $0D,$0A
                dc.b 'You end up on a planet called imhotep',0
pheonixchoice2_msg:
                dc.b 'You are trying to escape with the $2000 dollars that you took'
                dc.b    $0D,$0A
                dc.b 'But the residents of pheonix are trying to catch you'
                dc.b    $0D,$0A
                dc.b 'As you try to get rid of them you end up on a planet called imhotep',0
imhotepstory1_msg:
                dc.b  'In this planet the population is massive but they seem to be friendly'
                dc.b    $0D,$0A
                dc.b  'It seems like you could setup a hideout in this planet'
                dc.b    $0D,$0A
                dc.b  'What will you choose to setup a hideout or try and negotiate for help'   
                dc.b    $0D,$0A      
                dc.b  'Press 1 to setup Hideout'
                dc.b    $0D,$0A
                dc.b  'Press 2 to negotiate'    
                dc.b    $0D,$0A
                dc.b  'Enter your choice:',0
imhotepchoice1_msg:
                dc.b 'You are succesful in setting up ur hideout and you loose the pursuers',0

imhotepchoice2_msg: dc.b 'Your negotiations lead to a proposition by the people'
                dc.b    $0D,$0A
                dc.b 'They are willing to help for $200'
                dc.b    $0D,$0A
                dc.b 'You decide to pay for help'
                dc.b    $0D,$0A
                dc.b 'You gain 3 ally ships with 15 crew members',0
lumeryastory1_msg:
                dc.b 'You end up on a planet called Lumerya the people from this planet'
                dc.b    $0D,$0A     
                dc.b 'Are very enteligent and know alot of languages'
                dc.b    $0D,$0A
                dc.b 'You are faced with a choice between trying to ask for help in'
                dc.b    $0D,$0A
                dc.b 'Translating and help you communicate with Hydra'
                dc.b    $0D,$0A
                dc.b 'Or you can choose to fight them'
                dc.b    $0D,$0A
                dc.b 'Press 1 to ask for help'
                dc.b    $0D,$0A
                dc.b 'Press 2 to fight'
                dc.b    $0D,$0A
                dc.b 'Enter your choice:',0   
lumeryachoice1_msg:
                dc.b 'You are succesful in getting help and go back to Hydra'
                dc.b    $0D,$0A
                dc.b 'But you had to pay them $1000',0
lumeryachoice2_msg:  
                dc.b  'You are unsucessful in trying to take over this planet'
                dc.b    $0D,$0A
                dc.b  'As their weapons are too advanced and you cant escape',0        
             
                
                 
                
gameplay_msg:   dc.b    'Add Gameplay !',0
update_msg:     dc.b    'Update Gameplay !',0
draw_msg:       dc.b    'Draw Screen !',0
hit_msg:        dc.b    'Strike!',0
miss_msg:       dc.b    'Miss!',0
loop_msg:       dc.b    '.',0
replay_msg:     dc.b    'Enter 0 to Quit any other number to replay : ',0
hud_msg:        dc.b    'Score : ',0
incorrect_fuel_msg dc.b 'Input wrong, enter valid number for the amount fuel' , 0
incorrect_ship_msg dc.b 'Input wrong, enter valid number for the amount of ship',0
choice_msg      dc.b    'Choose to play as Shepard or the Reapers'
                dc.b    $0D,$0A
                dc.b    'Press 1 to play as Shepard'
                dc.b    $0D,$0A
                dc.b    'Press 2 to play as The Reapers',0
                dc.b    $0D,$0A
shepard_msg     dc.b    'You have chosen to play as Shepard',0
repear_msg      dc.b    'You have chosen to play as the Reapears',0

health:     ds.w    1
score:      ds.w    1 reserve space for score

    end start



















  



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
