; addOp is a subroutine that pops top two values from stack, adds, them then pushes the result


            .ORIG   x3000

addOp       ST      R0, aOpSave
            LEA     R0, aOpSave
            STR     R1, R0, #1
            STR     R7, R0, #2

            JSR     POP
            ADD     R5, R5, #0
            BRnp    aOpFail
            ADD     R1, R0, #0
            
            JSR     POP
            ADD     R5, R5, #0
            BRnp    aOpFail
            
            ADD     R0, R0, R1
            JSR     PUSH
            ADD     R5, R5, #0
            BRnp    aOpFail
            
            
aOpFail     AND     R5, R5, #0
            ADD     R5, R5, #1
            
            LEA     R0, aOpSave
            LDR     R1, R0, #1
            LDR     R7, R0, #2
            LDR     R0, R0, #0
            RET 
            
aOpSave     .BLKW #3
            .EXTERNAL   POP
            .EXTERNAL   PUSH
            .END
            
            
            