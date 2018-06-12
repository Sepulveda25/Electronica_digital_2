#INCLUDE"P16F877A.INC"


REG1 EQU	20H
REG2 EQU	21H
REG3 EQU	22H
REG4 EQU	23H
REG5 EQU	24H
REG6 EQU	25H
REG7 EQU	26H
REG8 EQU	27H
REG9 EQU	28H
REG10 EQU	29H
REG11 EQU	2AH
REG12 EQU	2BH
REG13 EQU	2CH
REG14 EQU	2DH
REG15 EQU	2EH
REG16 EQU	2FH
REG17 EQU	30H

CUENTA EQU	31H

ORG 0X00

MOVLW	31H
MOVWF	REG1
MOVLW	32H
MOVWF	REG2
MOVLW	33H
MOVWF	REG3
MOVLW	34H
MOVWF	REG4
MOVLW	35H
MOVWF	REG5
MOVLW	36H
MOVWF	REG6
MOVLW	37H
MOVWF	REG7
MOVLW	38H
MOVWF	REG8
MOVLW	39H
MOVWF	REG9
MOVLW	38H
MOVWF	REG10
MOVLW	37H
MOVWF	REG11
MOVLW	36H
MOVWF	REG12
MOVLW	35H
MOVWF	REG13
MOVLW	34H
MOVWF	REG14
MOVLW	33H
MOVWF	REG15
MOVLW	32H
MOVWF	REG16
MOVLW	31H
MOVWF	REG17

MOVLW	D'17'
MOVWF	CUENTA

MOVLW	20H
MOVWF	FSR
LOOP:
MOVLW	0X0F
ANDWF	INDF,F

INCF	FSR,F
DECFSZ	CUENTA,F
GOTO LOOP
END









