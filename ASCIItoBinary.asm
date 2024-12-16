; This file converts a 3 digit ASCII stored in memory into a single binary value
; R0 = storing the sum
; R1 = address of first ASCII number
; R2 = value of current ASCII number

                .ORIG   x3000
            
ASCIItoBinary   ST      R1, a_bSave1           ; stores registers
                ST      R2, a_bSave2           ; to be restored after program execution

                LD      R1, a_bASCII_BUFF       ; address of ones place
                
                LDR     R2, R1, #0              ; ones addition
                AND     R0, R2, x000F           ; converting to binary

                LDR     R2, R1, #1              ; address of tens place
                AND     R2, R2, x000F
tensLoop        ADD     R0, R0, #10             ; add 10 to R0 
                ADD     R2, R2, #-1             ; R2 times
                BRp     tensLoop
                
                LDR     R2, R1, #2              ; address of hundreds place
                AND     R2, R2, x000F
                LD      R1, hundred
hundredsLoop    ADD     R0, R0, R1              ; add 100 to R0
                ADD     R2, R2, #-1             ; R2 times
                BRp     hundredsLoop
                
a_bDone         LD      R1, a_bSave1           ; restore R1 and R2
                LD      R2, a_bSave2
                TRAP    x25

a_bASCII_BUFF       .FILL   x3100
hundred             .FILL   #100

a_bSave1           .BLKW   #1
a_bSave2           .BLKW   #1
    
                    .END