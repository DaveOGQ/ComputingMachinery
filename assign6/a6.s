//File:a6.asm
//Author:David Oti-George
//Date:November 30, 2022
//Description:Take input from  a binary file, convert degrees into radians and calculate sin and cos for all terms in the file









	.data
pidiv12:.double 0r1.57079632679489661923
f90:	.double 0r90.0
f0:	.double 0r0.0
absval: .double 0r1.0e-10

		.text
openfile:	.string "Opening File: %s\n"
endfile:	.string "End of file.\n"
header_str:	.string "| 	x	|	sin(x)		|	cos(x) 		|\n"
x_str:		.string "     	%.2f	"
cos_str:	.string "	%.10f	\n"
sin_str:	.string "	%.10f	"
cmd_err:	.string	"Usage: ./a6 <filename.bin>"
not_found_err:	.string "File: %s not found.\n"
range_err:	.string "Input %f out of range.\n"
			
		.balign 4
		.global main
buf_size= 8
alloc = -(16 + buf_size) & -16
dealloc = - alloc
buf_s = 16

main:	stp x29, x30, [sp, alloc]!	//allocate memory
	mov x29, sp	

	mov w20, w0	//# of arguments
	mov x21, x1	//argument array

	cmp w20, 2	//...
	b.eq next	//check for correct number of arguments

	ldr x0, =cmd_err	//print arguemnts error
	bl printf

	b done		

next:	
	ldr x0, =openfile		
	ldr x1, [x21, 8]	//print opening file string with filename 
	bl printf
 
	mov w0, -100		//first arg
	ldr x1, [x21, 8]	//filename
	mov w2, 0		//read only
	mov w3,0		//not used
	mov x8, 56		//Openat I/O request
	svc 0			//call system function
	mov w22, w0		//file descriptor
	
	cmp w22, 0		//error check file, error if w22 = -1
	b.ge next1

	ldr x0, =not_found_err		
	ldr x1, [x21, 8]	//print not found error with filename
	bl printf
	b done	

next1:
	ldr x0, =header_str	//print header string
	bl printf
	
	add x23, x29, buf_s	//calculate base address for the buffer

open_ok:
	
	mov w0, w22		//first arg
	mov x1, x23		//buffer
	mov w2, buf_size	//buffer size
	mov x8, 63		//Read I/O request
	svc 0			//call system function
	
	mov x24, x0		//x24
	
	cmp x24, buf_size	//check the numeber of bytes read is equal to 8
	b.ne	end_of_file

	ldr x0, =x_str
	ldr d0, [x23]		//print x
	bl printf
	
	//sin(x)
	ldr d0, [x23]		//x
	bl sin			//calculate sin(x)

	ldr x0, =sin_str
	bl printf		//print sin(x) string
	
	//cos(x)
	ldr d0, [x23]		//x
	bl cos			//calculate cos(x)

	ldr x0, =cos_str	
	bl printf		//print cos(x)

	b 	open_ok		

end_of_file:

	ldr x0, =endfile	
	bl printf		//print end file string 

	mov w0, w22
	mov x8, 57		//close file
	svc 0

done:
	ldp x29, x30, [sp], dealloc	//deallocate memmory
	ret				//return



sin: 	stp x29, x30, [sp, -16]!	//allocate memory
	mov x29, sp

	fmov d8, d0		//d8 = x

	adrp x9, absval
	add x9, x9,:lo12:absval		//load abolute value limit for the terms
	ldr d9, [x9]//d10

	adrp x9, pidiv12
	add x9, x9, :lo12:pidiv12	//load pi/2
	ldr d10, [x9]
	
	adrp x9, f90
	add x9, x9, :lo12:f90		//load 90.0
	ldr d11, [x9]
				
	adrp x9, f0
	add x9, x9, :lo12:f0		//load 0.0
	ldr d12, [x9]
	
	fdiv d10, d10, d11		//(pi/2)/90 = pi/180

	fmul d8, d8, d10		//radian (x) = (pi/180)x
	
	mov w9, 1	//term number

	fmov d13, 1.0	//n = 1.0

	fmov d11, 1.0	//sign(-1 or +1)
