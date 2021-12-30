###########################################################
#   Name: Anthony Gallegos
#   Date: 03/19/2021
#
#   Program Description
# The following program will create an array and perform various
# tasks with it. The array length should be between 5 and 15 (inclusive).
# Once the array has been created, it will print to the console in a
# readable format. Then it will sum up all the even values contained
# in the array, returning the sum and the number of even values.
# Then it will calculate the average, then print the sum, count, and
# average.
#

###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 sum
#	$t3 total number of even numbers
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9 temp register
###########################################################
		.data
array:            .word 0
array_length:     .word 0
array_p:          .asciiz "\nArray: "
sum_p:            .asciiz "\nSum of even values: "
count_p:          .asciiz "\nCount of even values: "
average_p:        .asciiz "\nAverage: "
###########################################################
		.text
main:
    addi $sp, $sp, -4       # allocate space for return address
    sw $ra, 0($sp)          # store return address on stack

    # no registers to save

    addi $sp, $sp, -8       # allocate space for two argument OUT

    jal create_array        # call subprogram creat_array

    lw $t0, 0($sp)          # load array base address off the stack
    lw $t1, 4($sp)          # load array length off the stack
    addi $sp, $sp, 8        # deallocate space for arguments OUT

    lw $ra, 0($sp)          # load return address off the stack
    addi $sp, $sp, 4        # deallocate space for return address

    la $t9, array           # load variable address
    sw $t0, 0($t9)          # array = $t0

    la $t9, array_length    # load variable address
    sw $t1, 0($t9)          # array_length = $t1

    addi $sp, $sp, -4       # allocate space for return address
    sw $ra, 0($sp)          # store return address on to the stack

    addi $sp, $sp, -8       # allocate space for two registers to save
    sw $t0, 0($sp)          # store array base address on to the stack
    sw $t1, 4($sp)          # store array length on to the stack

    addi $sp, $sp, -8       # allocate space for two aruguments IN
    sw $t0, 0($sp)          # store array base address on to the stack
    sw $t1, 4($sp)          # store array length on to the stack

    jal print_array         # call subprogram print_array

    addi $sp, $sp, 8        # deallocate space for arguments IN

    lw $t0, 0($sp)          # load base address off the stack
    lw $t1, 4($sp)          # load array length off the stack
    addi $sp, $sp, 8        # deallocate space for saved registers

    lw $ra, 0($sp)          # load return address of the stack
    addi $sp, $sp, 4        # deallocate space for return address

    addi $sp, $sp, -4       # allocate space for return address
    sw $ra, 0($sp)          # store return address on to the stack

    addi $sp, $sp, -8       # allocate space to save
    sw $t0, 0($sp)          # store the array base address on to the stack
    sw $t1, 4($sp)          # store the array length on to the stack

    addi $sp, $sp, -16      # allocate space for two arguments IN and two OUT
    sw $t0, 0($sp)          # store the array base address on to the stack
    sw $t1, 4($sp)          # store the array length on to the stack

    jal sum_even_values     # call subprogram

    lw $t2, 8($sp)          # load the sum off the stack
    lw $t3, 12($sp)         # load the total number of even numbers off the stack
    addi $sp, $sp, 16       # deallocate space for arguments IN and Out

    li $v0, 4               # print string "Sum of even values: "
    la $a0, sum_p
    syscall

    li $v0, 1               # print the sum value
    la $a0, 0($t2)
    syscall

    li $v0, 4               # print the string "Count of even values: "
    la $a0, count_p
    syscall

    li $v0, 1               # print the count of even values integer
    la $a0, 0($t3)
    syscall

    lw $t0, 0($sp)          # load the base address off the stack
    lw $t1, 4($sp)          # load the array length off the stack
    addi $sp, $sp, 8

    lw $ra, 0($sp)          # load the return address of the stack
    addi $sp, $sp, 4        # deallocate space for the return address

    addi  $sp, $sp, -4      # allocate space for return address
    sw $ra, 0($sp)          # store return address to the stack

    addi $sp, $sp, -8       # allocate space to save
    sw $t2, 0($sp)          # store the sum to the stack
    sw $t3, 4($sp)          # store the number of even numbers to the stack

    addi $sp, $sp, -8       # allocate space for two arguments IN
    sw $t2, 0($sp)          # store the sum to the stack
    sw $t3, 4($sp)          # store the number of even numbers to the stack

    li $v0, 4               # prints string "Average: "
    la $a0, average_p
    syscall

    jal print_sum_average   # call subprogram

    addi $sp, $sp, 8        # deallocate space for arguments IN
    
    lw $t2, 0($sp)          # load the sum off the stack
    lw $t3, 4($sp)          # load the total count of even values
    addi $sp, $sp, 8        # deallocate space for stored values

    lw $ra, 0($sp)          # load the return address off the stack
    addi $sp, $sp, 4        # deallocate space for return address

