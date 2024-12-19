                .ORIG   x3000

ASCIIPush       ST      R0, a_pSave
                LEA     R0, a_pSave
                STR     R1, R0, #1
                STR     R2, R0, #2
                STR     R6, R0, #3
                
                ADD     R1, R0, x-0A        ; test for LF
                BRz     a_pLF
                LD      R6, ASCIIPTR        ; top ASCII value 
                STR     R0, R6, #1          ; store input (currently in R0) at next ASCIIBUFF spot
                ADD     R6, R6, #1          ; increment pointer
                ST      R6, ASCIIPTR        ; store in stack storage for later access
                BR      a_pExit

                
a_pLF           JSR     ASCIItoBinary       ; convert ASCIIBuffer to decimal
                JSR     Push                ; push to stack
                BR      a_pExit
                
a_pExit         LEA     R0, a_pSave         ; revert Registers
                LDR     R1, R0, #1
                LDR     R2, R0, #2
                LDR     R6, R0, #3
                LDR     R0, R0, #0
                
                RET
                

a_pSave         .BLKW #8

                .END