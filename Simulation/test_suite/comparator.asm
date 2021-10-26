addi r1,r0,#5
addi r2,r0,#5
addi r3,r0,#200

seq r4,r1,r2  //Set
sne r5,r2,r3 //Set
sge r6,r0,r3  //noSet
sgt r7,r1,r2  //noSet
sle r8,r1,r3  //Set
slt r9,r1,r3  //Set

seqi r4,r1,#2 //noSet
snei r5,r1,#5 //noSet
sgei r6,r1,#10 //noSet
sgti r7,r3,#250 //noSet
slei r8,r1,#1 //noSet
slti r9,r2,#1 //noSet

