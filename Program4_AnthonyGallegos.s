###########################################################
#       Program 4
#
#   Name: Anthony Gallegos
#   Date: 04/16/2021
#
#		Program Description
# The following program is a rudimentary ordering system. The user will
# be prompted for a number greater than zero to create an array of double
# precision. It will then read in prices greater than zero to fill the array.
# It will then print the sum of all the numbers in the array.

###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
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
main:
### create_array start ###
    addi $sp, $sp, -4       # allocate space on stack for return address
    sw $ra, 0($sp)          # store return address on to the stack

    addi $sp, $sp, -8       # allocate space on stack for arguments OUT

    jal create_array        # call subprogram

    lw $t0, 0($sp)          # load array basee address off the stack
    lw $t1, 4($sp)          # load array length off the stack
    addi $sp, $sp, 8        # deallocate space from the stack

    lw $ra, 0($sp)          # load return address off the stack
    addi $sp, $sp, 4        # deallocate space from the stack

### create_array end ###

## print_array start ###
    addi $sp, $sp, -4       # allocate space on the stack for the return address
    sw $ra, 0($sp)          # store return address on to the stack

    addi $sp, $sp, -8       # allocate space to save values
    sw $t0, 0($sp)          # save array base address on to the stack
    sw $t1, 4($sp)          # save array length on to the stack

    addi $sp, $sp, -8       # allocate space for 2 arguments IN
    sw $t0, 0($sp)          # store array base address on to the stack
    sw $t1, 4($sp)          # store array length on to the stack

    jal print_array         # call subprogram

    addi $sp, $sp, 8        # deallocate space from stack for arguments

    lw $t0, 0($sp)          # load array base address off the stack
    lw $t1, 4($sp)          # load array length off the stack
    addi $sp, $sp, 8        # deallocate space for saving

    lw $ra, 0($sp)          # load return address off the stack
    addi $sp, $sp, 4        # deallocate space used for return address

### print_array end ###

	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#       create_array Subprogram
#
#		Subprogram Description
# Inputs a number grater than 0 from the user, then uses two
# subprograms to allocate an array of that size and fill it with user input.
# It will then call allocate_Array after obtaining a valid array length, and
# then use the length and returned base address to call read_array to prompt
# the user for values. Once both actions have been complete, it sends back
# both the array base address and the length as arguments back to main.

###########################################################
#		Arguments In and Out of subprogram
#
#	$sp   array base address (integer) (OUT)
#	$sp+4 array length (integer) (OUT)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 Holds array base address
#	$t1 Holds array size
###########################################################
		.data
create_array_prompt_p: .asciiz "Please enter the array size (greater than 0): "
create_array_error_p:  .asciiz "Invalid, array size should be positive!\n"
###########################################################
		.text
create_array:

create_array_prompt:
    li $v0, 4                       # print prompt for user input
    la $a0, create_array_prompt_p
    syscall

    li $v0, 5                       # read user input
    syscall

    bgtz $v0, create_array_allocate # branch to create_array_allocate if input > 0

    li $v0, 4
    la $a0, create_array_error_p    # otherwise print error msg
    syscall

    b create_array_prompt           # branch back to the prompt again

create_array_allocate:
    move $t1, $v0                   # $t1 = array length = $v0

    addi $sp, $sp, -4               # allocate space on the stack to store
    sw $ra, 0($sp)                  # the return address

    addi $sp, $sp, -4               # allocate space on the stack to save
    sw $t1, 0($sp)                  # the array length

    addi $sp, $sp, -8               # allocate space on the stack for the arguments
    sw $t1, 0($sp)                  # IN: array length | OUT: array base address

    jal allocate_array              # call subprogram

# load argument OUT off the stack
    lw $t0, 4($sp)                  # load array base address off the stack
    addi $sp, $sp, 8                # deallocate space for arguments

    lw $t1, 0($sp)                  # load array length off the stack
    addi $sp, $sp, 4                # deallocate space for saving

    lw $ra, 0($sp)                  # load return address off the stack
    addi $sp, $sp, 4                # deallocate space from the stack for return address

