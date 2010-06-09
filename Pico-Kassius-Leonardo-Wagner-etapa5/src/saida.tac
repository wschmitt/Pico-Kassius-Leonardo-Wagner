tmp0 := x ADD 2
IF 000(Rx) > 004(SP) GOTO _003
tmp1 := 0  
GOTO _004
tmp1 := 1  
tmp2 := 5 ADD 5
x := tmp2  
IF 000(SP) == 004(SP) GOTO _009
tmp3 := 0  
GOTO _010
tmp3 := 1  
tmp4 := 5 ADD 7
x := tmp4  
PRINT x
