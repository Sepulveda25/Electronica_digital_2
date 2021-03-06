include <P16F877.INC>

	TEMP equ 20h ; Variable de almacenamiento temporal

	ORG 0x00 ; Vector de Reset

	goto start
	
	org 0x04 ; Vector de interrupci?n
	goto service_int

	
org 0x10
start movlw 0FFh ; PORTB = 11111111b
movwf PORTB
bsf STATUS,RP0 ; Banco 1
movwf TRISA ; PORTA son entradas
clrf TRISB ; PORTB son salida
bcf STATUS,RP0 ; Banco 0
call InitializeAD
call SetupDelay ; Delay para Tad
bsf ADCON0,GO ; Inicia conversi?n A/D
loop goto loop

Rutina de interrupci?n A/D:
; muestra valor en los leds del PORTB
service_int btfss PIR1,ADIF ; ?Interrupcion del modulo A/D?
retfie ; Si no retornamos
movf ADRESH,W ; Cojo los 8 bits altos de la conversi?n
movwf PORTB ; los muestro en los LEDS del PORTB
bcf PIR1,ADIF ; Reseteo el flag
call SetupDelay ; Delay de adquisici?n
call SetupDelay ; mayor de 20 us
bsf ADCON0,GO ; lanzo una nueva conversi?n
retfie ; retorno, habilito GIE
; InitializeAD, inicializa el modulo A/D.
; Selecciona CH0 a CH3 como entradas anal?gicas, reloj RC y lee el CH0.
;
InitializeAD bsf STATUS,RP0 ; Banco 1
movlw B'00000100' ; RA0,RA1,RA3 entradas analogicas
movwf ADCON1 ; Justificado a la izquierda
; 8 bits mas significativos en ADRESH
bsf PIE1,ADIE ; Habilitamos interrupciones A/D 
bcf STATUS,RP0 ; Banco 0
movlw b'11000001' ; Oscilador RC, Entrada anal?gica CH0
movwf ADCON0 ; Modulo A/D en funcionamiento
bcf PIR1,ADIF ; Limpio flag interrupci?n
bsf INTCON,PEIE ; Habilito interrupciones de perifericos
bsf INTCON,GIE ; Habilito interrupciones globales
return
; Esta rutina es un retardo software de m?s de 10us si
; se usa un oscilador de 4MHz que se usa para asegurar
; un tiempo de adquisici?n de m?s de 20 us mediante una doble llamada
; antes de lanzar una nueva conversi?n.
SetupDelay movlw 3 ; Carga Temp con 3
movwf TEMP
SD decfsz TEMP, F ; Bucle de retardo
goto SD
return
END