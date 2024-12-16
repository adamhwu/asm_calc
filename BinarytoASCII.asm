; program converts Binary value stored in R0 to ASCII value, stored in 4 consecutive memory locations

                    .ORIG   x3000


BinarytoASCII       ST      R0, b_aSave0
                    ST      R1, b_aSave1       ; stores registers
                    ST      R2, b_aSave2       ; to be restored after program execution
                    ST      R3, b_aSave3
                    ST      R4, b_aSave4
                    
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
                    
                    LD      R0, b_aSave0
                    LD      R1, b_aSave1       ; restore registers
                    LD      R2, b_aSave2       
                    LD      R3, b_aSave3
                    LD      R4, b_aSave4
                    
                    TRAP    x25
                    
negHundred          .FILL   #-100
hundred             .FILL   #100
ASCIIOFFSET         .FILL   #48
ASCIIBUFF           .FILL   x3100
ASCIIPOS            .FILL   x002B
ASCIINEG            .FILL   x002D
                    
b_aSave0            .BLKW   #1
b_aSave1            .BLKW   #1                  ; stores registers
b_aSave2            .BLKW   #1                  ; to be restored after program execution
b_aSave3            .BLKW   #1
b_aSave4            .BLKW   #1
                    
                    .END