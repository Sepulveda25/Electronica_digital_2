# MPLAB IDE generated this makefile for use with GNU make.
# Project: rxbcd.mcp
# Date: Mon Jun 09 23:04:28 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

rxbcd.cof : rxbcd.o
	$(CC) /p16F877A "rxbcd.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"rxbcd.cof" /M"rxbcd.map" /W /x

rxbcd.o : rxbcd.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "rxbcd.asm" /l"rxbcd.lst" /e"rxbcd.err" /d__DEBUG=1

clean : 
	$(CC) "rxbcd.o" "rxbcd.hex" "rxbcd.err" "rxbcd.lst" "rxbcd.cof"

