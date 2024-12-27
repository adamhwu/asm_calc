; main program for asm_calc, takes user input and stores to stack
; postfix evaluation, plan to expand to use prefix evaluation later
            
            .ORIG x3000
            
            LEA     R6, stackBase
            ADD     R6, R6, #1      ; stackBase + 1 is empty stack

newPrompt   LEA     R0, inpMsg
            PUTS
newInp      GETC
            OUT
            
testAdd     LD      R1, NegPlus
            ADD     R1, R1, R0
            BRnp    testMinus
            JSR     addOp
            JSR     testValid
            LD      R0, LF
            OUT
            JSR     BinarytoASCII
            BR      newInp
            
testMinus   LD      R1, NegMinus
            ADD     R1, R1, R0
            BRnp    enterNum
            JSR     negOp
            JSR     testValid
            LD      R0, LF
            OUT
            JSR     BinarytoASCII
            BR      newInp
            
;testD       LD      R1, NegD
;            ADD     R1, R1, R0
;            BRnp    EnterNumber
;            JSR     OpDisplay
;            BR      newInp
            
enterNum    JSR     ASCIIPush
            BR      newInp
            
testValid   ADD     R5, R5, #0
            BRp     badOutput
            RET
badOutput   LD      R0, LF
            OUT
            LEA     R0, badMsg
            PUTS
            LD      R0, LF
            OUT
            BR      newInp
            

inpMsg      .STRINGZ "enter your commands: "
badMsg      .STRINGZ "invalid command"

NegX        .FILL   xFFA8
NegC        .FILL   xFFBD
NegPlus     .FILL   xFFD5
NegMinus    .FILL   xFFD3
NegMult     .FILL   xFFD6
NegD        .FILL   xFFBC
LF          .FILL   x0A

; Globals
stackMax    .BLKW   #9
stackBase   .BLKW   #1
ASCIIBUFF   .BLKW   #9
            
            .FILL   x0000    ; ASCIIBUFF sentinel
ASCIIPTR    .FILL   ASCIIBUFF
            
; This subroutine converts a 3 digit ASCII stored in ASCIIBUFF to decimal and stores it to R0
; R0: return value
; R1: # of digits
; R2: ASCIIBUFF (address of first element in ASCII number, which is pos/neg sign)

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
                    
                    JSR     PUSH
                    LD      R2, a_bASCIIBUFF    ; clear ASCIIBuffer
                    AND     R1, R1, #0
                    ADD     R3, R1, #9
a_bClear            STR     R1, R2, #0
                    ADD     R2, R2, #1
                    ADD     R3, R3, #-1
                    BRp     a_bClear
                    
                    LEA     R0, a_bSave
                    LDR     R1, R0, #1
                    LDR     R2, R0, #2
                    LDR     R3, R0, #3
                    LDR     R4, R0, #4
                    LDR     R7, R0, #5
                    LDR     R0, R0, #0
                    RET

a_bSTR1             .BLKW   #1
a_bASCIIOFFSET      .FILL   #-48
a_bASCIIBUFF        .FILL   ASCIIBUFF       ; fill later with ASCIIBUFF

a_bSave             .BLKW   #6


BinarytoASCII       ST      R1, b_aSave     ; displays number at top of stack
                    LEA     R1, b_aSave
                    STR     R0, R1, #1
                    STR     R2, R1, #2
                    STR     R7, R1, #3
                    
                    LDR     R0, R6, #0
                    
                    ADD     R1, R0, #0          ; output negative sign if number is negative
                    BRzp    b_aTenThousand
                    LD      R0, ASCIINEG
                    OUT
                    NOT     R1, R1
                    ADD     R1, R1, #1
                    
b_aTenThousand      AND     R0, R0, #0          ; testing ten thousands digit
                    LD      R2, negTenThousand
b_aLoop1            ADD     R1, R1, R2
                    BRn     thousand
                    ADD     R0, R0, #1
                    BR      b_aLoop1
                    
thousand            JSR     b_aDisp
                    AND     R0, R0, #0
                    LD      R2, negThousand
b_aLoop2            ADD     R1, R1, R2
                    BRn     hundred
                    ADD     R0, R0, #1
                    BR      b_aLoop2
                    
hundred             JSR     b_aDisp
                    AND     R0, R0, #0
                    LD      R2, negHundred
b_aLoop3            ADD     R1, R1, R2
                    BRn     ten
                    ADD     R0, R0, #1
                    BR      b_aLoop3
                    
ten                 JSR     b_aDisp
                    AND     R0, R0, #0
                    AND     R2, R2, #0
                    ADD     R2, R2, #-10
b_aLoop4            ADD     R1, R1, R2
                    BRn     one
                    ADD     R0, R0, #1
                    BR      b_aLoop4
                    
one                 JSR     b_aDisp
                    AND     R0, R0, #0
                    ADD     R0, R1, #0
                    JSR     b_aDisp
                    
                    BR      end
                    
