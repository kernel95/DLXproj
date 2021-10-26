addi r1,r0,#1 //a (n)
addi r2,r0,#0 //b (n-2)
addi r3,r0,#0 //c (n-1)
addi r4,r0,#10 //Number of iterations
addi r5,r0,#0 //Address to sw

loop:
add r2,r0,r3 // b<=c
add r3,r0,r1 // c<=a
add r1,r2,r3 // a<=b+c

sw 0(r5), r1
addi r5,r5,#4

subi r4,r4,#1
bnez r4,loop
nop

