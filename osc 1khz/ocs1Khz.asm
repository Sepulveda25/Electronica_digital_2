#INCLUDE "P16F877A.INC"


		ORG 0X00
CONF:
		BCF		STATUS,RP1
		BSF		STATUS,RP0  ;estamos en banco 1
		MOVLW 	0x06
		MOVWF	ADCON1    ; paso de analogico a digital
		CLRF	INTCON		; deshabilito las interrupciones
		MOVLW	B'11111110'
		MOVWF	TRISB		;dejamos el bit 0 como salida y resto como entrada
		MOVLW	B'10000000'
		MOVWF	OPTION_REG	;se configura para que la cuenta se lleve con el clk interno, se asigana el prescaler al modulo TMR0,con un prescaler 1:2
		BCF		STATUS,RP0 ;estamos en banco 0
		CLRF	PORTB

PRINCIPAL:
		CALL	TIEMPO
CERO:
		BCF		PORTB,0
		BTFSS	INTCON,2
		GOTO	CERO
		CALL	TIEMPO
UNO:		
		BSF		PORTB,0
		BTFSS	INTCON,2
		GOTO	UNO
		GOTO	PRINCIPAL

TIEMPO:
		BCF		INTCON,2
		MOVLW	D'8'
		MOVWF	TMR0
		RETURN
		
		END