b_aDisp             NOT     R2, R2              ; revert last addition, which resulted in a negative number
                    ADD     R2, R2, #1
                    ADD     R1, R1, R2
                    LD      R2, isLeadingZero
                    BRz     b_aDispSkip
                    ADD     R0, R0, #0
                    BRz     b_aDispDone
b_aDispSkip         AND     R2, R2, #0
                    ST      R2, isLeadingZero
                    LD      R2, b_aASCIIOFFSET
                    ADD     R0, R0, R2         ; displays current digit
                    OUT     
b_aDispDone         RET
                    
                    
end                 LEA     R1, b_aSave
                    LDR     R0, R1, #1
                    LDR     R2, R1, #2
                    LDR     R7, R1, #3
                    LDR     R1, R1, #0
                    RET
    
ASCIINEG            .FILL   x2D
b_aASCIIOFFSET      .FILL   #48
isLeadingZero       .FILL   #1
negTenThousand      .FILL   #-10000
negThousand         .FILL   #-1000
negHundred          .FILL   #-100

                    
b_aSave             .BLKW   #4

; addOp is a subroutine that pops top two values from stack, adds, them then pushes the result

addOp               ST      R0, aOpSave
                    LEA     R0, aOpSave
                    STR     R1, R0, #1
                    STR     R7, R0, #2
                    STR     R6, R0, #3
        
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
                    BRz     aOpSuccess
            
            
aOpFail             LEA     R0, aOpSave
                    LDR     R6, R0, #3
                    AND     R5, R5, #0
                    ADD     R5, R5, #1
                    
aOpSuccess          LEA     R0, aOpSave
                    LDR     R1, R0, #1
                    LDR     R7, R0, #2
                    LDR     R0, R0, #0
                    RET 
            
aOpSave             .BLKW #4

negOp               ST      R0, nOpSave
                    LEA     R0, nOpSave
                    STR     R7, R0, #1
                            
                    JSR     POP
                    ADD     R5, R5, #0
                    BRnp    nOpFail
                    
                    NOT     R0, R0
                    ADD     R0, R0, #1
                    JSR     PUSH
                    BR      nOpSuccess
                    
nOpFail             AND     R5, R5, #0
                    ADD     R5, R5, #1
        
nOpSuccess          LEA     R0, nOpSave
                    LDR     R7, R0, #1
                    LDR     R0, R0, #0
                    RET
                
nOpSave             .BLKW #2

; pop and push subroutines

POP                 AND     R5, R5, #0
                    ST      R1, Save1
                    ST      R2, Save2
                    LD      R1, EMPTY  
                    ADD     R1, R1, #1      ; convert R1 to neg of base + 1
                    NOT     R1, R1
                    ADD     R1, R1, #1
                    ADD     R2, R6, R1
                    BRz     Failure
                    LDR     R0, R6, #0
                    ADD     R6, R6, #1
                    BR      success
        

PUSH                AND     R5, R5, #0
                    ST      R1, Save1
                    ST      R2, Save2
                    LD      R1, MAX
                    NOT     R1, R1
                    ADD     R1, R1, #1
                    ADD     R2, R6, R1
                    BRz     Failure
                    ADD     R6, R6, #-1
                    STR     R0, R6, #0
                    BR      success
        
Failure             LD      R1, Save1
                    LD      R2, Save2
                    ADD     R5, R5, #1
                    RET
        
success             LD      R1, Save1
                    LD      R2, Save2
                    RET
        
EMPTY               .FILL stackBase
MAX                 .FILL stackMax ; Location of maximum of Stack
Save1               .BLKW   #1
Save2               .BLKW   #1

ASCIIPush       ST      R0, a_pSave
                LEA     R0, a_pSave
                STR     R1, R0, #1
                STR     R2, R0, #2
                STR     R6, R0, #3
                STR     R7, R0, #4
                
                LD      R0, a_pSave
                ADD     R1, R0, x-0A        ; test for LF
                BRz     a_pLF
                LD      R6, ASCIIPTR        ; top ASCII value 
                STR     R0, R6, #1          ; store input (currently in R0) at next ASCIIBUFF spot
                ADD     R6, R6, #1          ; increment pointer
                ST      R6, ASCIIPTR        ; store in stack storage for later access
                BR      a_pExit

                
a_pLF           JSR     ASCIItoBinary       ; convert ASCIIBuffer to decimal and push to stack (push included in ASCIItoBinary)
                LEA     R6, ASCIIBUFF
                ST      R6, ASCIIPTR
                LEA     R0, a_pSave
                LDR     R6, R0, #3
                ADD     R6, R6, #-1
                STR     R6, R0, #3

a_pExit         LEA     R0, a_pSave         ; revert Registers
                LDR     R1, R0, #1
                LDR     R2, R0, #2
                LDR     R6, R0, #3
                LDR     R7, R0, #4
                LDR     R0, R0, #0
                
                RET
                

a_pSave         .BLKW #5

        .END
                    