create_array_read_array:
    addi $sp, $sp, -4               # allocate space on the stack for the return address
    sw $ra, 0($sp)                  # store return address on the stack

    addi $sp, $sp, -8               # allocate space on the stack to save
    sw $t0, 0($sp)                  # save array base address on the stack
    sw $t1, 4($sp)                  # save array length on the stack

    addi $sp, $sp, -8               # allocate space on the stack for arguments IN
    sw $t0, 0($sp)                  # store array base address on the stack
    sw $t1, 4($sp)                  # store array length on the stack

    jal read_array                  # call subprogram
    
    addi $sp, $sp, 8                # deallocate space from stack for arguments

    lw $t0, 0($sp)                  # load array base address off the stack
    lw $t1, 4($sp)                  # load array length off the stack
    addi $sp, $sp, 8                # deallocate space for saving

    lw $ra, 0($sp)                  # load return address off the stack
    addi $sp, $sp, 4                # deallocate space for return address

create_array_end:
    sw $t0, 0($sp)                  # store array base address on to the stack
    sw $t1, 4($sp)                  # store array length on to the stack

	jr $ra	                        # return to calling location
###########################################################
###########################################################
#       allocate_array Subprogram
#
#		Subprogram Description
# Creates a dynamic array of double precision numbers using the
# given length
#

###########################################################
#		Arguments In and Out of subprogram
#
#	$sp   array length (integer) (IN)
#	$sp+4 array base address (integer) (OUT)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 Holds the array base address
#	$t1 Holds the array length
###########################################################
		.data

###########################################################
		.text
allocate_array:
# load arguments off the stack
    lw $t1, 0($sp)              # load the array length off the stack

    sll $a0, $t1, 3             # $a0 <- array length * 2^3
    li $v0, 9
    syscall                     # allocate array using system call 9

    move $t0, $v0               # $t0 = $v0(array base address)

allocate_array_end:
    sw $t0, 4($sp)              # store the array base address onto the stack

	jr $ra	                    # return to calling location
###########################################################
###########################################################
#       read_array Subprogram
#
#		Subprogram Description
# Reads in a series of double precision numbers greater than
# zero as user input into the given array, discarding any
# invalid input.
#

###########################################################
#		Arguments In and Out of subprogram
#
#	$sp   array base address (integer) (IN)
#	$sp+4 array length (integer) (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 Holds array base address
#	$t1 Holds array length
###########################################################
		.data
read_array_prompt_p:      .asciiz "Enter a price: "
###########################################################
		.text
read_array:
# load arguments off the stack
    lw $t0, 0($sp)              # load array base address off the stack
    lw $t1, 4($sp)              # load array length off the stack

read_array_loop:
    blez $t1, read_array_end    # while $t1 > 0

    li $v0, 4                   # prompt for double
    la $a0, read_array_prompt_p
    syscall

    li $v0, 7                   # read double
    syscall
    
    s.d $f0, 0($t0)             # store double onto the array
    
    addi $t0, $t0, 8            # increment array index
    addi $t1, $t1, -1           # decrement count

    b read_array_loop           # loop back to the beginning

read_array_end:
	jr $ra	                    # return to calling location
###########################################################
###########################################################
#       print_array Subprogram
#
#		Subprogram Description
# prints each value of an array to the console in a readable
# format, starting from index 0
#

###########################################################
#		Arguments In and Out of subprogram
#
#	$sp   array base address (integer) (IN)
#	$sp+4 array length (integer) (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
###########################################################
		.data
print_array_prompt_p:       .asciiz "Shopping cart: "
print_array_space_p:        .asciiz " "
###########################################################
		.text
print_array:
# load arguments off the stack
    lw $t0, 0($sp)              # load array base address off the stack
    lw $t1, 4($sp)              # load array length off the stack

    li $v0, 4
    la $a0, print_array_prompt_p
    syscall

print_array_loop:
    blez $t1, print_array_end

    l.d $f12, 0($t0)            # load array value into $f12

    li $v0, 3                   # print double
    syscall

    li $v0, 4
    la $a0, print_array_space_p
    syscall

    addi $t0, $t0, 8            # increment array index
    addi $t1, $t1, -1           # decrement counter

    b print_array_loop          # loop back to the beginning

print_array_end:
	jr $ra	                    # return to calling location
###########################################################
###########################################################
#       get_shipping Subprogram
#
#		Subprogram Description
# The shipping cost will be a flatt rate of $5.95, but if the total
# cost of the order is greater than or equal to $100, shipping is free
#

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
#	$a2
#	$a3
#	$v0
#	$v1
#	$sp  total cost of
#	$sp+4
#	$sp+8
#	$sp+12
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

