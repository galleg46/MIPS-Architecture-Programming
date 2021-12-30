###########################################################
#		Program 02
#   Name: Anthony Gallegos
#   Date: 02/28/2021
#
#       Program Description:
# The following program will add the values of two arrays together incrementally to
# form a new array that contains the sums. All arrays will be printed out to the
# console when complete, but the summed-up array will be printed backwards.
#
# The program will start with a static array of eleven fixed integers:
# [9, 18, 3, 8, 11, 6, 14, 1, 10, 4, 14]
###########################################################
#		Register Usage
#	$t0     dynamic_array base address
#	$t1     sum_array base address
#	$t2
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9     temp register
###########################################################
		.data
static_array_p:         .asciiz "Static array: "
dynamic_array_p:        .asciiz "\nDynamic array: "
array_backwards_p:      .asciiz "\nBackwards: "
newline_p:              .asciiz "\n"

static_array:           .word 9, 18, 3, 8, 11, 6, 14, 1, 10, 4, 14
dynamic_array:          .word 0
sum_array:              .word 0
###########################################################
		.text
main:
    li $v0, 4               # print string "Static array: "
    la $a0, static_array_p
    syscall
    
    la $a0, static_array    # a0 = base address of the static array
    li $a1, 11              # a1 = 11 -> array length

    jal print_array         # call print_array

    li $v0, 4
    la $a0, newline_p
    syscall

    li $a0, 11              # $a0 = 11 -> array length
    
    li $v0, 9               # dynamically allocate space for an array
    sll $a0, $a0, 2
    syscall

    move $t0, $v0           # $t0 = base address of new array

    la $t9, dynamic_array   # $t9 = dynamic array address
    sw $t0, 0($t9)          # store new base address into dynamic_array

    move $a0, $t0           # move dynamic_array address to $a0
    li $a1, 11              # $a1 = 11

    jal read_array          # call read_array

    li $v0, 4               # print string "Dynamic array: "
    la $a0, dynamic_array_p
    syscall

    la $a0, dynamic_array   # $a0 = address of the variable dynamic_array
    lw $a0, 0($a0)          # $a0 = base address of dynamic_array
    li $a1, 11              # $a1 = array length

    jal print_array         # call print_array

    la $a0, static_array    # $a0 = array base address of variable static_array
    
    la $a1, dynamic_array   # $a1 = address of the variable dynamic_array
    lw $a1, 0($a1)          # $a1 = base address of dynamic_array
    
    li $a2, 11              # $a2 = array length

    jal sum_arrays          # call sum_arrays

    move $t1, $v0           # move the sum array into $t1

    la $t9, sum_array       # $t9 = sum_array address
    sw $t1, 0($t9)          # store $t1 (base address) into $t9

    li $v0, 4               # print string "Backwards: "
    la $a0, array_backwards_p
    syscall

    la $a0, sum_array       # $a0 = sum_array address
    lw $a0, 0($a0)          # $a0 = sum_array base address
    li $a1, 11              # $a1 = array length

    jal print_backwards     # call print_backwards

main_end:
	li $v0, 10		        #End Program
	syscall
###########################################################
###########################################################
#       read_array Subprogram
#
#		Description:
# reads in non-negative numbers (i.e. must be >= 0) as user input
# into an array.
#
# The subprogram will take two arguements IN and none OUT:
# IN: array base address, array length
# OUT: none
#
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0: array base address (IN)
#	$a1: array length (IN)
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0: array base address
#	$t1: array length
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
read_array_prompt_p:    .asciiz "Enter a non-negative number: "
read_array_error_p:     .asciiz "Input should be a non-negative.\n"
###########################################################
		.text
read_array:
    move $t0, $a0       # $t0 = array base address
    move $t1, $a1       # $t1 = array length

read_array_input:
    blez $t1, read_array_end    # end loop if $t1 <= 0

    li $v0, 4
    la $a0, read_array_prompt_p
    syscall

    li $v0, 5                   # read user input
    syscall

    bgtz $v0, read_array_valid  # branch if $v0 > 0

    li $v0, 4
    la $a0, read_array_error_p
    syscall

    b read_array_input

read_array_valid:
    sw $v0, 0($t0)              # store user input into array

    addi $t0, $t0, 4            # increment array position
    addi $t1, $t1, -1           # decrement counter
    b read_array_input          # loop back

