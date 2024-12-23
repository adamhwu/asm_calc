; program converts Binary value stored in R0 to ASCII value, stored in 4 consecutive memory locations
; usable for any length number that can be represented as twos compliment wtih 16 bits

                    .ORIG   x3000

BinarytoASCII       ST      R1, b_aSave
                    LEA     R1, b_aSave
                    STR     R0, R1, #1
                    STR     R2, R1, #2
                    STR     R7, R0, #3
                    
                    ADD     R1, R0, #0          ; output negative sign if number is negative
                    BRzp    b_aTenThousand
                    LD      R0, ASCIINEG
                    OUT
                    
b_aTenThousand      AND     R0, R0, #0          ; testing ten thousands digit
                    LD      R2, negTenThousand
b_aLoop1            ADD     R1, R1, R2
                    BRn     thousand
                    ADD     R0, R0, #1
                    BR      b_aLoop1
                    
thousand            JSR     disp
                    AND     R0, R0, #0
                    LD      R2, negThousand
b_aLoop2            ADD     R1, R1, R2
                    BRn     hundred
                    ADD     R0, R0, #1
                    BR      b_aLoop2
                    
hundred             JSR     disp
                    AND     R0, R0, #0
                    LD      R2, negHundred
b_aLoop3            ADD     R1, R1, R2
                    BRn     ten
                    ADD     R0, R0, #1
                    BR      b_aLoop3
                    
ten                 JSR     disp
                    AND     R0, R0, #0
                    AND     R2, R2, #0
                    ADD     R2, R2, #-10
b_aLoop4            ADD     R1, R1, R2
                    BRn     one
                    ADD     R0, R0, #1
                    BR      b_aLoop4
                    
one                 JSR     disp
                    AND     R0, R0, #0
                    ADD     R0, R1, #0
                    JSR     disp
                    
                    BR      end
                    
disp                NOT     R2, R2              ; revert last addition, which resulted in a negative number
                    ADD     R2, R2, #1
                    ADD     R1, R1, R2
                    LD      R2, b_aASCIIOFFSET
                    ADD     R0, R0, #0
                    BRz     b_aDispDone
                    ADD     R0, R0, R2         ; displays current digit
                    OUT     
b_aDispDone         
                    
                    
end                 LEA     R1, b_aSave
                    LDR     R1, R0, #1
                    LDR     R2, R0, #2
                    LDR     R7, R0, #3
                    LDR     R0, R0, #0
                    RET
    
ASCIINEG            .FILL   x-002D
b_aASCIIOFFSET      .FILL   #48
negTenThousand      .FILL   #-10000
negThousand         .FILL   #-1000
negHundred          .FILL   #-100

                    
b_aSave             .BLKW   #4

                    .END
                    
