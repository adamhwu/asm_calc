; This file converts a 3 digit ASCII stored in memory into a single binary value
; R0: return value
; R1: # of digits
; R2: ASCIIBUFF (address of first element in ASCII number)

                    .ORIG   x3000
ASCIItoBinary       ST      R0, a_bSave
                    LEA     R0, a_bSave
                    STR     R1, R0, #1
                    STR     R2, R0, #2
                    STR     R3, R0, #3
                    STR     R4, R0, #4
                    STR     R5, R0, #5
                    STR     R6, R0, #6
                    STR     R7, R0, #7
                    
                    AND     R0, R0, #0
                    LD      R2, a_bASCIIBUFF
                    
a_bLoop1            ST      R1, a_bSTR1
                    ADD     R2, R2, #1
                    LDR     R3, R2, #0
                    LD      R4, a_bASCIIOFFSET
                    ADD     R3, R3, R4
                    
a_bLoop1sub         ADD     R1, R1, #-1
                    BRz     a_bSkip1
                    ADD     R4, R3, #0
                    ADD     R3, R3, R3
                    ADD     R3, R3, R3
                    ADD     R3, R3, R3
                    ADD     R4, R4, R4
                    ADD     R3, R3, R4
                    BR      a_bLoop1sub
                    
a_bSkip1            ADD     R0, R0, R3
                    LD      R1, a_bSTR1
                    ADD     R1, R1, #-1
                    BRp     a_bLoop1
                    


                    
                    LEA     R0, b_aSave
                    LDR     R1, R0, #1
                    LDR     R2, R0, #2
                    LDR     R3, R0, #3
                    LDR     R4, R0, #4
                    LDR     R5, R0, #5
                    LDR     R6, R0, #6
                    LDR     R7, R0, #7
                    LDR     R0, R0, #0
                    
                    TRAP    x25
                    
a_bSTR1             .BLKW   #1
a_bASCIIOFFSET      .FILL   #-48
a_bASCIIBUFF        .FILL   x3100       ; fill later with ASCIIBUFF

a_bSave             .BLKW   #8
                    
                    .END