read_array_end:
	jr $ra	                    #return to calling location
###########################################################
###########################################################
#       print_array Subprogram
#
#		Description:
# Prints each value of an array to the console in a readable
# format, starting from index 0.
#
# The subprogram will take two arguements IN and none OUT:
# IN: array base address, array length
# OUT: none
#
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0: array base address (IN)
#	$a1: array length (IN)
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0: array base address
#	$t1: array length
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
print_array_space:      .asciiz " "
###########################################################
		.text
print_array:
    move $t0, $a0       # $t0 = array base address
    move $t1, $a1       # $t1 = array length

print_array_loop:
    blez $t1, print_array_end       # branch to end if $t1 <= 0

    li $v0, 1                       # read integer
    lw $a0, 0($t0)                  # load value from array into $a0
    syscall

    li $v0, 4
    la $a0, print_array_space
    syscall

    addi $t0, $t0, 4                # increment array position
    addi $t1, $t1, -1               # decrement counter

    b print_array_loop

print_array_end:
	jr $ra	                        #return to calling location
###########################################################
###########################################################
#       sum_arrays Subprogram
#
#		Description:
# Dynamically allocates an array of eleven integers. Then it iterates
# through each array simultaneously, adding together the values of the
# arrays that were passed in as arguments. The sum of the two numbers (one from each array)
# should be placed in the newly created array at the same index.
#
# The subprogram will take three arguements IN and one OUT:
# IN: static array base address, dynamic array base address, array length
# OUT: base address of array sums
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0: static array base address (IN)
#	$a1: dynamic array base address (IN)
#	$a2: array length (IN)
#	$a3
#	$v0: base address of array sums (OUT)
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0: static array base address
#	$t1: dynamic array base address
#	$t2: array length
#	$t3: base address of the summed array
#	$t4: static array value
#	$t5: dynamic array value (also the sum)
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data

###########################################################
		.text
sum_arrays:
    move $t0, $a0       # $t0 = static array base address
    move $t1, $a1       # $t1 = dynamic array base address
    move $t2, $a2       # $t2 = array length

    li $v0, 9           # allocate space in memory for new array
    sll $a0, $t2, 2     # $a0 = $t2 * 2^2
    syscall             # $v0 = new array base address

    move $t3, $v0       # move new array base address into $t3

sum_arrays_loop:
    blez $t2, sum_arrays_end    #branch to end if $t2 <= 0

    lw $t4, 0($t0)      # $t4 = value from static_array
    lw $t5, 0($t1)      # $t5 = value from dynamic_array

    add $t5, $t4, $t5   # $t5 = $t4 + $t5

    sw $t5, 0($t3)      # storing summed value into new array ($t3 = $t5)

    addi $t0, $t0, 4    # increment static_array position
    addi $t1, $t1, 4    # increment dynamic_array position
    addi $t3, $t3, 4    # increment sum array position
    addi $t2, $t2, -1   # decrement counter

    b sum_arrays_loop
    
sum_arrays_end:
	jr $ra	            #return to calling location
###########################################################
###########################################################
#       print_backwards Subprogram
#
#		Description:
# Prints out each value of an array to the console in a readable
# format, starting from index n - 1, where n = the length of the array
#
# The subprogram will take two arguements IN and none OUT:
# IN: array base address, array length
# OUT: none
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$a0: array base address (IN)
#	$a1: array length (IN)
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp
#	$sp+4
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0: array base address
#	$t1: array length
#	$t2: (last index - 1)
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
print_backwards_space:      .asciiz " "
###########################################################
		.text
print_backwards:
    move $t0, $a0       # $t0 = array base address
    move $t1, $a1       # $t1 = array length

    addi $t2, $t1, -1   # $t2 = $t1 - 1
    sll $t2, $t2, 2     # $t2 = $t2 * 4

    add $t0, $t0, $t2   # $t0 = $t0 + $t2

print_backwards_loop:
    blez $t1, print_backwards_end   # brancj to the end if $t1 <= 0

    li $v0, 1                       # print int
    lw $a0, 0($t0)                  # $a0 = value in array at position $t0
    syscall

    li $v0, 4                       # print space
    la $a0, print_backwards_space
    syscall

    addi $t0, $t0, -4                # decrement array position
    addi $t1, $t1, -1                # decrement counter

    b print_backwards_loop

print_backwards_end:
	jr $ra	#return to calling location
###########################################################
