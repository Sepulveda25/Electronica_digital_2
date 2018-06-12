#INCLUDE "P16F877A.INC"

__config _XT_OSC & _WDT_OFF & _LVP_OFF & _CP_OFF & _BODEN_OFF & _PWRTE_ON

REG1	EQU 0X20
REG2	EQU 0X21
REG3	EQU 0X22
REG4	EQU 0X23
CUENTA 	EQU	0X30
SALIDA	EQU	0X31

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
		MOVLW	D'9'
		MOVWF	REG1
		MOVLW	D'7'
		MOVWF	REG2
		MOVLW	D'5'
		MOVWF	REG3
		MOVLW	D'3'
		MOVWF	REG4

PRINCIPAL:
		MOVLW	D'4'
		MOVWF	CUENTA
		MOVLW	0XEF
		MOVWF	SALIDA
		MOVLW	0XEF
		MOVWF	PORTA
		MOVLW	0X20
		MOVWF	FSR
VUELVO:		
		MOVF	INDF,W
		CALL	TABLA
		MOVWF	PORTB
		RRF		SALIDA,F
		MOVF	SALIDA,W
		MOVWF	PORTA
		CALL	TIEMPO
ESPERAR:
		BTFSS	INTCON,2
		GOTO	ESPERAR
		INCF	FSR,F
		DECFSZ	CUENTA,F
		GOTO	VUELVO
		GOTO	PRINCIPAL
TABLA:
		ADDWF	PCL,F
		RETLW	B'01000000'
		RETLW	B'01111001'
		RETLW	B'00100100'
		RETLW	B'00110000'
		RETLW	B'00011001'
		RETLW	B'00010010'
		RETLW	B'00000011'
		RETLW	B'01111000'
		RETLW	B'00000000'
		RETLW	B'00011000'
TIEMPO:
		BCF		INTCON,2
		MOVLW	D'102'
		MOVWF	TMR0
		RETURN
		
		END
