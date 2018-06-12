# MPLAB IDE generated this makefile for use with GNU make.
# Project: TXTeclado.mcp
# Date: Tue Jun 10 01:52:31 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

txteclado.cof : txteclado.o
	$(CC) /p16F877A "txteclado.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"txteclado.cof" /M"txteclado.map" /W /x

txteclado.o : txteclado.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "txteclado.asm" /l"txteclado.lst" /e"txteclado.err" /d__DEBUG=1

clean : 
	$(CC) "txteclado.o" "txteclado.hex" "txteclado.err" "txteclado.lst" "txteclado.cof"

