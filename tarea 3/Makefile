# MPLAB IDE generated this makefile for use with GNU make.
# Project: tarea3.mcp
# Date: Thu May 08 14:17:36 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

tarea.cof : tarea.o
	$(CC) /p16F877A "tarea.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"tarea.cof" /M"tarea.map" /W /x

tarea.o : tarea.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "tarea.asm" /l"tarea.lst" /e"tarea.err" /d__DEBUG=1

clean : 
	$(CC) "tarea.o" "tarea.hex" "tarea.err" "tarea.lst" "tarea.cof"

