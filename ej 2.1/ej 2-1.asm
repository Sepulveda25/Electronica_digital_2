;Escribir un programa que sume dos valores guardados en 21H y 22H con resultado en 23H y 24H 

#include "P16F877A.INC"

REG_A	EQU 0X21
REG_B	EQU	0X22
RESUL_LOW	EQU 0X23
RESUL_HI	EQU 0X24

	ORG 0X00
	
	MOVLW	d'200'	;	Se carga los valores en decimal
	MOVWF	REG_A	;	que se van a sumar en
	MOVLW	d'120'	;	los registros
	MOVWF	REG_B	; 	A y B
	CLRW
	ADDWF	REG_A,W
	ADDWF	REG_B,W
	MOVWF	RESUL_LOW
	BTFSC	STATUS,C
	INCF	RESUL_HI
	END
