.text


addi $r10, $r0, 10

loop:
    addi $r10, $r10, -1
    nop
    increment_score $r3 $r3 1
    nop
    blt $r10, $r0, endloop
    j loop
endloop:
    nop