addi r1,r0,#5
addi r2,r0,#2
addi r3,r0,#-10

sll r4,r1,r2 // r3<= 5 << 2 = 20
srl r5,r1,r2 // r4<= 5 >> 2 = 1
sra r6,r3,r2 // r5<= -10 >> 2 = -3

slli r4,r1,#3 // r3<= 5 << 3 = 40
srli r5,r1,#1 // r4<= 5 >> 1 = 2
srai r6,r3,#3 // r5<= -5 >> 3 = -2

