
  lui $r0 0x82		      #r0 = 1000 0010 0000 0000
  ori $r0 $r0 0x9f    #r0 = 1000 0010 1001 1111
  andi $r1 $r0 0x7    #r1 = 0000 0000 0000 0111 
  andi $r2 $r0 0x38   #r2 = 0000 0000 0001 1000   0x38 = 0000 0000 0011 1000
  lui $r3 0
  addi $r3 $r3 1	     #store 1 into r3
  sllv $r2 $r2 $r3	   #r2 = 0000 0000 0011 0000
  or $r1 $r1 $r2	     #r1 = 0000 0000 0011 0111
  addi $r3 $r3 -1	    #clear r3
  lui $r3 0x1
  ori $r2 $r3 0xc0    #r2 = 0000 0001 1100 0000   r3 = 0000 0001 1100 0000
  and $r2 $r0 $r2	    #r2 = 0000 0000 1000 0000
  lui $r3 0
  addi $r3 $r3 2      #store 2 into  r3
		sllv $r2 $r2 $r3	   #r2 = 0000 0010 0000 0000
		or $r1 $r1 $r2	     #r1 = 0000 0010 0011 0111
  disp $r1 0
End:
  j End		#halt