;Retardo de 1ms
#INCLUDE "P16F877A.INC"

DEC EQU 20H


		ORG 0X00

		MOVLW 0XF8
		MOVWF DEC

SIGO:	NOP
		DECFSZ DEC,F
		GOTO SIGO

		END