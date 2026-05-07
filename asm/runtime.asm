; Defines jump table from the api.asm
; Defined the entry point at address 2000H

NAME RUNTIME
EXTRN  MAIN
PUBLIC ENTRY

; PL/M API
API_ADDR SET 0100H

SYSFN MACRO FNAME
    PUBLIC FNAME
    FNAME EQU API_ADDR
    API_ADDR SET API_ADDR + 3
ENDM

$INCLUDE (inc/api.asm)

; Entry point
    ORG 2000H ; in RAM

ENTRY:
    CALL MAIN
    RET

END
