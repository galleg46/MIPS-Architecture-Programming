###########################################################
#		Program #5
#
#	Name: Anthony Gallegos
#	Date: 4/28/2021
#
#		Program Description
#
#	The following will ask the user to specify the dimensions of a
#	matrix, it then dynamically allocates it and reads double precision
#   numbers to fill it. It will then print out the matrix to the console
#	in table format. Then the program will create a new matrix containing the 
#	transpose of the matrix to the console in table format. Finally, the user 
#	will be prompted to enter a valid row and column index of the transposed
#	array, and a submatrix excluding the row and column will be printed to
#   the console.
#
#	The data in the 2-dimensional array will be stored in column-major order
#
###########################################################
#		Register Usage
#	$t0 	array A base address
#	$t1		array A height
#	$t2 	array A width
#	$t3		array T base address
#	$t4		array T height
#	$t5		array T width
#	$t6
#	$t7
#	$t8
#	$t9		temporary register
###########################################################
		.data
matrixA:		.word	0
heightA:		.word 	0
widthA:			.word	0

matrixT:		.word	0
heightT:		.word	0
widthT:			.word	0

print_matrixA_p: .asciiz "Matrix:\n"
print_matrixT_p: .asciiz "Transposed Matrix:\n"
###########################################################
		.text
main:
	addi $sp, $sp, 4		# allocate space on the stack for return address
	sw $ra, 0($sp)			# store return address on the stack

	addi $sp, $sp, -12		# allocate space on the stack for arguments OUT

	jal create_matrix		# call subprogram

	lw $t0, 0($sp)			# load the array base address off the stack	
	lw $t1, 4($sp)			# load the height off the stack
	lw $t2, 8($sp)			# load the width off the stack
	addi $sp, $sp, 12		# deallocate space off the stack for arguments OUT

	lw $ra, 0($sp)			# load the return address off the stack
	addi $sp, $sp, 4		# deallocate space off the stack for return address

	la $t9, matrixA			# $t9 = address of variable matrixA
	sw $t0, 0($t9)			# store array base address in matrixA

	la $t9, heightA			# $t9 = address of variable heightA
	sw $t1, 0($t9)			# store array height in heightA

	la $t9, widthA			# $t9 = address of variable widthA
	sw $t2, 0($t9)			# store array width in widthA

	li $v0, 4				# print to label the matrix
	la $a0, print_matrixA_p
	syscall

	addi $sp, $sp, -4		# allocate space on the stack for return address
	sw $ra, 0($sp)			# store return address on the stack

	addi $sp, $sp, -12		# allocate space on the stack for saving
	sw $t0, 0($sp)			# save array base address on to the stack
	sw $t1, 4($sp)			# save array height on to the stack
	sw $t2, 8($sp)			# save array width on to the stack

	addi $sp, $sp, -12		# allocate space on the stack for arguments
	sw $t0, 0($sp)			# store the array base address on to the stack
	sw $t1, 4($sp)			# store the array height on to the stack
	sw $t2, 8($sp)			# store the array width on to the stack

	jal print_matrix		# call subprogram

	addi $sp, $sp, 12		# deallocate space for arguments 

	lw $t0, 0($sp)			# load array base address off the stack
	lw $t1, 4($sp)			# load array height off the stack
	lw $t2, 8($sp)			# load array width off the stack
	addi $sp, $sp, 12		# deallocate space for saved registers

	lw $ra, 0($sp)			# load return address off the stack
	addi $sp, $sp, 4		# deallocate space for return address

	addi $sp, $sp, -4		# allocate space on the stack for return address
	sw $ra, 0($sp)			# store return address on to the stack

	addi $sp, $sp, -12		# allocate space on the stack for saving
	sw $t0, 0($sp)			# save array base address
	sw $t1, 4($sp)			# save array height
	sw $t2, 8($sp)			# aave array width

	addi $sp, $sp, -24		# allocate space on the stack for arguments
	sw $t0, 0($sp)			# store array base address on the stack
	sw $t1, 4($sp)			# store array height on the stack
	sw $t2, 8($sp)			# store array width on the stack

	jal transpose_matrix	# call subprogram

	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		create_matrix Subprogram
