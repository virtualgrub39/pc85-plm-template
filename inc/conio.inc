/* console input/output module declarations 
 * this module expands on CONIN and CONOUT procedures for more convenient console IO
 */

PRINT: PROCEDURE(PTR) EXTERNAL;
    DECLARE PTR ADDRESS;
END PRINT;

PRINT_CRLF: PROCEDURE EXTERNAL;
END PRINT_CRLF;

PRINTLN: PROCEDURE(PTR) EXTERNAL;
    DECLARE PTR ADDRESS;
END PRINTLN;

PRINT_DEC: PROCEDURE(NUM) EXTERNAL;
    DECLARE NUM WORD;
END PRINT_DEC;

/* outputs single hex digit */
PRINT_NIBBLE: PROCEDURE(N) EXTERNAL;
    DECLARE N BYTE;
END PRINT_NIBBLE;

/* outputs single 8-bit hex number */
PRINT_HEX8: PROCEDURE(NUM) EXTERNAL;
    DECLARE NUM BYTE;
END PRINT_HEX8;

/* outputs single 16-bit hex number */
PRINT_HEX16: PROCEDURE(NUM) EXTERNAL;
    DECLARE NUM WORD;
END PRINT_HEX16;

/* printf-alike function: prints a string, substituting some patterns with members of ARGS
 * Patters include:
 *     - %D - for decimal number
 *     - %H - for 16-bit hexadecimal number
 *     - %N - for 8-bit hexadecimal number
 *     - %S - for string (argument interpreted as pointer to first character of string)
 *     - %C - for character
 *     - %% - for '%'
 * ARGS is a pointer to array of ADDRESSes, which represent the parameters. Ex.:
 * ```plm
 * DECLARE ARGS (2) ADDRESS;
 *
 * ARGS(0) = 69;
 * ARGS(1) = .('favourite', 0);
 *
 * CALL PRINTF(.('%D is my %S number', CRLF, 0), .ARGS);
 * ```
 */
PRINTF: PROCEDURE(FMT, ARGS) EXTERNAL;
    DECLARE (FMT, ARGS) ADDRESS;
END PRINTF;

/* fills buffer with bytes read using CONIN
 * stops reading upon receiving either '\r' or '\n'
 * supports backspace - but that's it for fancy features.
 * returns number of characters read.
 */
READLINE: PROCEDURE(BUFFER, MAXLEN) BYTE EXTERNAL;
    DECLARE BUFFER ADDRESS;
    DECLARE MAXLEN BYTE;
END READLINE;
