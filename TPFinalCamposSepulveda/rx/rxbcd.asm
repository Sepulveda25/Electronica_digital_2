;RECEPTOR
#INCLUDE "P16F877A.INC"

__config _XT_OSC & _WDT_OFF & _LVP_OFF & _CP_OFF & _BODEN_OFF & _PWRTE_ON


DIS_LOW				EQU		0X21
DIS_HIGH			EQU		0X22
RECIBO				EQU		0X23
TEMP_W				EQU		0X24
TEMP_STATUS			EQU		0X25	
FLAG				EQU		0X26
ACU					EQU		0x27
CONT				EQU		0X28
NUMDISP				EQU		0X28
CONT_TMR0			EQU		0X29
	ORG 0X00
	
	GOTO CONFIGURACION

	ORG 0X04
	MOVWF	TEMP_W		;***************************
	SWAPF	STATUS,W	;SE GUARDA W Y STATUS
	MOVWF	TEMP_STATUS	;*****************************

	BANKSEL	RCREG	;**************************************************
	MOVF	RCREG,W	;LO QUE SE RECIVE SE MUESTRA EN EL PUERTOB
	MOVWF	RECIBO	;**************************************************
	BSF		FLAG,0 ; SETEAMOS LA BANDERA PARA INDICAR QUE SE PRESIONO UNA TECLA
	
	SWAPF	TEMP_STATUS,W	;**************************************
	MOVWF	STATUS			;SE RECUPERA W Y STATUS
	SWAPF	TEMP_W,F		;
	SWAPF	TEMP_W,W		;**************************************
	RETFIE
		

	
CONFIGURACION:

	BSF    STATUS,RP0   ; Pongo 1 en el RP0 de status
	BCF    STATUS,RP1   ; Pongo 0 en RP1 y estoy en banco 1.
	BSF		TRISC,7 	;RX SERIAL (ENTRADA)
	BCF		TRISC,6		;TX SERIAL (SALIDA)
	MOVLW	0X19 		; CARGO AL REGISTRO SPBRG CON 25 PARA TENER EL MENOR PORCENTAJE DE BITS ERRADOS SEGUN EL CALCULO
	MOVWF	SPBRG
	MOVLW	B'10000101'
	MOVWF	OPTION_REG
	MOVLW	0X06 	
	MOVWF	ADCON1		; DESACTIVA LA ENTRAS DIGITALES
	MOVLW	0XFC 		;1111
	MOVWF	TRISA		;RA0 Y RA1 COMO SALIDAS

;COFIGURO SALIDAS
	CLRF	TRISB ; TODAS SALIDAS
;CONFIFIRO EL REGISTO TXSTA 
	CLRF	TXSTA
;	BCF		TXSTA,7
	BCF		TXSTA,6		;ES PARA EL 9no BIT (8 BIT EN ESTE CASO)
	BSF		TXSTA,5		;HABILITO EL TRANSMISOR
	BSF		TXSTA,2 	;SELECCIONO LA VELOCIDAD ALTA
	BCF		TXSTA,4		;LO PONES EN MODO ASINCRONICO

;INTERRUPCION POR RECEPCION	
	MOVLW	0XC0 
	MOVWF	INTCON 		;HABILITO LAS INTERRUPCIONES GLOBALES
	BSF		PIE1,5		;HABILITA QUE SE TE INTERRUMPA CUANDO RECIBE

;CONFIGURO EL REGISTRO RCSTA
	BCF    	STATUS,RP0  ; Pongo 0 en el RP0 de status y estoy en banco 0.
	BSF		RCSTA,7 	; HABILITO TODO EL MODULO PARA COMUNICACION SERIAL
	BCF		RCSTA,6		; DESABILITO RX DEL BIT 9
	BSF		RCSTA,4 	; HABILITO LA RECEPCION 
	
	CLRF	DIS_LOW
	CLRF	DIS_HIGH

	MOVLW	D'100' ;    PARA UN TIEMPO DE 10ms
	MOVWF	TMR0