#
#		Subprogram Description
#	
#	Prompts the user for a height and a width greater than
#	0, then allocates an arrray of that size by calling 
#	subprogram "allocate_array" and fills it with double 
#	precision values by calling subprogram "read_matrix"
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array base address (integer)
#	$sp+4	array height (integer)
#	$sp+8	array width (integer)
###########################################################
#		Register Usage
#	$t0 	array base address
#	$t1		array height
#	$t2		array width
###########################################################
		.data
prompt_height:		.asciiz		"Enter the height of the matrix: "
prompt_width:		.asciiz		"Enter the width of the matrix: "
prompt_error:		.asciiz		"Error! Dimension should be greater than zero!"
###########################################################
		.text
create_matrix:

create_matrix_height_loop:
	li $v0, 4				# prompt user for a height
	la $a0, prompt_height
	syscall

	li $v0, 5				# read user inpuut (integer)
	syscall
	
	bgtz $v0, create_matrix_height_valid	# check if the height is a valid value

	li $v0, 4				# print error msg of height < 0
	la $a0, prompt_error
	syscall

	b create_matrix_height_loop		# loop back to the beginning of the loop

create_matrix_height_valid:
	move $t1, $v0			# $t1 = height = user input

create_matrix_width_loop:
	li $v0, 4				# prompt user for a width
	la $a0, prompt_width
	syscall

	li $v0, 5				# read user input (integer)
	syscall

	bgtz $v0, create_matrix_width_valid		# check if the width is a valid value

	li $v0, 4				# print error msg if width < 0
	la $a0, prompt_error
	syscall

	b create_matrix_width_loop		# loop back to the beginning of the loop

create_matrix_width_valid:
	move $t2, $v0			# $t2 = width = useri input

# prepare arguments for jal allocate_array
	addi $sp, $sp, -4		# allocate space on the stack for return address
	sw $ra, 0($sp)			# store return address on to the stack

	addi $sp, $sp, -8		# allocate space on the stack to save
	sw $t1, 0($sp)			# save the height on to the stack
	sw $t2, 4($sp)			# save the width on to the stack
	
	addi $sp, $sp, -12		# allocate space on to the stack for Arguments(2 IN, 1 OUT)
	sw $t1, 0($sp)			# store the height on to the stack
	sw $t2, 4($sp)			# store the width on to the stack

	jal allocate_array		# call subprogram

	lw $t0, 8($sp)			# load array base address off the stack
	addi $sp, $sp, 12		# deallocate space on the stack that was used for arguments

	lw $t1, 0($sp)			# load the height off the stack
	lw $t2, 4($sp)			# load the width off the stack
	addi $sp, $sp, 8		# deallocate space on the stack for saving

	lw $ra, 0($sp)			# load return address off the stack
	addi $sp, $sp, 4		# deallocate space on the stack for return address

# prepare arguments for jal read_matrix
	addi $sp, $sp, -4		# allocate space on the stack for return address
	sw $ra, 0($sp)			# store return address on to the stack

	addi $sp, $sp, -12		# allocate space on the stack for saving 
	sw $t0, 0($sp)			# save array base address on to the stack
	sw $t1, 4($sp)			# save the height on to the stack
	sw $t2, 8($sp)			# save the width on to the stack

	addi $sp, $sp, -12		# allocate space on the stack for arguments (3 IN, 0 OUT)
	sw $t0, 0($sp)			# store the array base address on to the stack
	sw $t1, 4($sp)			# store the height on to the stack
	sw $t2, 8($sp)			# store the width on to the stack

	jal read_matrix			# call subprogram

	addi $sp, $sp, 12		# deallocate space from stack for arguments

	lw $t0, 0($sp)			# load the array base address off the stack
	lw $t1, 4($sp)			# load the height off the stack
	lw $t2, 8($sp)			# load the width off the stack
	addi $sp, $sp, 12		# deallocate space from stack for saving

	lw $ra, 0($sp)			# load the return address off the stack
	addi $sp, $sp, 4		# deallocate space from stack for the return address

