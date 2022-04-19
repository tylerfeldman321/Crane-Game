.text

# $r10 - game timer
# $r11 - subdivided timer

# r1 - value of 1
# r2 - game active
# r3 - score
# r4 - high score


addi $r1, $r0, 1  # r1 = 1
addi $r10, $r0, 20  # Initialize timer. r10 = 20


# addi $r11, $r0, 10000  # Subdivided timer. r11 = 10000
# addi $r2, $r0, 0  # Set game active. r2 = 0
# add $r3, $r0, $r0  # Reset score

# addi $r10, $r0, 19

# gameloop:
#     # increment_score_if_needed $r3

#     addi $r11, $r11, -1  # Decrement subdivided timer
#     blt $r11, $r1, decrement_timer  # If r11 < 1, then decrement timer
#     done_decrementing:

#     blt $r10, $r1, endgameloop  # If r10 < 1, end game

#     # If reset, then go back to waiting

#     j gameloop

# decrement_timer:
#     addi $r10, $r10, -1
#     j done_decrementing

# endgameloop:
#     addi $r2, $r0, 0  # Set game inactive

#     # TODO: set high score?
#     # add $r4, $r3, $r0  # Set high score. r4 = r3. Might want a sw here

#     # Might want to go back to waiting
#     # Write high score to memory, or to register

