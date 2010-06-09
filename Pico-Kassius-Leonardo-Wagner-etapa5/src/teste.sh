python tac2x86.py $1
as output.s -o output.o
ld -dynamic-linker /lib/ld-linux.so.2 -o foo -lc output.o
./foo