;*********************************************************************************
; rutina inicial para la comparacion de si es * o #
;*********************************************************************************
;/////////////////////////BUCLE PRINCIPAL/////////////////////
INICIAL: 
	BTFSS	FLAG,0 			; CONTROLA SI SE INTRODUJO UN NUMERO
	GOTO 	ESPEROYMUESTRO	;SIGO ESPERANDO FLAG MIENTRAS TANTO MUESTRO LOS REGISTROS
	GOTO	TESTEOTECLA		;TESTEO SI FUE * SINO TESTEO SI FUE #

ESPEROYMUESTRO:
	BTFSS	FLAG,1	;SE VERIFICA QUE ES LO QUE SE DEBE MOSTRAR POR LOS DISPLAYS
	CALL	MUESTRA	;SI ESTABA EN LA PARTE DE SUMA MUETRA EL RESULTADO
	BTFSC	FLAG,1	
 	CALL	LUCES	;SI ESTABA EN LA SECUENCIA DE LUCES MUESTRA LA SECUENCIA
	GOTO 	INICIAL	;SE REPITE EL BUCLE HASTA QUE LLEGUE ALGO POR EL PUERTO SERIE
;///////////////////////// BUCLE PRINCIPAL/////////////////////

TESTEOTECLA:
	BCF		FLAG,0	;PONE A CERO EL BIT QUE INDICA LA RECEPCION POR PUERTO SERIE	
	MOVLW	0X0A
	SUBWF	RECIBO,W
	BTFSC	STATUS,Z  ; compara si es * 
	GOTO	RUTINA_AST
	MOVLW	0X0B
	SUBWF	RECIBO,W
	BTFSS	STATUS,Z  ; compara si es #
	GOTO	INICIAL		;SI NO ES NI * NI # LO QUE SE RECIBIO SE VUELVE A BUCLE PRINCIPAL
	GOTO	RUTINA_NUM

RUTINA_AST:
	CALL	MUESTRA		;UN VEZ QUE SE INGRESO EL * SE 
	BTFSS	FLAG,0		;QUEDA ESPERANDO EL 
	GOTO	RUTINA_AST	;PROXIMO REGISTRO

	MOVLW	0X0A		;//////////////////////////////////
	SUBWF	RECIBO,W	;ESTA PARTE ESTA DEDICA A DETECTAR
	BTFSC	STATUS,Z  	;SI LO LLEGA NO SON NUMEROS
	GOTO	RUTINA_AST	;SI ES UN * SE VUELVE AL INICIO DE RUTINA_AST
	MOVLW	0X0B		;
	SUBWF	RECIBO,W	;SI ES UN # SE VA RUTINA_NUM
	BTFSC	STATUS,Z  	; 
	GOTO	RUTINA_NUM	;//////////////////////////////////
	
	BCF		FLAG,0	;PONE A CERO EL BIT QUE INDICA LA RECEPCION POR PUERTO SERIE
	BCF		FLAG,1	;PONE A CERO EL BIT QUE CONTROLA LO QUE SE VA A MOSTRAR POR LOS DISPLAYS 
	
	CALL	SUMADISPLAYS;	SUMO EL NUMERO QUE LLEGO POR LA COMUNICACION SERIE
	CALL	MUESTRA		; SE MUESTRA EL RESULTADO DE LA SUMA POR LOS DISPLAYS
	GOTO	INICIAL

RUTINA_NUM:		
	BSF		FLAG,1	;PONE A UNO EL BIT QUE CONTROLA LO QUE SE VA A MOSTRAR POR LOS DISPLAYS 
	CALL	LUCES	;SE VA A LA SECUENCIA DE LUCES
	GOTO	INICIAL

