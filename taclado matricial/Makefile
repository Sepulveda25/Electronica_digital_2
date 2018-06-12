# MPLAB IDE generated this makefile for use with GNU make.
# Project: teclado.mcp
# Date: Tue Jun 10 00:37:10 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

teclado.cof : teclado.o
	$(CC) /p16F877A "teclado.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"teclado.cof" /M"teclado.map" /W /x

teclado.o : teclado.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "teclado.asm" /l"teclado.lst" /e"teclado.err" /d__DEBUG=1

clean : 
	$(CC) "teclado.o" "teclado.hex" "teclado.err" "teclado.lst" "teclado.cof"

