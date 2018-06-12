;lee 4 en registros en BCD y los muestra por los 4 displays durante un segundo y luego lee otros 4 registros mas y los muestra por los displays 
#INCLUDE "P16F877A.INC"

__config _XT_OSC & _WDT_OFF & _LVP_OFF & _CP_OFF & _BODEN_OFF & _PWRTE_ON

REG1	EQU 0X20
REG2	EQU 0X21
REG3	EQU 0X22
REG4	EQU 0X23
REG5	EQU 0X24
REG6	EQU 0X25
REG7	EQU 0X26
REG8	EQU 0X27
CUENTA 	EQU	0X30
SALIDA	EQU	0X31
DEMORA	EQU	0X32
P1		EQU	0X33
P2		EQU	0X34
PUNTERO	EQU	0X35

		ORG 0X00
CONF:
		BCF		STATUS,RP1
		BSF		STATUS,RP0  ;estamos en banco 1
		MOVLW 	0x06
		MOVWF	ADCON1    ; paso de analogico a digital
		CLRF	INTCON		; deshabilito las interrupciones
		MOVLW	B'10000000'
		MOVWF	TRISB		;dejamos el bit 7 como entrada y resto como salida
		MOVLW	B'11110000'
		MOVWF	TRISA		
		MOVLW	B'10000100'
		MOVWF	OPTION_REG	;se configura para que la cuenta se lleve con el clk interno, se asigana el prescaler al modulo TMR0,con un prescaler 1:32
		BCF		STATUS,RP0 ;estamos en banco 0
		CLRF	PORTB

CARGA_REGISTROS:
		MOVLW	D'9'	;******************************************************************
		MOVWF	REG1	;********************************************************************
		MOVLW	D'3'	;
		MOVWF	REG2
		MOVLW	D'8'
		MOVWF	REG3
		MOVLW	D'4'	; SE CARGAN LOS REGISTROS PARA LOS DISPLAYS
		MOVWF	REG4

		MOVLW	D'6'
		MOVWF	REG5
		MOVLW	D'1'
		MOVWF	REG6
		MOVLW	D'0'
		MOVWF	REG7
		MOVLW	D'2'	;**********************************************************************
		MOVWF	REG8	;*********************************************************************

		MOVLW	0X20	;********************************************************************
		MOVWF	P1		;PUNTEROS DONDE SE VAN COMENZAR LAS LECTURAS PARA LOS DISPLAYS
		MOVLW	0X24	;
		MOVWF	P2		;********************************************************************

PRINCIPAL:
		MOVF	P1,W	; SE LLAMA PARA MOSTRAR LOS REGISTROS
		CALL	MOSTRAR	;
		MOVF	P2,W
		CALL	MOSTRAR
		GOTO	PRINCIPAL

MOSTRAR:
		MOVWF	PUNTERO
		MOVLW	D'50'	; ESTE VALOR HACE UNA DEMORA DE 1 SEGUNDO
		MOVWF	DEMORA	;	QUE ES EL TIEMPO QUE SE VAN A RETENER LOS REGISTROS EN LOS DISPLAYS
SEGUIR:
		MOVF	PUNTERO,W	;
		CALL	DISPLAYS	;SACA POR LOS DISPLAYS LOS VALORES DE LOS REGISTROS
		DECFSZ	DEMORA,F	
		GOTO 	SEGUIR
		RETURN
				

DISPLAYS:
		MOVWF	FSR
		MOVLW	D'4'
		MOVWF	CUENTA
		MOVLW	0XEF
		MOVWF	SALIDA
		MOVLW	0XEF
		MOVWF	PORTA
VUELVO:		
		MOVF	INDF,W
		CALL	TABLA
		MOVWF	PORTB
		RRF		SALIDA,F
		MOVF	SALIDA,W
		MOVWF	PORTA
		CALL	TIEMPO
ESPERAR:
		BTFSS	INTCON,2	;se verifica que haya 
		GOTO	ESPERAR		;pasado los 5 ms
		INCF	FSR,F
		DECFSZ	CUENTA,F
		GOTO	VUELVO
		RETURN
TABLA:
		ADDWF	PCL,F
		RETLW	B'01000000'	;0
		RETLW	B'01111001'	;1
		RETLW	B'00100100'	;2
		RETLW	B'00110000'	;3
		RETLW	B'00011001'	;4
		RETLW	B'00010010'	;5
		RETLW	B'00000011'	;6
		RETLW	B'01111000'	;7
		RETLW	B'00000000'	;8
		RETLW	B'00011000'	;9

TIEMPO:
		BCF		INTCON,2
		MOVLW	D'101' ;con este valor y el prescaler en 1:32 se retarda 5ms que se usa como base de tiempo
		MOVWF	TMR0  	; tanto para el refresh de los displays (5ms c/u) como para la retencion de los numeros en los displays (1 s)
		RETURN
		
		END

