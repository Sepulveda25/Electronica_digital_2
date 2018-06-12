#INCLUDE "P16F877A.INC"
__config _XT_OSC & _WDT_OFF & _LVP_OFF & _CP_OFF & _BODEN_OFF & _PWRTE_ON

TECLA 		EQU	0X20
DEC1		EQU	0X21
DEC2		EQU 0X22
BANDERA		EQU	0X23
TEMP_W		EQU	0X24
TEMP_STATUS	EQU	0X25
	org 0x00
	
	goto INICIO
	org 0x04
	MOVWF	TEMP_W		;***************************
	SWAPF	STATUS,W	;SE GUARDA W Y STATUS
	MOVWF	TEMP_STATUS	;*****************************

	;BANKSEL	RCREG	;**************************************************
	BSF		BANDERA,0
	BCF		INTCON,0		
	MOVWF	PORTB	;**************************************************

	SWAPF	TEMP_STATUS,W	;**************************************
	MOVWF	STATUS			;SE RECUPERA W Y STATUS
	SWAPF	TEMP_W,F		;
	SWAPF	TEMP_W,W		;**************************************
	RETFIE



INICIO 	
	BSF 	STATUS,RP0 ; Cambio a banco 1
	MOVLW 	0x06
	MOVWF	ADCON1    ; paso de analogico a digital
	MOVLW 	0xF8 ; Nibble alto del puerto B como
	MOVWF 	TRISB ; entrada y bajo como salida
	MOVLW	0XF0
	MOVWF 	TRISA ; Puerto A como salida
	;MOVLW	B'11001000'
	;MOVWF	INTCON
	BCF 	STATUS,RP0 ; Cambio a banco 0
	CLRF	PORTA
PRINCIPAL
	;BTFSC	BANDERA,0
	CALL 	TECLADO ; Llamar a rutina de teclado
	MOVWF 	PORTA ; Desplegar numero en puerto A
	GOTO 	PRINCIPAL ; Ejecucion ciclica del programa
;**************************************************
;** Rutina que escanea un teclado matricial 4x4 **
;** recorriendo un 0 por cada una de sus filas y **
;** leyendo el estado de cada columna, si la co- **
;** lumna se encuentra con un estado logico alto **
;** no se presiono ninguna tecla, si se encuen- **
;** tra en bajo (0) entonces se detecta la tecla **
;** presionda **
;**************************************************
TECLADO 
	CLRF 	TECLA ; Limpiar variable TECLA
	MOVLW 	b'00001110' ; Poner un cero en la primer
	MOVWF 	PORTB ; fila del puerto B (RB0)
CHECA_COL
	BTFSS 	PORTB,4 ; Si la 1er columna es "0"
	GOTO 	ANTIRREBOTES ; salta a la rutina ANTIRREBOTES
	INCF 	TECLA,F ; Si es "1" incrementa TECLA
	BTFSS 	PORTB,5 ; Si la 2da columna es "0"
	GOTO 	ANTIRREBOTES ; salta a la rutina ANTIRREBOTES
	INCF 	TECLA,F ; Si es "1" incrementa TECLA
	BTFSS 	PORTB,6 ; Si la 3er columna es "0"
	GOTO 	ANTIRREBOTES ; salta a la rutina ANTIRREBOTES
	INCF 	TECLA,F ; Si es "1" incrementa TECLA
	BTFSS 	PORTB,7 ; Si la 4ta columna es "0"
	GOTO 	ANTIRREBOTES ; salta a la rutina ANTIRREBOTES
	INCF 	TECLA,F ; Si es "1" incrementa TECLA
; Si no se detecto ninguna pulsacion se realiza una comparacion
; entre la variable TECLA y el numero "16", si TECLA es menor que
; 16 el "0" en las filas del puerto B se recorre hacia la izquierda
; hacia la siguiente fila, si TECLA es igual a "16" la rutina del
; TECLADO vuelve a comenzar
	MOVLW 	d'12'
	SUBWF 	TECLA,W
	BTFSC 	STATUS,Z
	GOTO	TECLADO
	BSF 	STATUS,C
	RLF		PORTB,F
	GOTO 	CHECA_COL
;*********************************************************
;** Rutina que elimina los rebotes y ademas decodifica **
;** la tecla pulsada y regresa el valor binario necesa- **
;** para desplegar los numeros de 0 a F en un display **
;** de 7 segmentos conectado al puerto A **
;*********************************************************
ANTIRREBOTES
	CALL	ESPERAR
	B1 
		BTFSS 	PORTB,4
		GOTO 	B1
	B2 
		BTFSS 	PORTB,5
		GOTO 	B2
	B3 
		BTFSS 	PORTB,6
		GOTO 	B3
	B4 
		BTFSS 	PORTB,7
		GOTO 	B4

		MOVF 	TECLA,W
		CALL 	DECOD_TECLA
		;BCF		BANDERA,0
		RETURN
DECOD_TECLA
		ADDWF 	PCL,f
		RETLW 	0XFE
		RETLW 	0XFB
		RETLW 	0XF8
		RETLW 	0XF5
		RETLW 	0XFD
		RETLW 	0XFA
		RETLW 	0XF7
		RETLW 	0XFF
		RETLW 	0XFC
		RETLW 	0XF9
		RETLW 	0XF6
		RETLW 	0XF4

ESPERAR:;50mS

SIGO3:
		MOVLW 0X32
		MOVWF DEC2
SIGO2:
		MOVLW 0XF9
		MOVWF DEC1
SIGO:
		NOP
		DECFSZ DEC1,F
		GOTO SIGO
		DECFSZ DEC2,F
		GOTO SIGO2
	
		RETURN		
		END