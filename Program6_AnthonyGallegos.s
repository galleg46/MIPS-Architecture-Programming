###########################################################
#		Program 6
#
#	Name: Anthony Gallegos
#	Date:05/02/2021
#
#		Program Description
#
#	The following program will dynamically allocate an array of data
#	structures and ask the user to fill it out. It will then print
#	the data structure into the console and do the following:
#		- Calculate the sum and average of all items
#		- Find the items that have the min value and max value
#		- Print the sum, average, and information (name, price, count)
#		  of the min and max item values
#
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
main:


	li $v0, 10		#End Program
	syscall
###########################################################
###########################################################
#		allocate_structure Subprogram
#
#		Subprogram Description
#
#	prompt the user for an array length greater than zero and
# 	dynamically allocate an array of data 

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
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
#		Subprogram Description

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
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
#		Subprogram Description

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
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
#		Subprogram Description

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
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
#		Subprogram Description

###########################################################
#		Arguments In and Out of subprogram
#
#	$a0
#	$a1
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

