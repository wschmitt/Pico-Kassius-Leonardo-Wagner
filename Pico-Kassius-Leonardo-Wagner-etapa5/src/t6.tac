8
4
000: IF 000(SP)>004(SP) GOTO label0
001: GOTO label1
label0:
003: 000(Rx) := 000(SP) ADD 004(SP)
004: 000(SP) := 000(Rx)  
005: GOTO label2
label1:
label2:
008: PRINT 000(SP)
