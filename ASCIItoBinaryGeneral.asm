; This file converts a 3 digit ASCII stored in ASCIIBUFF to decimal and stores it to R0
; R0: return value
; R1: # of digits
; R2: ASCIIBUFF (address of first element in ASCII number, which is pos/neg sign)

                    .ORIG   x3000
ASCIItoBinary       ST      R0, a_bSave         ; storing registers
                    LEA     R0, a_bSave
                    STR     R1, R0, #1
                    STR     R2, R0, #2
                    STR     R3, R0, #3
                    STR     R4, R0, #4
                    STR     R7, R0, #5
                    
                    AND     R0, R0, #0
                    AND     R1, R1, #0
                    LD      R2, a_bASCIIBUFF
a_bInit1            ADD     R2, R2, #1          ; count how many digits there are, store in R1
                    LDR     R3, R2, #0
                    BRz     a_bSkip1
                    ADD     R1, R1, #1
                    BR      a_bInit1
                    
a_bSkip1            LD      R2, a_bASCIIBUFF
a_bLoop1            ST      R1, a_bSTR1         ; store how many digits are left
                    ADD     R2, R2, #1          ; on first iteration, skips pos/neg sign
                    LDR     R3, R2, #0 
                    LD      R4, a_bASCIIOFFSET
                    ADD     R3, R3, R4          ; convert digit from ASCII to decimal
                    
a_bLoop1sub         ADD     R1, R1, #-1         ; loop to multiply digit to correct tens place
                    BRz     a_bSkip2            ; using 10x = x*2^3 + x*2
                    ADD     R4, R3, #0
                    ADD     R3, R3, R3          ; x*2^3 (shifting right three times)
                    ADD     R3, R3, R3
                    ADD     R3, R3, R3
                    ADD     R4, R4, R4          ; x*2
                    ADD     R3, R3, R4          ; adding two values to equal 10x
                    BR      a_bLoop1sub 
                    
a_bSkip2            ADD     R0, R0, R3          ; updating return value
                    LD      R1, a_bSTR1
                    ADD     R1, R1, #-1         ; move on to next digit
                    BRp     a_bLoop1

; add negative code
                    


                    
                    LEA     R0, a_bSave
                    LDR     R1, R0, #1
                    LDR     R2, R0, #2
                    LDR     R3, R0, #3
                    LDR     R4, R0, #4
                    LDR     R7, R0, #5
                    LDR     R0, R0, #0
                    
                    TRAP    x25
                    
a_bSTR1             .BLKW   #1
a_bASCIIOFFSET      .FILL   #-48
a_bASCIIBUFF        .FILL   x3100       ; fill later with ASCIIBUFF

a_bSave             .BLKW   #6
                    
                    .END