create_matrix_end:
	sw $t0, 0($sp)			# return the array base address, store on to the stack
	sw $t1, 4($sp)			# return the array height, store on to the stack
	sw $t2, 8($sp)			# return the array width, store on to the stack

	jr $ra					# return to calling location
###########################################################
###########################################################
#		allocate_matrix Subprogram
#
#		Subprogram Description
#
#	creates a 2-dimensional array of double precision numbers
#	using the provided height and width from create_matrix
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array height(integer) (IN)
#	$sp+4	array width(integer) (IN)
#	$sp+8	array base address(integer) (OUT)
###########################################################
#		Register Usage
#	$t0		array height (integer)
#	$t1		array width (integer)
###########################################################
		.data

###########################################################
		.text
allocate_array:
# load arguments off the stack
	lw $t0, 0($sp)			# load the height off the stack
	lw $t1, 4($sp)			# load the width off the stack

	li $v0, 9				# allocate space for the 2-D array using system call 9
	mul $a0, $t0, $t1		# $a0 = height($t0) * width($t1)
	sll $a0, $a0, 3			# $a0 = $a0 * 2^3
	syscall					# $v0 = new array base address

allocate_array_end:
	sw $v0, 8($sp)			# return the array base address by storing on to the stack

	jr $ra					# return to calling location
###########################################################
###########################################################
#		read_matrix Subprogram
#
#		Subprogram Description
#	
#	Reads in a series of double precision numbers as user input
#	into to 2D array
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array base address(integer) (IN)
#	$sp+4	array height(integer) (IN)
#	$sp+8	array width(integer) (IN)
###########################################################
#		Register Usage
#	$t0		array base address
#	$t1		array height
#	$t2		array width
#	$t3		row index / outer-loop counter
#	$t4		column index / inner-loop counter
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9		array address calculation
###########################################################
		.data
read_matrix_prompt:		.asciiz		"Enter a double-precision number: "
###########################################################
		.text
read_matrix:
# load arguments off the stack
	lw $t0, 0($sp)			# load array base address off the stack
	lw $t1, 4($sp)			# load array height off the stack
	lw $t2, 8($sp)			# load array width off the stack

	li $t3, 0				# $t3 = outer-loop counter = 0

read_matrix_outer_loop:
	bge $t3, $t1, read_matrix_outer_loop_end

	li $t4, 0				# $t4 = inner-loop counter = 0

read_matrix_inner_loop:
	bge $t4, $t2, read-matrix_inner_loop_end

#################################################
# calculate index address
#   i   =   b + s * (e * k + n')
#   b   -   base, $t0
#   s   -   element size, 8 (8 bytes per double)
#   e   -   height, $t1
#   k   -   column index, $t3
#   n'  -   row index, $t4
#   i   -   index address, $t9 (to be calculated)
#################################################
	mul $t9, $t4, $t1		# $t9 = inner-loop counter * array height
	add $t9, $t9, $t3		# $t9 = (inner-loop counter * array height) + outer-loop counter
	sll $t9, $t9, 3			# $t9 = 8 bytes(for double-precision) * (inner-loop counter * array height) + outer-loop counter
	add $t9, $t0, $t9		# $t9 = array base address + 8 bytes(for double-precision) * (inner-loop counter * array height) + outer-loop counter

	li $v0, 4				# prompt for input
	la $a0, read_matrix_prompt
	syscall

	li $v0, 7				# read in user input (double)
	syscall

	s.d $f0, 0($t9)			# store double into the array

	addiu $t4, $t4, 1		# increment inner-loop counter

	b read_matrix_inner_loop

