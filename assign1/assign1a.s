// File assign1a.s
// Author: David Oti-George
// Date: September 22, 2022
// Description:
// Loops through the integers x on the interval of -10 <= x <= 10 for a function y = -4x^4 + 301x^2 + 56x - 103  
// and print to the screen the x and y values for the current largest maximun on each iteration of the loop.

max_x_y:	.string "(%d,%d) with Max (%d,%d)\n"		// This creates a label and defines the string containing
								// the maximum x and y values in memory
		.balign 4					// Makes sure the following instruction's address is 
								// divisible by 4
		.global main					// Ensures that the label "main" is visible to the 
								// linker
main:		
		stp	x29, x30, [sp,-16]!			// Save FP and LR to the stack
		mov	x29, sp					// Set FP to the Stack Pointer

		mov	x19, -10				// Sets the x value to 10
		mov	x23, 0					// sets the output max y value intially to 0
		mov	x27, 0					// sets the output max x value intially to 0

while_test:
                cmp     x19, #10				// compares the incrementing x value to 10
                b.gt	done					// if the incrementing x value is greater than 10 the loop ends
								// and branches to the label "done" and ends the program
while_body:
		mov	x21, 0					// resets x21 the final y result to 0 for each iteration of the
								// loop
		mov	x20, 0					// resets the result of calcutating -4x^4 and +56x
		mov 	x22, 0					// resets the result of calculating  301x^2
		mov	x24, -4					// puts -4 into a register to allow multiplication
		mov	x25, 301				// puts 301 into a register to allow multiplication
		mov	x26, 56					// puts 56  into a register to allow multiplication
		mul	x20, x19, x19				// multiples to create x^2
		mul     x20, x20, x19				// multiplies to create x^3
		mul	x20, x20, x19				// multiplies to create x^4
		mul	x20, x20, x24				// multiplies to create -4x^4
		mov  	x21, x20 				// sets x21 to -4x^4
		mul 	x22, x19, x19				// multiples to create x^2
		mul	x22, x22, x25				// multiples to create 301x^2
		add  	x21, x21, x22				// adds to create -4x^4 + 301x^2 in x21 
		mov	x20, 0					// resets x20 to 0 to allow for the calculation of +56x
		mul 	x20, x19, x26				// multiples to create 56x then adds that to x21 to create 
								// -4x^4 + 301x^2 + 56x in x21
		add	x21, x21, x20				// adds +56x to x21
		sub  	x21, x21, 103				// subtracts 103 from x21 to create a final result of
								// x21 = -4x^4 + 301x^2 + 56x -103 for the current iterative x
								// value

                cmp     x23, 0                                  // checks that x23 is empty (equal to 0)
                b.eq	update					// updates the current "empty" max_y to the current y
                
		cmp     x23, x21                                // compares the current y value to the max y value
                b.ge    next                                  	// braches to next if the max x value is already greater than
                                                                // or equal to iterative x value

update:                                                         // label "update" contains the code that updates the current
                                                                // maximum x,y values
                mov     x23, x21                                // updates the max y value with the new max y value
                mov     x27, x19                                // updates the max x value with the new max x value

next:								// label "next" contains the code that prints the
								// max x and y values
								
		adrp 	x0, max_x_y				// this line and the next set the first argument to prinf
                add 	x0, x0, :lo12:max_x_y			
		
		mov	x1, x19					// set argument 1
		mov	x2, x21					// set argument 2
                mov  	x3, x27					// set argument 3
                mov  	x4, x23					// set argument 4
	
		bl 	printf					// call printf
 		add     x19, x19, 1                             // increments the x value by 1,

		b	while_test				// branches back to "while_test" to check the loop condition
								// before executing the while loop again

done:								// label "done" signalling the end of the program

		ldp	x29, x30, [sp], 16			// Restore the stack
		ret						// return to os
