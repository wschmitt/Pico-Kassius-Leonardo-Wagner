204
76
000: 000(Rx) := 9 ADD 3
001: 004(Rx) := 000(Rx) SUB 0
002: 004(Rx) := 004(Rx) MUL 4
003: 004(Rx)(024(SP)) := 12
004: 012(Rx) := 1 SUB 0
005: 008(Rx) := 012(Rx) MUL 48
006: 016(Rx) := 2 SUB 0
007: 020(Rx) := 016(Rx) MUL 8
008: 008(Rx) := 008(Rx) ADD 020(Rx)
009: 024(Rx) := 2 SUB 0
010: 028(Rx) := 024(Rx) MUL 4
011: 008(Rx) := 008(Rx) ADD 028(Rx)
012: 032(Rx) := 2 SUB 0
013: 008(Rx) := 008(Rx) ADD 032(Rx)
014: 008(Rx) := 008(Rx) MUL 4
015: 036(Rx) := 12 SUB 0
016: 036(Rx) := 036(Rx) MUL 4
017: 036(Rx) := 036(Rx)(024(SP))
018: 040(Rx) := 036(Rx) SUB 0
019: 040(Rx) := 040(Rx) MUL 4
020: 040(Rx) := 040(Rx)(024(SP))
021: 044(Rx) := 040(Rx) MUL 2
022: 008(Rx)(000(SP)) := 044(Rx)
023: 052(Rx) := 1 SUB 0
024: 048(Rx) := 052(Rx) MUL 48
025: 056(Rx) := 2 SUB 0
026: 060(Rx) := 056(Rx) MUL 8
027: 048(Rx) := 048(Rx) ADD 060(Rx)
028: 064(Rx) := 2 SUB 0
029: 068(Rx) := 064(Rx) MUL 4
030: 048(Rx) := 048(Rx) ADD 068(Rx)
031: 072(Rx) := 2 SUB 0
032: 048(Rx) := 048(Rx) ADD 072(Rx)
033: 048(Rx) := 048(Rx) MUL 4
034: 048(Rx) := 048(Rx)(000(SP))
035: 148(SP) := 048(Rx)  
036: PRINT 148(SP)
