.text
 
# $r20 - button input register
# $r1 - game timer
# r2 - game active
# r3 - score


waiting:
    get_button_input $r20  # Custom command - Get input from button, load into register. Should be 0 if no input, and not zero if input
    # Might want a button input that ends the program
    bne $r20, $r0, clear_input_reg_and_start_game  # If input from the button, jump to start_game
    j waiting

clear_input_reg_and_start_game:
    add $r20, $r0, $r0  # Reset the button input register to 0
    j start_game
 
start_game:
    addi $r1, $r0, 1000  # Initialize counter
    addi $r2, $r0, 1  # Set game active
    add $r3, $r0, $r0  # Reset score
    communicate_game_active 1  # Custom command: tell Arduino through pmod that the game is active
    gameloop:
        get_load_sensor_data $r4  # Custom command: get input from sensor
        # Divide or subtract result from sensor to get score?
        display_current_score $r3  # Custom command: Display current score
        bne $r1, $r0, gameloop  # If counter is not 0, repeat the loop
        addi $r1, $r1, -1  # Decrement counter
        j gameloop
    endgameloop:
        addi $r2, $r0, 0  # Set game inactive
        communicate_game_active 0

        # For now, just let the game end
        # Might want to go back to waiting
