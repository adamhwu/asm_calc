        .ORIG x3000
POP     AND R5, R5, #0
        LD  R1, EMPTY
        ADD R2, R6, R1
        BRz Failure
        LDR R0, R6, #0
        ADD R6, R6, #1
        BR  success
        

PUSH    AND R5, R5, #0
        ST  R1, Save1
        ST  R2, Save2
        LD  R1, MAX
        ADD R2, R6, R1
        BRz Failure
        ADD R6, R6, #-1
        STR R0, R6, #0
        BR  success
        
Failure LD  R1, Save1
        LD  R2, Save2
        ADD R5, R5, #1
        RET
        
success LD  R1, Save1
        LD  R2, Save2
        RET
        
EMPTY   .FILL xC000 ; EMPTY <-- -x4000
MAX .FILL xC005 ; MAX <-- -x3FFB
Save1   .BLKW   #1
Save2   .BLKW   #1


        .END