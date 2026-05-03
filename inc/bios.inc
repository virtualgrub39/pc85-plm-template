/* declarations for assembly procedures implemented in BIOS */

/* Writes out CHAR into UART connection. */
CONOUT: PROCEDURE(CHAR) EXTERNAL;
    DECLARE CHAR BYTE;
END CONOUT;

/* Reads a single character from UART connection. Blocking. */
CONIN: PROCEDURE BYTE EXTERNAL;
END CONIN;

/* Returns the status of UART RX buffer. Returns 0 if it's empty, and 0xFF otherwise. */
CONSTAT: PROCEDURE BYTE EXTERNAL;
END CONSTAT;

/* Soft-resets system. Returns to serial monitor. */
EXIT: PROCEDURE EXTERNAL;
END EXIT;

/* Does nothing for MS miliseconds. */
DELAY: PROCEDURE(MS) EXTERNAL;
    DECLARE MS BYTE;
END DELAY;
