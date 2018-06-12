;2.2)Escribir un programa que resuelva la ecuacion (A+B)-C (posiciones 20H,21H y 22H)

#INCLUDE "P16F877A.INC"

REG_A	EQU	0X21
REG_B	EQU	0X22

	ORG 0X00
	
	MOVLW	D'30'	
	MOVWF	REG_A
	MOVLW	D'40'
	ADDWF	REG_A,F
	MOVLW	D'50'
	MOVWF	REG_B
	SUBWF	REG_A,W
	END
	