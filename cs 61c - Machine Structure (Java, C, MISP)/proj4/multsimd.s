
      lui $r3 0               # use $r3 as 0 referrence
      lw $r1 1($r3)           # load B to r1
      lw $r0 0($r3)           # load A to r0
						addi $r2, $r3, 8
						sllv $r0, $r0, $r2      # shifts r0 8 bits
						or $r0, $r0, $r1								# r0 = AAAA AAAA BBBB BBBB
      and $r2, $r2, $r3 						# clear out r2 and use r2 to store the result
      lw $r1, 2($r3)
mult:
      beq $r1 $r3 store       # if r2 == 0, jump to store
      addi $r1 $r1 -1         # decrement r1
      addp8 $r2 $r2 $r0       # result = result + r0
      j mult                  # loop
store:
					andi $r0 $r2 0xff        # get the lower 8 bit of the result and store it into r0
     sw $r0 4($r3)            # store into MEM[4]
     addi $r1 $r3 8
     srlv $r0, $r2, $r1
     sw $r0 3($r3)            # store into MEM[3]
End:
     j End           									#halt