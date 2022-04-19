.text


addi $r10, $r0, 1000

loop:
    addi $r10, $r10, -1
    nop
    addi $r3 $r3 1
    nop
    blt $r10, $r0, endloop
    j loop
endloop:
    nop