MUESTRA:	
	MOVLW	0XFE		;//////////////////////////////////////////
	MOVWF	PORTA 		;
	MOVF	DIS_LOW,W	;SE ACTIVA EL CORRESPONDIENTE TRANSISTOR 
	CALL	TABLA		;PARA ENCENDER EL DISPLAY
	MOVWF	PORTB		;SE DECODIFICA LOS VALORES DE LOS REGISTROS 
	CALL	ESPERA		;PARA MOSTRARLOS POR LOS DISPALYS
	COMF	PORTA,F		;
	MOVF	DIS_HIGH,W	;
	CALL	TABLA		;
	MOVWF	PORTB		;/////////////////////////////////////////
	CALL	ESPERA
	RETURN

ESPERA
	BTFSS	INTCON,TMR0IF	;/////////////////////////
	GOTO	ESPERA			;TEMPORIZACION DE 10mS
	MOVLW	D'100'			;
	MOVWF	TMR0			;
	BCF		INTCON,2		;//////////////////////////
	RETURN
		

TABLA:						;////////TABLA PARA LOS DISPLAYS
		ADDWF	PCL,F
		RETLW	B'01000000';0
		RETLW	B'01111001';1
		RETLW	B'00100100';2
		RETLW	B'00110000';3
		RETLW	B'00011001';4
		RETLW	B'00010010';5
		RETLW	B'00000011';6
		RETLW	B'01111000';7
		RETLW	B'00000000';8
		RETLW	B'00011000';9

		

SUMADISPLAYS:
		MOVF	RECIBO,W
		MOVWF	CONT
		BTFSC	STATUS,Z ;me fijo que lo que recibi es distinto de cero
		RETURN	
LOOP:	INCF	DIS_LOW,F	;SE INCREMENTA EN UNO EL REGISTRO DE UNIDAD
		MOVLW	D'10'		;LUEGO SE COMPRUEBA 
		SUBWF	DIS_LOW,W 	;SI SE EXCEDIO DE (9)D
		BTFSS	STATUS,Z  	;SI ASI FUE SE INCREMENTA EN UNO  
		GOTO	DIS2	
		GOTO	DIS1		;EL REGISTRO DE DECENA Y SE PONE EN CERO EL REGISTRO UNIDAD
DIS1:	CLRF	DIS_LOW		;LUEGO SE VERIFICA SI SE EXCEDE EL RIGISTRO DECENA
		INCF	DIS_HIGH	;EN CASO DE QUE ESTO HAYA OCURRIDO SE PONE EN CERO 
		MOVLW	D'10'		;EL REGISTRO DE LA DECENA
		SUBWF	DIS_HIGH,W
		BTFSC	STATUS,Z
		CLRF	DIS_HIGH
DIS2:	DECFSZ	CONT,F		;ESTO SE REPITE EL NUMERO VECES QUE SE HAYA
		GOTO	LOOP		;RECIBIDO POR EL PUERTO SERIE
		RETURN


LUCES:
		BCF		PORTA,0	; PRENDER LOS DOS DISPLAYS
		BCF		PORTA,1
		MOVLW	D'6'
		MOVWF	NUMDISP ;NUMERO QUE IDENTIFICA DISPLAY 7 SEGMENTOS
INICIO:
		MOVLW	D'10'		
		MOVWF	CONT_TMR0	
		MOVF	NUMDISP,W
		CALL	TABLADISP	;TABLA PARA EL EFECTO DE LUZ
		MOVWF	PORTB		
SEGUIR_ESPERANDO:
		CALL	ESPERA
		DECFSZ	CONT_TMR0 ; DECREMENTA CONT_TMR0=10 PARA HACER DEMORA DE 100mS
		GOTO	SEGUIR_ESPERANDO
		DECFSZ 	NUMDISP,F	 ; si ya recorrio todos los leds reinicia, sino sigue recorriendo
		GOTO	INICIO	
		RETURN		

TABLADISP:
		ADDWF	PCL,F
		RETLW	B'11111111'
		RETLW	B'01111110'
		RETLW	B'01111101'
		RETLW	B'01111011'
		RETLW	B'01110111'
		RETLW	B'01101111'
		RETLW	B'01011111'

		END	