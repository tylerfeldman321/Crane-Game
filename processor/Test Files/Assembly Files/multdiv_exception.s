nop             # Values initialized using addi (positive only)
nop             # Author: Oliver Rodas
nop
nop
addi $r1, $r0, 32767    # r1 = 32767
sll $r1, $r1, 16        # r1 = 2147418112
addi $r1, $r1, 65535    # r1 = 2147483647 (Max positive integer)
addi $r2, $r0, 3    # r1 = 32767
nop
nop
mul $r3, $r1, $r2        # r3 = r1 * r2 = 156
nop
nop
div $r4, $r1, $r0
