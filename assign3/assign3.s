// File: assign3.asm
// Author: David.Oti_George
// Date: October 19, 2022
// Description: Utilizes the stack as an array to store unsorted random numbers (0-255), 
// prints out the values in the array then sorts the array using a bubble sort,
// before printing out the sorted array.


fp .req x29
lr .req x30









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
		
		add x25, fp, 24			//set the base adress for the array
		
		mov w19, 0					//w19=0
		str w19, [fp, i_location]  			//save w19 to stack
loop_test:	
		ldr w19, [fp, i_location]				//load w19 from memory
		cmp w19, array_length				
		b.eq after_loop					//w19 = 40, skip loop_body
loop_body:	
		bl  rand					//generate random #
		and w0, w0, 0xFF				//limit random to 256

		str w0, [x25, w19, SXTW 2]		//store to index w19 in memory
				

		ldr w0, =array_str				//load str
		ldr w1, [fp, i_location]			//arg1
		ldr w2, [x25, w19, SXTW 2]		//arg2
		bl printf					//print

		add w19, w19, 1					//w19++
		str w19, [fp, i_location]				//save to stack

		b loop_test					//branch to loop test
				
after_loop:
		mov w19, 39					//w19 = 39
		str w19, [fp, i_location]				//save w19 to stack

outer_loop_test:
		ldr w19, [fp, i_location]				//loads w19 from memory
		cmp w19, 0			
		b.lt after_outer_loop				//w19 <= 0, skip outer_loop_body
outer_loop_body:
		mov w20, 1					//w20 = 1
		str w20, [fp, j_location]				//save w20 to stack
inner_loop_test:
		ldr w19, [fp, i_location]				//load w19 from memory
		ldr w20, [fp, j_location]				//load w20 from memory
		cmp w20, w19				
		b.gt after_inner_loop				//w20 > w19, skip inner_loop_body
inner_loop_body:
		ldr w23, [x25, w20, SXTW 2]		//v[w20] (x25 + (index w20) * 4)

		sub w21, w20, 1
		ldr w24, [x25, w21, SXTW 2]		//v[w20-1] (x25 + (index w20-1) * 4)

		cmp w23, w24					
		b.ge next					//v[w20] >= v[w20-1], skip if
if:
		add sp, sp, -4 & -16				//allocate memory for w22
		
		mov w22, w24					//w22 = v[w20-1]
		str w22, [fp, temp_location]			//save w22 to stack
		
		mov w24, w23					//v[w20-1] = v[w20]
		str w24, [x25, w21, SXTW 2]		//save v[w20] to stack (x25 + (index w20-1) * 4)

		ldr w23, [fp, temp_location]			//v[w20] = w22, load w22 from memory to v[w20]
		str w23, [x25, w20, SXTW 2]		//save v[w20] to stack (x25 + (index w20) * 4)
                
		add sp, sp, 16					//deallocate memory for w22
next:
		ldr w20, [fp, j_location]				//load w20 from memory
		add w20, w20, 1					//w20++
		str w20, [fp, j_location]				//save w20 to memory
		b inner_loop_test				//branch to inner_loop_test
after_inner_loop:
		ldr w19, [fp, i_location]				//load w19 from memory
                sub w19, w19, 1					//w19--
                str w19, [fp, i_location]				//save w19 to the stack
		b outer_loop_test				//branch to outer loop test
after_outer_loop:  
		ldr w0, =sorted_str				//load sorted_str
		bl  printf					//print
		
		mov w19, 0					//w19 = 0
		str w19, [fp, i_location]				//save w19 to memory
loop_test2:
                ldr w19, [fp, i_location]				//load w19 from memory
                cmp w19, 40					
                b.eq after_loop2				//w19 = 40, skip loop_body2
loop_body2:
                ldr w0, =array_str				//load str
                ldr w1, [fp, i_location]			//arg1
                ldr w2, [x25, w19, SXTW 2]		//arg2
                bl printf					//print

                add w19, w19, 1					//w19++
                str w19, [fp, i_location]				//save w19 to memory

                b loop_test2					//branch to loop_lest2

after_loop2:
		ldp fp, lr, [sp], dealloc			//Restore Stack
		ret						//retrn to OS