main_end:
	li $v0, 10		        # End Program
	syscall
###########################################################
###########################################################
#       create_array subprogram
#
#		Description
# innputs a number between 5-15 (inclusive) from the user. Then uses two
# subprograms to allocate an array of that size and fill it with user input.
# It should call allocate_array after obtaining a valid array length, and then use
# the length and returned base address to call read_array to prompt the user for values.
# Once both actions are complete, it sends back both the array base address
# and the length as arguments back to main.
#
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp     array base address (OUT)
#	$sp+4   array length (OUT)
#	$sp+8
#	$sp+12
#
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 int 5
#	$t3 int 15
#
###########################################################
		.data
create_array_prompt_p:   .asciiz "Enter an array length between 5 and 15: "
create_array_error_p:   .asciiz "Invalid length entered!\n"
###########################################################
		.text
create_array:
    li $t2, 5                       # $t2 = 5
    li $t3, 15                      # $t3 = 15

create_array_prompt:
    li $v0, 4                       # print prompt
    la $a0, create_array_prompt_p
    syscall

    li $v0, 5                       # read integer from user
    syscall

    move $t1, $v0                   # $t1 = $v0

    blt $t1, $t2, create_array_error # branch if $t1 < $t2
    bgt $t1, $t3, create_array_error # branch id $t1 < $t3

    b create_array_allocate         # branch to allocate

create_array_error:
    li $v0, 4                       # print error prompt
    la $a0, create_array_error_p
    syscall

    b create_array_prompt           # branch to the beginning

create_array_allocate:
    addi $sp, $sp, -4               # allocate space for return address
    sw $ra, 0($sp)                  # store return address on stack

    addi $sp, $sp, -4               # allocate space for one saved register
    sw $t1, 0($sp)                  # store length on stack

    addi $sp, $sp, -8               # allocate space for one argument IN and one OUT
    sw $t1, 0($sp)                  # store length on stack

    jal allocate_array              # call subprogram allocate_array

    lw $t0, 4($sp)                  # load base address off the stack
    addi $sp, $sp, 8                # deallocate space for saved register

    lw $t1, 0($sp)                  # load length off the stack
    addi $sp, $sp, 4                # deallocate space for saved register

    lw $ra, 0($sp)                  # load the return address of the stack
    addi $sp, $sp, 4                # deallocate space for return address

create_array_read:
    addi $sp, $sp, -4               # allocate space for the return address
    sw $ra, 0($sp)                  # store the return address on the stack
    
    addi $sp, $sp, -8               # allocate space to save
    sw $t0, 0($sp)                  # store the base address onto the stack
    sw $t1, 4($sp)                  # store the array length onto the stack

    addi $sp, $sp, -8               # allocate space for two arguments IN
    sw $t0, 0($sp)                  # store the base address onto the stack
    sw $t1, 4($sp)                  # store the array length onto the stack

    jal read_array                  # call subprogram

    addi $sp, $sp, 8                # deallocate space for arguments IN and OUT

    lw $t0, 0($sp)                  # load base address off the stack
    lw $t1, 4($sp)                  # deallocate space for saved arguments
    addi $sp, $sp, 8                # dealloctae space for saved regisgters

    lw $ra, 0($sp)                  # load return address of the stack
    addi $sp, $sp, 4                # deallocate space for the return address
    
create_array_end:
    sw $t0, 0($sp)                  # send arguments OUt off the stack
    sw $t1, 4($sp)                  # store base address

	jr $ra                      	# return to calling location
###########################################################
###########################################################
#       allocate_array subprogram
#
#		Description
# creates a dynamic array of the given size
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp     array length (IN)
#	$sp+4   array base address (OUT)
###########################################################
#		Register Usage
#	$t0 array length
###########################################################
		.data

###########################################################
		.text
allocate_array:
    lw $t0, 0($sp)      # load length off the stack

    li $v0, 9           # allocare space for an array using system call 9
    sll $a0, $t0, 2      # $a0 = $t0 *4
    syscall

allocate_array_end:
    sw $v0, 4($sp)      # store base address on stack

	jr $ra	            #return to calling location
###########################################################
###########################################################
#       read_array Subprogram
#
#		Description
# Reads in a series of integers as user input into the given array.
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp     array base address (IN)
#	$sp+4   array length (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#
#	$t0 array base address
#	$t1 array length
###########################################################
		.data
read_array_prompt_p:    .asciiz "Enter an integer: "
###########################################################
		.text
