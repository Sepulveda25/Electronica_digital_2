#include <P16F877A.INC>
        ;CON LA SIGUIENTE DIRECTIVA DE VARIOS ARGUMENTOS
        ;SE PREPARA LA PALABRA DE CONFIGURACIÓN PARA QUE
        ; ESTÉ LISTA ANTES DE PROGRAMARLO

    __config _XT_OSC & _WDT_OFF & _LVP_OFF & _CP_OFF & _BODEN_OFF & _PWRTE_ON

        ; SE AJUSTÓ A RELOJ A CRISTAL, PERRO GUARDIÁN APAGADO
        ; PROTECCIÓN DE LECTURA DE CÓDIGO APAGADA
        ; TIMER DE ARRANQUE ENCENDIDO , ETC...

C1    EQU    0X20            ;MIS VARIABLES EN RAM
C2    EQU    0X21

    org 0
    BSF            STATUS,RP0        ;PASO A PAGINA 1
    MOVLW    0XFF                    ;PUERTOA TODAS ENTRADAS
    MOVWF    TRISA
    MOVLW    0X00                     ;RB0 HASTA RB7 SALIDAS
    MOVWF    TRISB      
    BCF            STATUS,RP0        ;VUELVO A PAGINA 0
    
    MOVLW    7            ; PARA QUE SE PUEDA USAR EL PUERTO A
                                      ; COMO ENTRADA SALIDA DIGITAL
    MOVWF    CMCON        ;termina inicialización

L0:
    BSF    PORTB,1            ;ENCIENDO LED

        ; RETARDO DE TIEMPO DE 250 MILISEGUNDOS
            ; HECHO CON UN DOBLE LOOP
    MOVLW    D'250'
    MOVWF    C1            ; HECHO CON UN DOBLE LOOP
L2:
    MOVLW    D'250'
    MOVWF    C2
L1:
    DECF    C2,F
    BTFSS    STATUS,Z
    GOTO    L1
    DECF    C1,F
    BTFSS    STATUS,Z
    GOTO    L2

    BCF    PORTB,1            ;APAGO LED

        ;RETARDO DE TIEMPO IGUAL AL ANTERIOR
    MOVLW    D'250'
    MOVWF    C1
L4:
    MOVLW    D'250'
    MOVWF    C2
L3:
    DECF    C2,F
    BTFSS    STATUS,Z
    GOTO    L3
    DECF    C1,F
    BTFSS    STATUS,Z
    GOTO    L4
            ;VUELVO AL PRINCIPIO A REENCENDER EL LED
    GOTO    L0

    END