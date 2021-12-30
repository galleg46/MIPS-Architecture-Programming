###########################################################
#   Name: Anthony Gallegos
#   Date: 02/12/21
#
#    Program Description:
# The following program will input Odd integers between [1, 25] into an array.
# Each time there is a valid input, it will add the value to a total counter.
# The program will stop once the value -1 is entered. It will then display the sum
# of all the numbers, the count, the average, and the remainder if any.
# If a value is entered that is less than -1, greater than 25, or is an even number,
# an error message will be prompted. The user will then be re-prompted to enter a value
#

###########################################################
#		Register Usage
#	$t0 holds base address of the array
#	$t1 holds the value for count
#	$t2 holds the value for sum
#	$t3 Integer average
#	$t4 remainder
#	$t5
#	$t6 value -1
#	$t7 value 25
#	$t8 value 1
#	$t9
###########################################################
		.data
input_p:        .asciiz "Enter an odd integer between 1 & 25 inclusivley: "
error_p:        .asciiz "The value given is invalid!\n"
total_P:        .asciiz "\nTotal: "
count_p:        .asciiz "\nCount: "
average_p:      .asciiz "\nInteger average: "
remainder_p:    .asciiz "Remainder: "

array:          .word 0 : 0
###########################################################
		.text
main:
    la $t0, array

read_input_loop:
    li $v0, 4
    la $a0, input_p
    syscall

    li $v0, 5
    syscall

    blez $v0, error
    

error:
    li $v0, 4
    la $a0, error_p
    syscall

    b read_input_loop


	li $v0, 10		#End Program
	syscall
###########################################################

