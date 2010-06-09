# as output.s -o output.o
# ld -dynamic-linker /lib/ld-linux.so.2 -o output -lc output.o
# ./output


.section .data					# MEM
	filo:	.space 8			# allocates space for STACK based on TAC
	temp:	.space 4			# allocates space for HEAP based on TAC.

	intf:	.string "%d\n"			# integer format for printing.
	
		.equ LINUX_SYSCALL , 0x80	# alias for invoking a system call through INT.

#------------------------------------------------------------------------------

.section .text					# CODE
	.extern printf
	.global _start				# enables linker (ld) to see it.
	.align 4				# ensures word (4 bytes, 32 bits) align of instructions.
	
	_start:	MOVL  $filo , %ECX		# register %ECX gets SP reference.
		MOVL  $temp , %EDX		# register %EDX gets Rx reference.

	_000:	LEAL (%ECX) , %EAX
		PUSHL  %EAX
		MOVL $3 , %EBX
		POPL %EAX
		MOVL %EBX , (%EAX)

	_001:	LEAL 4(%ECX) , %EAX
		PUSHL  %EAX
		MOVL $4 , %EBX
		POPL %EAX
		MOVL %EBX , (%EAX)

	_002:	MOVL (%ECX) , %EAX
		MOVL 4(%ECX) , %EBX
		CMPL %EAX , %EBX
		JG LABEL0

	_003:	JMP  LABEL1

	LABEL0:

	_005:	MOVL  (%ECX) , %EAX
		ADDL  4(%ECX) , %EAX
		MOVL  %EAX ,(%EDX)

	_006:	LEAL (%ECX) , %EAX
		PUSHL  %EAX
		MOVL (%EDX) , %EBX
		POPL %EAX
		MOVL %EBX , (%EAX)

	_007:	JMP  LABEL2

	LABEL1:

	LABEL2:

	_010:	PUSHL  %ECX
		PUSHL  %EDX
		PUSHL  (%ECX)
		PUSHL  $intf
		CALL printf
		POPL  %EAX
		POPL  %EAX
		POPL  %EDX
		POPL  %ECX

	_exit:	MOVL $1 , %EAX 
		MOVL $0 , %EBX 
		INT $LINUX_SYSCALL
.end
