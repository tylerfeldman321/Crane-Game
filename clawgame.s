.text

# $r10 - game timer
# $r11 - subdivided timer

# r1 - value of 1
# r2 - game active
# r3 - score
# r4 - high score

waiting:
    check_start_button 1 # Custom command - Get input from button, load into register. Should be 0 if no input, and not zero if input
    bne $r20, $r0, start_game  # If input from the button, jump to start_game
    j waiting
 
start_game:
    addi $r1, $r0, 1  # r1 = 1
    addi $r10, $r0, 20  # Initialize timer. r10 = 20
    addi $r11, $r0, 10000000  # Subdivided timer. r11 = 10000000
    addi $r2, $r0, 0  # Set game active. r2 = 0
    add $r3, $r0, $r0  # Reset score

    gameloop:
        increment_score_if_needed $r3

        addi $r11, $r11, -1  # Decrement subdivided timer
        blt $r11, $r1, decrement_timer  # If r11 < 1, then decrement timer
        done_decrementing:

        blt $r10, $r1, endgameloop  # If r10 < 1, end game

        # If reset, then go back to waiting

        j gameloop

    decrement_timer:
        addi $r10, $r10, -1
        j done_decrementing

    endgameloop:
        addi $r2, $r0, 0  # Set game inactive

        # TODO: set high score?
        # add $r4, $r3, $r0  # Set high score. r4 = r3. Might want a sw here

        # Might want to go back to waiting
        # Write high score to memory, or to register
        j waiting

