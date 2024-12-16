; program converts Binary value stored in R0 to ASCII value, stored in 4 consecutive memory locations
; usable for any length number that can be represented as twos compliment wtih 16 bits

                    .ORIG   x3000


BinarytoASCII       ST      R0, b_aSave
                    LEA     R0, b_aSave
                    STR     R1, R0, #1
                    STR     R2, R0, #2
                    STR     R3, R0, #3
                    STR     R4, R0, #4
                    STR     R5, R0, #5
                    STR     R6, R0, #6
                    STR     R7, R0, #7

                    
                    
                    AND     R2, R2, #0          ; clear R2
                    LD      R3, ASCIIBUFF       ; load R3 with address of stack to STI later
                    LD      R4, ASCIIOFFSET     ; load R4 wtih 48 for ASCII to Binary conversion
                    
                    ADD     R0, R0, #0          ; loading either ASCII positive or negative sign
                    BRn     loadNeg             ; into R2 to save into top of ASCIIBUFF
                    LD      R2, ASCIIPOS
                    BR      startLoop
loadNeg             LD      R2, ASCIINEG
                    NOT     R0, R0
                    ADD     R0, R0, #1

                    
startLoop           STR     R2, R3, #3          ; store positive or negative sign
                    AND     R2, R2, #0
                    LD      R1, negHundred
b_aHundredLoop      ADD     R0, R0, R1
                    BRn     endHundred
                    ADD     R2, R2, #1
                    BR      b_aHundredLoop
                    
endHundred          ADD     R2, R2, R4
                    STR     R2, R3, #2
                    LD      R1, hundred         ; restore value because of one-too-many subtractions
                    ADD     R0, R0, R1
                    AND     R2, R2, #0
                    
b_aTenLoop          ADD     R0, R0, #-10
                    BRn     endTen
                    ADD     R2, R2, #1
                    BR      b_aTenLoop
                    
endTen              ADD     R2, R2, R4
                    STR     R2, R3, #1
                    
                    ADD     R0, R0, #10         ; restore value because of one-too-many subtractions becuase 10+48 = 58
                    ADD     R0, R0, R4
                    STR     R0, R3, #0          ; storing ones place
                    
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
                    
negHundred          .FILL   #-100
hundred             .FILL   #100
ASCIIOFFSET         .FILL   #48
ASCIIBUFF           .FILL   x3100
ASCIIPOS            .FILL   x002B
ASCIINEG            .FILL   x002D
                    
b_aSave             .BLKW   #8
                    
                    .END