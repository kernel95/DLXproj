addi r1,r0,#5
addi r2,r0,#255
addi r3,r0,#16

sw 0(r0), r1
sw 0(r3), r2  

lw r4, 0(r3) //r4<=255
