addi r1,r0,#5
addi r2,r0,#10

j salta
nop //branch delay slot
addi r3,r0,#8

salta:
addi r3,r0,#16

jal salta2 //r31 <= 0x18
nop //branch delay slot
addi r3,r1,#8

salta2:
addi r3,r3,#16

