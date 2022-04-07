nop 			# simple bex and setx test case
nop 
nop 
nop
nop
setx 0			# r30 = 0
nop			# Avoid setx RAW hazard
nop			# Avoid setx RAW hazard
bex 20
nop			# nop in case of flush
nop			# nop in case of flush
nop			# Spacer
addi $r10, $r10, 1	# r10 += 1 (Correct)
setx 10			# r30 = 10
nop			# Avoid setx RAW hazard
nop			# Avoid setx RAW hazard
nop
setx 20
nop			# flushed instruction
nop			# flushed instruction
addi $r20, $r20, 1	# r20 += 1
nop
# Final: $r10 should be 2, $r20 should be 0