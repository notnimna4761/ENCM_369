# string-funcs.asm
# ENCM 369 Winter 2023 Lab 4 Exercise C

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciz	"***About to exit. main returned "
exit_msg_2:
	.asciz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust sp, then call main
	andi	sp, sp, -32		# round sp down to multiple of 32
	jal	main
	
	# when main is done, print its return value, then halt the program
	sw	a0, main_rv, t0	
	la	a0, exit_msg_1
	li	a7, 4
	ecall
	lw	a0, main_rv
	li	a7, 1
	ecall
	la	a0, exit_msg_2
	li	a7, 4
	ecall
	lw	a0, main_rv
	addi	a7, zero, 93	# call for program exit with exit status that is in a0
	ecall
# END of start-up & clean-up code.
	

#	void copycat(char *dest, const char *src1, const char *src2)
#
	.text
	.globl	copycat
copycat:

L1:	
	lbu	t1, (a1)	# t1 = *src1
	beq	t1, zero, L2	#if (*src1 == '\0') goto L2
	lbu	t0,(a1)
	sb	t0, (a0)	# *dest = *src1
	addi	a1, a1, 1	# *src++
	addi	a0, a0, 1	# *dest++
	j	L1
L2:	
	lbu	t2, (a2)	# t2 = *src2
	sb	t2,(a0)
	addi	a2, a2, 1	# *src2++
	addi	a0, a0, 1	# *dest++
	bne	t2,zero,L2	# if (c == '\0') goto 
	jr	ra
	

#	void lab4reverse(const char *str)
#	
	.text
	.globl	lab4reverse
lab4reverse:


	li	t1,0		# back = 0
K1:	
	lbu	t0,(a0)		# t0 = &str
	add	t0,t0,t1	# str[back]
	beq	t0,zero,K2	# if (str[back] == '\0') goto L2
	addi	t1,t1,1		# back++;
	j	L1		
K2:	
	addi	t1,t1,-1	# back--;
	li	t2,0		# front = 0

K3:		
	ble	t1,t2,K4	# if (back <= front) goto L4
	lbu	t3,(t0)		# c = str[back]
	add	t4,t4,t2	# str[front]
	sb	t4,(t0)		# str[back] = str[front]
	lbu	t3,(t4)		# str[front] = c
	addi	t1,t1,-1	# back--
	addi	t2,t2,1		# front ++
	j	K3

K4:
	jr	ra

	
#	void print_in_quotes(const char *str)
#
	.text
	.globl	print_in_quotes
print_in_quotes:
	add	t0, a0, zero		# copy str to t0	
	
	addi	a0, zero, '"'
	li	a7, 11
	ecall
	mv	a0, t0
	li	a7, 4
	ecall
	li	a0, '"'
	li	a7, 11	     
	ecall
	li	a0, '\n'
	li	a7, 11
	ecall
	jr	ra		
		
#	Global arrays of char for use in testing copycat and lab4reverse.
	.data
	
	.align	5
	# char array1[32] = { '\0', '*', ..., '*' };
array1:	.byte	0, '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'	
	.byte	'*', '*', '*', '*', '*', '*', '*', '*'
	
	# char array2[] = "X";	
array2:	.asciz "X"
		
	# char array3[] = "YZ";	
array3:	.asciz "YZ"
		
	# char array4[] = "123456";	
array4:	.asciz "123456"
		
	# char array5[] = "789abcdef";	
array5:	.asciz "789abcdef"
		
#	int main(void)
#
#	string constants used by main
	.data
sc0:	.asciz ""
sc1:	.asciz	"good"
sc2:	.asciz "bye"
sc3:	.asciz "After 1st call to copycat, array1 has "
sc4:	.asciz "After 2nd call to copycat, array1 has "
sc5:	.asciz "After 3rd call to copycat, array1 has "
sc6:	.asciz "After 4th call to copycat, array1 has "
sc7:	.asciz "After use of lab4reverse, array2 has "
sc8:	.asciz "After use of lab4reverse, array3 has "
sc9:	.asciz "After use of lab4reverse, array4 has "
sc10:	.asciz "After use of lab4reverse, array5 has "

	.text
	.globl	main
main:
	# Prologue only needs to save ra
	addi	sp, sp, -32
	sw	ra, 0(sp)
	
	# Body
	# Start tests of copycat.
	la	a0, array1	# a0 = array1
	la	a1, sc0		# a1 = sc0
	la	a2, sc0		# a2 = sc0
	jal	copycat
	la	a0, sc3
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc1		# a1 = sc1
	la	a2, sc0		# a2 = sc0
	jal	copycat
	la	a0, sc4
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc0		# a1 = sc0
	la	a2, sc2		# a2 = sc2
	jal	copycat
	la	a0, sc5
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	la	a0, array1	# a0 = array1
	la	a1, sc1		# a1 = sc1
	la	a2, sc2		# a2 = sc2
	jal	copycat
	la	a0, sc6
	li	a7, 4
	ecall	
	la	a0, array1	# a0 = array1
	jal	print_in_quotes
	
	# End tests of lab4cat; start tests of lab4reverse.
	la	a0, array2	# a0 = array2
	jal	lab4reverse
	la	a0, sc7
	li	a7, 4
	ecall
	la	a0, array2	# a0 = array2
	jal	print_in_quotes
	
	la	a0, array3	# a0 = array3
	jal	lab4reverse
	la	a0, sc8
	li	a7, 4
	ecall
	la	a0, array3	# a0 = array3
	jal	print_in_quotes
	
	la	a0, array4	# a0 = array4
	jal	lab4reverse
	la	a0, sc9
	li	a7, 4
	ecall
	la	a0, array4	# a0 = array4
	jal	print_in_quotes
	
	la	a0, array5	# a0 = array5
	jal	lab4reverse
	la	a0, sc10
	li	a7, 4
	ecall
	la	a0, array5	# a0 = array5
	jal	print_in_quotes
		
	# End tests of lab4reverse.
	
	mv	a0, zero	# r.v. from main = 0
	
	# Epilogue
	lw	ra, 0(sp)
	addi	sp, sp, 32
	jr	ra
