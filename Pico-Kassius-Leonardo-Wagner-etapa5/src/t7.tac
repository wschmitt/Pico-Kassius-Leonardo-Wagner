8
4
000: 000(SP) := 3  
001: 004(SP) := 4  
002: IF 000(SP) < 004(SP) GOTO LABEL0
003: GOTO LABEL1
LABEL0:
005: 000(Rx) := 000(SP) ADD 004(SP)
006: 000(SP) := 000(Rx)  
007: GOTO LABEL2
LABEL1:
LABEL2:
010: PRINT 000(SP)