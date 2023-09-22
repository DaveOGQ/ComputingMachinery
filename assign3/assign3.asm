// File: assign3.asm
// Author: David.Oti_George
// Date: October 19, 2022
// Description: Utilizes the stack as an array to store unsorted random numbers (0-255), 
// prints out the values in the array then sorts the array using a bubble sort,
// before printing out the sorted array.


fp .req x29
lr .req x30
define(i, w19)
define(j, w20)
define(j_sub, w21)
define(temp, w22)
define(v1, w23)
define(v2, w24)
define(array_location, x25)


element_size = 4
array_length = 40
array_size = element_size * array_length
i_size = 4
j_size = 4
temp_location = -4
i_location = 16
j_location = 20 
alloc = -(16 + i_size + j_size + array_size) & -16
dealloc = -alloc


array_str:	.string "v[%d]: %d\n"
sorted_str:	.string "\nSorted array:\n"
		.balign 4
		.global main
main:
		stp fp, lr, [sp, alloc]! 			//save FP and LR to the stack
		mov fp, sp					//set FP to the stack address
		
		add array_location, fp, 24			//set the base adress for the array
		
		mov i, 0					//i=0
		str i, [fp, i_location]  			//save i to stack
loop_test:	
		ldr i, [fp, i_location]				//load i from memory
		cmp i, array_length				
		b.eq after_loop					//i = 40, skip loop_body
loop_body:	
		bl  rand					//generate random #
		and w0, w0, 0xFF				//limit random to 256

		str w0, [array_location, i, SXTW 2]		//store to index i in memory
				

		ldr w0, =array_str				//load str
		ldr w1, [fp, i_location]			//arg1
		ldr w2, [array_location, i, SXTW 2]		//arg2
		bl printf					//print

		add i, i, 1					//i++
		str i, [fp, i_location]				//save to stack

		b loop_test					//branch to loop test
				
after_loop:
		mov i, 39					//i = 39
		str i, [fp, i_location]				//save i to stack

outer_loop_test:
		ldr i, [fp, i_location]				//loads i from memory
		cmp i, 0			
		b.lt after_outer_loop				//i <= 0, skip outer_loop_body
outer_loop_body:
		mov j, 1					//j = 1
		str j, [fp, j_location]				//save j to stack
inner_loop_test:
		ldr i, [fp, i_location]				//load i from memory
		ldr j, [fp, j_location]				//load j from memory
		cmp j, i				
		b.gt after_inner_loop				//j > i, skip inner_loop_body
inner_loop_body:
		ldr v1, [array_location, j, SXTW 2]		//v[j] (array_location + (index j) * 4)

		sub j_sub, j, 1
		ldr v2, [array_location, j_sub, SXTW 2]		//v[j-1] (array_location + (index j-1) * 4)

		cmp v1, v2					
		b.ge next					//v[j] >= v[j-1], skip if
if:
		add sp, sp, -4 & -16				//allocate memory for temp
		
		mov temp, v2					//temp = v[j-1]
		str temp, [fp, temp_location]			//save temp to stack
		
		mov v2, v1					//v[j-1] = v[j]
		str v2, [array_location, j_sub, SXTW 2]		//save v[j] to stack (array_location + (index j-1) * 4)

		ldr v1, [fp, temp_location]			//v[j] = temp, load temp from memory to v[j]
		str v1, [array_location, j, SXTW 2]		//save v[j] to stack (array_location + (index j) * 4)
                
		add sp, sp, 16					//deallocate memory for temp
next:
		ldr j, [fp, j_location]				//load j from memory
		add j, j, 1					//j++
		str j, [fp, j_location]				//save j to memory
		b inner_loop_test				//branch to inner_loop_test
after_inner_loop:
		ldr i, [fp, i_location]				//load i from memory
                sub i, i, 1					//i--
                str i, [fp, i_location]				//save i to the stack
		b outer_loop_test				//branch to outer loop test
after_outer_loop:  
		ldr w0, =sorted_str				//load sorted_str
		bl  printf					//print
		
		mov i, 0					//i = 0
		str i, [fp, i_location]				//save i to memory
loop_test2:
                ldr i, [fp, i_location]				//load i from memory
                cmp i, 40					
                b.eq after_loop2				//i = 40, skip loop_body2
loop_body2:
                ldr w0, =array_str				//load str
                ldr w1, [fp, i_location]			//arg1
                ldr w2, [array_location, i, SXTW 2]		//arg2
                bl printf					//print

                add i, i, 1					//i++
                str i, [fp, i_location]				//save i to memory

                b loop_test2					//branch to loop_lest2

after_loop2:
		ldp fp, lr, [sp], dealloc			//Restore Stack
		ret						//retrn to OS
