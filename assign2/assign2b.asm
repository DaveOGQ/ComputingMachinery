// File assign2b.asm
// Author: David Oti-George
// Date: October 10, 2022
// Description: Reverses the hexidecimal x and prints out both the original and the reversed


out_str:        .string "original: 0x%08x  reversed: 0x%08x\n"  // creates a label and defines the string containing
                                                                // the original and reversed
out_str2:       .string "original: 0b%032b reversed: 0b%032b\n" // creates a label  for the binary form of the first
                                                                // String
		.balign 4					// Makes sure the following instruction's address is 
								// divisible by 4
		.global main					// Ensures that the label "main" is visible to the 
								// linker
main:
	
		stp	x29, x30, [sp,-16]!			// Save FP and LR to the stack
		mov	x29, sp					// Set FP to the Stack Pointer

define(x, w19)
define(y, w20)
define(t1, w21)
define(t2, w22)
define(t3, w23)
define(t4, w24)

		mov	x, 0x7F807F80				// Sets the x value to 0x7F807F80
step1:								// label for step 1 
		and	t1, x, 0x55555555			// sets t1 value to x & 0x55555555
		lsl	t1, t1, 1				// sets t2 value to (x & 0x55555555) << 1
		
		lsr	t2, x, 1				// sets t2 to x >> 1
		and 	t2, t2, 0x55555555			// sets t2 to (x >> 1) & 0x55555555
		orr	y, t1, t2				// sets y to t1 || t2
		
		ldr	w0, =out_str				// loads out_str to w0
		mov	w1, x					// sets argument 1
		mov	w2, y					// sets argument 2
		bl	printf
step2:								// label for step 2
		and	t1, y, 0x33333333			// sets t1 to y & 0x33333333
		lsl	t1, t1, 2				// sets t1 to ( 0x33333333) << 2
		
		lsr	t2, y, 2				// sets t2 to y >> 2
		and	t2, t2, 0x33333333			// sets t2 to (y >> 2) & 0x33333333

		orr     y, t1, t2				// sets y to t1 || t2

		ldr   	w0, =out_str				// loads out_str to w0
                mov     w1, x					// sets argument 1
                mov     w2, y					// sets argument 2
                bl      printf	
step3:								// label for step 3
		and	t1, y, 0x0F0F0F0F			// sets t2 to y & 0x0F0F0F0F
		lsl	t1, t1, 4				// sets t2 to (y & 0x0F0F0F0F) 	
		
		lsr	t2, y, 4				// sets t2 to y >> 4
		and 	t2, t2, 0x0F0F0F0F			// sets t2 to (y >> 4) & 0x0F0F0F0F

		orr	y, t1, t2				// sets  y to t1 || t2

		ldr     w0, =out_str				// loads out_str to w0
                mov     w1, x					// sets argument 1
                mov     w2, y					// sets argument 2 
                bl      printf					
step4:
		lsl	t1, y, 24				// sets t1 to y << 24

		and	t2, y, 0xFF00				// sets t2 to y & 0xFF00
		lsl	t2, y, 8				// sets t2 to (y & 0xFF00) << 8
		
		lsr	t3, y, 8				// sets t3 to y >> 8
		and	t3, t3, 0xFF00				// sets t3 to (y >> 8) & 0xFF00

		lsr	t4, y, 24				// sets t4 to y >> 24

		orr	y, t1, t2				// sets y to t1 || t2
		orr	y, y, t3				// sets y to t1 || t2 || t3
		orr     y, y, t4				// sets y to t1 || t2 || t3 || t4

		ldr     w0, =out_str				// loads out_str to w0
                mov     w1, x					// sets argument 1
                mov     w2, y					// sets argument 2
                bl      printf
		
		ldr     w0, =out_str2                            // loads out_str to w0
                mov     w1, x                                   // sets argument 1
                mov     w2, y                                   // sets argument 2
                bl      printf
		
		ldp	x29, x30, [sp], 16			// Restore the stack
		ret						// return to os