read_matrix_inner_loop_end:
	addiu $t3, $t3, 1		# increment outer-loop counter

	b read_matrix_outer_loop

read_matrix_outer_loop_end:

read_matrix_end:
	li $a0, 10				# print a new line character
	li $v0, 11
	syscall

	jr $ra					# return to calling location
###########################################################
###########################################################
#		print_matrix Subprogram
#
#		Subprogram Description
#
#	Prints each value of a 2-dimensional array to the console
#	in table format; i.e. each row in the array should be printed
#	on  a seperate line
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array base address (integer) (IN)
#	$sp+4	array height (integer) (IN)
#	$sp+8	array width (integer) (IN)
###########################################################
#		Register Usage
#	$t0		array base address
#	$t1		array height
#	$t2		array width
#	$t3		row index
#	$t4		column index
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9		array address calculation
###########################################################
		.data
print_matrix_space:		.asciiz "\t"
print_matrix_newline:	.asciiz	"\n"
###########################################################
		.text
print_matrix:
# load arguments off the stack
	lw $t0, 0($sp)			# load array nase address off the stack
	lw $t1, 4($sp)			# load array height off the stack
	lw $t2, 8($sp)			# load array width off the stack

	li $t3, 0				# $t3 = outer loop counter = 0

print_matrix_outer_loop:
	bge $t3, $t1, print_matrix_end 

	li $t4, 0				# $t4 = inner loop counter = 0

print_matrix_inner_loop:
	bge $t4, $t2, print_matrix_inner_loop_end

	mul $t9, $t4, $t1		# $t9 = column index * heigh
	add $t9, $t9, $t3		# $t9 = $t9 + row index
	sll $t9, $t9, 3			# $t9 = $t9 * 4
	add $t9, $t0, $t9		# $t9 = $t9 + $t0

	li $v0, 7				# print double 				
	l.d $f12, 0($t9)
	syscall

	li $v0, 4				# print a string
	la $a0, print_matrix_space
	syscall

	addi $t4, $t4, 1		# increment inner loop counter

	b print_matrix_inner_loop

print_col_matrix_inner_loop_end:
	li $v0, 4				# print new line
	la $a0, print_matrix_newline
	syscall

	addi $t3, $t3, 1		# increment outer loop counter

	b print_matrix_outer_loop

print_matrix_end:
	li $v0, 4				# print new line
	la $a0, print_matrix_newline
	syscall

	jr $ra	#return to calling location
###########################################################
###########################################################
#		transpose_matrix Subprogram
#
#		Subprogram Description
#
#	First, it dynamically allocates a matrix of double precision
#	(the same size as the original ouput) using the allocate_matrix.
#	Then it will transpose the input from the original matrix.
#	Finally, it returns the base address, height, and width of
# 	the transposed matrix.
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array base address (integer) (IN)
#	$sp+4	array height (integer) (IN)
#	$sp+8	array width (integer) (IN)
#	$sp+12	array base address of TRANSPOSED matrix (integer) (OUT)
#	$sp+16 	array height of transposed matrix (
###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text

	jr $ra	#return to calling location
###########################################################
###########################################################
#		print_sub_matrix Subprogram
#
#		Subprogram Description
#
#	Prints a submtraix of the TRANSPOSED matrix. The submatrix
#	is a matrix derived from the original matrix by removing the
#	given row and column. 
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp		array base address (integer) (IN)
#	$sp+4	array height (integer) (IN)
#	$sp+8	array width (integer) (IN)
#	$sp+12	row to exclude (integer) (IN)
#	$sp+16	column to exclude (integer) (IN)
###########################################################
#		Register Usage
#	$t0
#	$t1
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text

	jr $ra	#return to calling location
###########################################################