sinloop:
	cmp w9, 1
	b.gt sincalcterm	//if not the first term do calculations

	fmov d14, d8	//else start with d8 as the first term

	b	sinaddterm		//add the first term to the sum
	
sincalcterm:
	fmul d14, d14, d8	//(previous term)x
	fmul d14, d14, d8	//(previous term)x^2
	
	fdiv d14, d14, d13	//(previous term)/n
	fmov d15, 1.0
	fsub d13, d13, d15	//n-1
	fdiv d14, d14, d13	//(previous term)/(n(n-1))
	fadd d13, d13, d15	//n
	fneg d11, d11 		//negate sign
	fmul d14, d11, d14	//-(current term) to alternate sign
sinaddterm:			
	fadd d12, d12, d14	//add term to sum
	add w9, w9, 1		//increace term number
	fmov d7,2.0		
	fadd d13, d13, d7	//n += 2


	adrp x9,f0
	add x9, x9,:lo12:f0	//load 0.0
	ldr d15, [x9]

	fcmp d14, d15		// term negative?
	b.lt sinnegcheck	
sinposcheck:			//check limit with positive term
	fcmp d14, d9		
	b.lt	sinend		//if term less than limit...end

	b	sinloop


sinnegcheck:			//check limit with negative term
	fneg d14, d14		//make term positive

	fcmp d14, d15	
	b.gt sinloop		//if term greater than limit ... continue

sinend:
	fmov d0, d12		//return sum in d0

	ldp x29, x30, [sp], 16	//deallocate memmory
	ret			//return




cos:    stp x29, x30, [sp, -16]!	//allocate memory
        mov x29, sp

        fmov d8, d0	//d8 = x	

        adrp x9, absval
        add x9, x9,:lo12:absval		//load absolute value limit for the terms
        ldr d9, [x9]

        adrp x9, pidiv12
        add x9, x9, :lo12:pidiv12	//load pi/2
        ldr d10, [x9]

        adrp x9, f90
        add x9, x9, :lo12:f90		//load 90.0
        ldr d11, [x9]

        adrp x9, f0
        add x9, x9, :lo12:f0		//load 0.0
        ldr d12, [x9]//d15

        fdiv d10, d10, d11		//(pi/2)/90 = pi/180

        fmul d8, d8, d10		//radian (x) = (pi/180)x

        mov w9, 1       //term number

        fmov d13, d12   //n  = 0.0

	fmov d11, 1.0	//sign(-1 or +1)
cosloop:
        cmp w9, 1
        b.gt coscalcterm	//if not the firsterm do calculations

        fmov d14, 1.0		//else start with 1.0 as the first term

        b       cosaddterm

coscalcterm:
        fmul d14, d14, d8	//(previous term)x
        fmul d14, d14, d8	//(previous term)x^2
        
	fdiv d14, d14, d13 	//(previous term)/n
	fmov d15, 1.0
        fsub d13, d13, d15	//n-1
        fdiv d14, d14, d13	//(previous term)/n(n-1)
        fadd d13, d13, d15	//n
        fneg d11, d11		//negate sign
	fmul d14, d14, d11	//-(current term) to alternate sign
cosaddterm:
        fadd d12, d12, d14	//add term to sum
        add w9, w9, 1		//increase term number
        fmov d7,2.0
        fadd d13, d13, d7	//n += 2


        adrp x9,f0
        add x9, x9,:lo12:f0	//load 0.0
        ldr d15, [x9]

        fcmp d14, d15		//term negative?
        b.lt cosnegcheck
cosposcheck:			//check limit with positive term
        fcmp d14, d9
        b.lt    cosend		//if term less that limit ... end

        b      cosloop


cosnegcheck:			//check limit with negative term 
        fneg d14, d14		//make term psoitive

        fcmp d14, d15		
        b.gt cosloop		//if term greater than limit ... continue

cosend:
        fmov d0, d12		//return sum in d 0

        ldp x29, x30, [sp], 16	//deallocate memory
        ret			//return



