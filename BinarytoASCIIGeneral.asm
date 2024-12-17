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

                    
                    
                    ST      R1, STR1
                    LD      R2, b_aASCIIBUFF
                    LDR     R3, R2, #1
                    LD      R4, ASCI
                    

                    
                    ;LEA     R0, b_aSave
                    ;LDR     R1, R0, #1
                    ;LDR     R2, R0, #2
                    ;LDR     R3, R0, #3
                    ;LDR     R4, R0, #4
                    ;LDR     R5, R0, #5
                    ;LDR     R6, R0, #6
                    ;LDR     R7, R0, #7
                    ;LDR     R0, R0, #0
                    
                    TRAP    x25
                    
b_aSTR1             .BLKW
negHundred          .FILL   #-100
hundred             .FILL   #100
b_aASCIIOFFSET      .FILL   #-48
b_aASCIIBUFF        .FILL   x3100       ; fill later with ASCIIBUFF
ASCIIPOS            .FILL   x002B
ASCIINEG            .FILL   x-002D
                    
b_aSave             .BLKW   #8
                    
                    .END