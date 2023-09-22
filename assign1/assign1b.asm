// File assign1b.asm
// Author: David Oti-George
// Date: September 22, 2022
// Description:
// Loops through the integers x on the interval of -10 <= x <= 10 for a function y = -4x^4 + 301x^2 + 56x - 103  
// and print to the screen the x and y values for the current largest maximun on each iteration of the loop.

max_x_y:	.string "(%d,%d) wuth currebnt Max(%d,%d)\n"	// This creates a label and defines the string containing
								// the maximum x and y values in memory
		.balign 4					// Makes sure the following instruction's address is 
								// divisible by 4
		.global main					// Ensures that the label "main" is visible to the 
								// linker
main:	
define(x, x19)
define(y, x20)
define(max_y, x21)
define(max_x, x22)
	
		stp	x29, x30, [sp,-16]!			// Save FP and LR to the stack
		mov	x29, sp					// Set FP to the Stack Pointer

		mov	x, -10					// Sets the x value to -10 
		mov	max_y, 0				// sets the output max y value intially to 0
		mov	max_x, 0				// sets the output max x value intially to 0
		
		b	while_test				// branches to the while_test to begin the pre-test loop
								// after the values have been updated if necessary
while_body:
		mov     y, 0					// resets x21 the final y result to 0 for each iteration of the
								// loop
		mov 	x23, 0					// resets the result of calculating  301x^2
		mov	x24, -4					// puts -4 into a register to allow multiplication
		mov	x25, 301				// puts 301 into a register to allow multiplication
		mov	x26, 56					// puts 56  into a register to allow multiplication
		mul	y, x, x					// multiplies to create x^2
		mul     y, y, x					// multiplies to create x^3
		mul	y, y, x					// multiplies to create x^4
		mul	y, y, x24				// multiplies to create -4x^4
		mul 	x23, x, x				// multiplies to create x^2
		mul	x23, x23, x25				// multiplies to create 301x^2
		add  	y, y, x23				// adds to create -4x^4 + 301x^2 in y 
		madd 	y, x, x26, y				// multiplies to create 56x then adds that to y to create 
								// -4x^4 + 301x^2 + 56x in y
		sub  	y, y, 103				// subtracts 103 from y to create a final result of
								// y = -4x^4 + 301x^2 + 56x -103 for the current iterative x
								// value

empty:								// label "empty" is a subroutine that checks that no current ma
								// y value has been added to x23 and updates it to the current 
								// x,y values
		cmp	max_y, 0				// checks that max_y is empty (equal to 0)
		b.eq	update					// branches to the update to update initial max x,y values
		
		cmp     max_y, y                                // compares the current y value to the max y value
                b.ge    next                                  	// braches to update if the max x value is less than the current
                                                                // iterative x value
update:                                                         // label "update contains code tha updates current
                                                                // maximum x,y values
                mov     max_y, y                                // updates the max y value with the new max y value
                mov     max_x, x                                // updates the max x value with the new max x value

next:								// label "next" contains the code that prints the 
								// x,y values

		ldr	x0, max_x_y				// this line and the next set the first argument to prinf			
		mov	x1, x					// set argument 1
		mov	x2, y					// set argument 2
                mov  	x3, max_x				// set argument 3
                mov  	x4, max_y				// set argument 4
	
		bl 	printf					// call printf
		add     x, x, 1                                 // increments the x value by 1, -10 would then be the first to
                                                                // be calculated for a y value
while_test:
                cmp     x, #10                          	// compares the incrementing x value to 10
                b.le	while_body                              // if the incrementing x value is less than 10 the
                                                          	// execution of the program barnches back to the top of loop


		ldp	x29, x30, [sp], 16			// Restore the stack
		ret						// return to os
