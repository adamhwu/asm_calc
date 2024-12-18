                .ORIG x3000

negOp           ST      R0, nOpSave
                LEA     R0, nOpSave
                STR     R7, R0, #7
                        
                JSR     POP
                ADD     R5, R5, #0
                BRnp    nOpFail
                
                NOT     R0, R0
                ADD     R0, R0, #1
                JSR     PUSH
                
nOpFail         AND     R5, R5, #0
                ADD     R5, R5, #1
    
                LEA     R0, nOpSave
                LDR     R7, R0, #7
                LDR     R0, R0, #0
                RET
                
nOpSave         .BLKW #2
                .END
                    
