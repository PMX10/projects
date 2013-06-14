
      lui $r0 0          # store $sp into r0
      andi $r3 $r0 0     # initial r3 to store the result
      lw $r1 0($r0)      # load value1 to r1
      lw $r2 1($r0)  				# load value2 to r2
loop:
      beq $r2 $r0 store  #if r2 == 0, jump to store
      add $r3 $r3 $r1    #result = result + r1  
					 addi $r2 $r2 -1    #decrement r2
      j loop             #loop
store:
     sw $r3 2($r0)       #store result to MEM[2] 
End:
     beq $r2 $r0 End               #halt