# MPLAB IDE generated this makefile for use with GNU make.
# Project: TX-RX.mcp
# Date: Sat May 17 17:27:49 2014

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

TX.cof : TX.o
	$(CC) /p16F877A "TX.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"TX.cof" /M"TX.map" /W /x

TX.o : TX.asm C:/Program\ Files/Microchip/MPASM\ Suite/P16F877A.INC
	$(AS) /q /p16F877A "TX.asm" /l"TX.lst" /e"TX.err" /d__DEBUG=1

clean : 
	$(CC) "TX.o" "TX.hex" "TX.err" "TX.lst" "TX.cof"

