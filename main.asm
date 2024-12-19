; main file for asm_calc, takes user input and stores to stack
; postfix evaluation, plan to change later
            
            .ORIG x3000
            
            LEA     R6, stackBase

newInp      LEA     R0, inpMsg
            PUTS
            GETC
            OUT
            
testX       LD      R1, NegX        ; check for X
            ADD     R1, R1, R0
            BRnp    testC
            HALT
            
testC       LD      R1, NegC        ; check for C
            ADD     R1, R1, R0
            BRnp    testAdd
            JSR     OpClear
            BR      newInp
            
testAdd     LD      R1, NegPlus
            ADD     R1, R1, R0
            BRnp    testMinus
            JSR     addOp
            BR      newInp
            
testMinus   LD      R1, NegMinus
            ADD     R1, R1, R0
            BRnp    enterNum
            JSR     negOp
            BR      newInp
            
;testD       LD      R1, NegD
;            ADD     R1, R1, R0
;            BRnp    EnterNumber
;            JSR     OpDisplay
;            BR      newInp
            
enterNum    JSR     ASCIIPush
            BR      newInp

inpMsg      .STRINGZ "enter your command: "

NegX        .FILL   xFFA8
NegC        .FILL   xFFBD
NegPlus     .FILL   xFFD5
NegMinus    .FILL   xFFD3
NegMult     .FILL   xFFD6
NegD        .FILL   xFFBC

; Globals
stackMax    .BLKW   #9
stackBase   .BLKW   #1
ASCIIBUFF   .BLKW   #4
            
            .FILL   x0000    ; ASCIIBUFF sentinel
ASCIIPTR    .FILL   ASCIIBUFF
            
            .END






