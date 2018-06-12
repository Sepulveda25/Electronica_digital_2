# MPLAB IDE generated this makefile for use with GNU make.
# Project: displays.mcp
# Date: Thu May 15 12:38:16 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

displays.cof : displays.o
	$(CC) /p16F877A "displays.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"displays.cof" /M"displays.map" /W /x

displays.o : displays.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "displays.asm" /l"displays.lst" /e"displays.err" /d__DEBUG=1

clean : 
	$(CC) "displays.o" "displays.hex" "displays.err" "displays.lst" "displays.cof"

