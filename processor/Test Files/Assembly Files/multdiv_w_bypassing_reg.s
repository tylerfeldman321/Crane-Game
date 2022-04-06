nop             # Values initialized using addi (positive only)
nop             # Author: Oliver Rodas
nop
nop
nop             # Bypassing to and from Multdiv
addi $r1, $r0, 12        # r1 = 12
nop            # Avoid RAW hazard to test bypassing 1 value
addi $r2, $r0, 13        # r2 = 13
mul $r3, $r1, $r2        # r3 = r1 * r2 = 156    (X->D)
sub $r4, $r3, $r1        # r4 = r3 - r1 = 144    (X->D)
addi $r5, $r0, 4        # r5 = 4
div $r6, $r1, $r5        # r6 = r1 / r5 = 3        (X->D)
addi $r7, $r0, 8        # r7 = 8
addi $r8, $r0, 3        # r8 = 3
mul $r9, $r8, $r7        # r9 = r8 * r7 = 24        (X->D and M->D)
div $r10, $r9, $r1        # r10 = r9 / r1 = 2        (X->D)
div $r11, $r9, $r10        # r11 = r9 / r10 = 12    (X->D and M->D)



# num cycles:200



# ==================== Results ====================
# Reg:  1 Expected:          12 Actual:           0

# Reg:  2 Expected:          13 Actual:           0

# Reg:  3 Expected:         156 Actual:           0

# Reg:  4 Expected:         144 Actual:           0

# Reg:  5 Expected:           4 Actual:           0

# Reg:  6 Expected:           3 Actual:           0

# Reg:  7 Expected:           8 Actual:           0

# Reg:  8 Expected:           3 Actual:           0

# Reg:  9 Expected:          24 Actual:           0

# Reg: 10 Expected:           2 Actual:           0

# Reg: 11 Expected:          12 Actual:           0