read_array:
    lw $t0, 0($sp)      # load base address off the stack
    lw $t1, 4($sp)      # load length off the stack

read_array_loop:
    blez $t1, read_array_end

    li $v0, 4
    la $a0, read_array_prompt_p
    syscall

    li $v0, 5
    syscall

    sw $v0, 0($t0)

    addi $t0, $t0, 4
    addi $t1, $t1, -1

    b read_array_loop

read_array_end:
	jr $ra	#return to calling location
###########################################################
###########################################################
#       print_array Subprogram
#
#		Description
# Prints each value of an array to the console in a readable format,
# starting from index 0.
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp     array base address (IN)
#	$sp+4   array length (IN)
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
###########################################################
		.data
print_array_space:  .asciiz " "
###########################################################
		.text
print_array:
    lw $t0, 0($sp)              # load base address off the stuck
    lw $t1, 4($sp)              # load array length off the stack

print_array_loop:
    blez $t1, print_array_end   # branch to end if $t1 = 0

    li $v0, 1                   # print an integer
    lw $a0, 0($t0)              # $a0 = current array value
    syscall

    li $v0, 4                   # print a string
    la $a0, print_array_space
    syscall

    addi $t0, $t0, 4            # increment to next array position
    addi $t1, $t1, -1           # decrement

    b print_array_loop          # branch to start of loop

print_array_end:
	jr $ra	                    # return to calling location
###########################################################
###########################################################
#       sum_even_values Subprogram
#
#		Description
# Loops through the array and sums up the elements in the array
# but only includes the ones that are even. It then returns the
# sum back to main.
#
###########################################################
#		Arguments In and Out of subprogram
#
#	$sp     array base address (IN)
#	$sp+4   array length (IN)
#	$sp+8   sum of all even values in the array (OUT)
#	$sp+12  count of all even values in the array (OUT)
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1 array length
#	$t2 int 2
#	$t3 sum
#	$t4 current array value
#	$t5 remainder
#	$t6 count
###########################################################
		.data

###########################################################
		.text
sum_even_values:
    lw $t0, 0($sp)      # load base address off the stack
    lw $t1, 4($sp)      # load array length off the stack
    li $t2, 2           # $t2 = 2
    li $t3, 0           # sum = 0
    li $t6, 0           # count = 0

sum_even_values_loop:
    blez $t1, sum_even_values_end       # branch to end if $t1 <= 0

    lw $t4, 0($t0)                      # $t4 = current array position

    div $t4, $t2                        # $t4 / $t2
    mfhi $t5                            # $t5 = remainder

    bnez $t5, sum_even_values_not_even  # branch if $t5 != 0

    add $t3, $t3, $t4                   # sum = sum + $t4
    addi $t6, $t6, 1                    # count++

sum_even_values_not_even:
    addi $t0, $t0, 4                    # increment to the next array position
    addi $t1, $t1, -1                   # decrement counter

    b sum_even_values_loop              # branch to the start of the loop

sum_even_values_end:
    sw $t3, 8($sp)                      # store the sum on to the stack
    sw $t6, 12($sp)                     # store the number of even numbers on to the stack

	jr $ra	                            # return to calling location
###########################################################
###########################################################
#       print_sum_average Subprogram
#
#       Description
# Calculates the average of the even values in the array by
# dividing the sum by the count passed in, and prints the sum,
# count, and average before returning to main. If the sum and
# count are 0, it will display a message.
#
###########################################################
#        Arguments In and Out of subprogram
#
#    $sp    sum of all even values in array (IN)
#    $sp+4  count of all even values in array (IN)
#    $sp+8
#    $sp+12
###########################################################
#        Register Usage
#    $t0 sum of all even values in array
#    $t1 count of all even values in array
#    $t2 average
###########################################################
        .data
average_not_available:  .asciiz "No average to calculate!\n"
###########################################################
        .text
print_sum_average:
    lw $t0, 0($sp)                       # load the sum off the stack
    lw $t1, 4($sp)                       # load the count of even values off the stack

print_sum_average_calculation:
    blez $t0, print_sum_average_zero     # branch if sum <= 0
    blez $t1, print_sum_average_zero     # branch if count <= 0

    div $t0, $t1                         # $t0 / $t1
    mflo $t2                             # $t2 = average

    li $v0, 1                            # print average
    la $a0, 0($t2)
    syscall

    b print_sum_average_end              # branch to the end

print_sum_average_zero:
    li $v0, 4                            # print string "No averahe to calculate"
    la $a0, average_not_available
    syscall

print_sum_average_end:
    jr $ra                               # return to calling location
###########################################################
