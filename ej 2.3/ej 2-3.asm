;2.3) Progrma que suma dos numeros de 16 bits A(20H 21H)y B(22H 23H)y el resultado colocarlo en A 
#INCLUDE "P16F877A.INC"

LOW_A	EQU	0X20
HI_A	EQU	0X21
LOW_B	EQU	0X22
HI_B	EQU	0X23

	ORG 0X00
	
	MOVLW	0X85	; Se cargan los
	MOVWF	LOW_A	; registros
	MOVLW	0X2F	;	con distintos 
	MOVWF	LOW_B	;	valores
	MOVLW	0X03	;
	MOVWF	HI_A	;
	MOVLW	0X01	;
	MOVWF	HI_B	;
	
	CLRW	
	ADDWF	LOW_B,W	; Se carga lo del registro LOW_B en W
	ADDWF	LOW_A,F	; para sumarlo al registro LOW_A y guardar el resultado en el registro LOW_A
	BTFSC	STATUS,C	;Se verifica que la suma de LOW_A y LOW_B se haya exedido (testeando el bit de status)
	INCF	HI_A,F		; en el caso que haya sucedido se incrementa en uno el registro HI_A sino se sigue
	CLRW
	ADDWF	HI_B,W	; Por ultimo se suman 
	ADDWF	HI_A,F	; los registros HI_B y HI_A
	END
