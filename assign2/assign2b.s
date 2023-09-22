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








		mov	w19, 0x7F807F80				// Sets the w19 value to 0x7F807F80
step1:								// label for step 1 
		and	w21, w19, 0x55555555			// sets w21 value to w19 & 0x55555555
		lsl	w21, w21, 1				// sets w22 value to (w19 & 0x55555555) << 1
		
		lsr	w22, w19, 1				// sets w22 to w19 >> 1
		and 	w22, w22, 0x55555555			// sets w22 to (w19 >> 1) & 0x55555555
		orr	w20, w21, w22				// sets w20 to w21 || w22
		
		ldr	w0, =out_str				// loads out_str to w0
		mov	w1, w19					// sets argument 1
		mov	w2, w20					// sets argument 2
		bl	printf
step2:								// label for step 2
		and	w21, w20, 0x33333333			// sets w21 to w20 & 0x33333333
		lsl	w21, w21, 2				// sets w21 to ( 0x33333333) << 2
		
		lsr	w22, w20, 2				// sets w22 to w20 >> 2
		and	w22, w22, 0x33333333			// sets w22 to (w20 >> 2) & 0x33333333

		orr     w20, w21, w22				// sets w20 to w21 || w22

		ldr   	w0, =out_str				// loads out_str to w0
                mov     w1, w19					// sets argument 1
                mov     w2, w20					// sets argument 2
                bl      printf	
step3:								// label for step 3
		and	w21, w20, 0x0F0F0F0F			// sets w22 to w20 & 0x0F0F0F0F
		lsl	w21, w21, 4				// sets w22 to (w20 & 0x0F0F0F0F) 	
		
		lsr	w22, w20, 4				// sets w22 to w20 >> 4
		and 	w22, w22, 0x0F0F0F0F			// sets w22 to (w20 >> 4) & 0x0F0F0F0F

		orr	w20, w21, w22				// sets  w20 to w21 || w22

		ldr     w0, =out_str				// loads out_str to w0
                mov     w1, w19					// sets argument 1
                mov     w2, w20					// sets argument 2 
                bl      printf					
step4:
		lsl	w21, w20, 24				// sets w21 to w20 << 24

		and	w22, w20, 0xFF00				// sets w22 to w20 & 0xFF00
		lsl	w22, w20, 8				// sets w22 to (w20 & 0xFF00) << 8
		
		lsr	w23, w20, 8				// sets w23 to w20 >> 8
		and	w23, w23, 0xFF00				// sets w23 to (w20 >> 8) & 0xFF00

		lsr	w24, w20, 24				// sets w24 to w20 >> 24

		orr	w20, w21, w22				// sets w20 to w21 || w22
		orr	w20, w20, w23				// sets w20 to w21 || w22 || w23
		orr     w20, w20, w24				// sets w20 to w21 || w22 || w23 || w24

		ldr     w0, =out_str				// loads out_str to w0
                mov     w1, w19					// sets argument 1
                mov     w2, w20					// sets argument 2
                bl      printf
		
		ldr     w0, =out_str2                            // loads out_str to w0
                mov     w1, w19                                   // sets argument 1
                mov     w2, w20                                   // sets argument 2
                bl      printf
		
		ldp	x29, x30, [sp], 16			// Restore the stack
		ret						// return to os
