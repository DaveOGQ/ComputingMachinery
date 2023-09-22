define(fp, x29)
define(lr, x30)
define(argc, w21)                            // Number of arguments
define(argv,x22)                             // Values of the argument
define(month, w23)
define(day, w24)
define(m_i, w25)
define(d_i, w26)
         .text
output:     .string "%s %d%s is in %s\n"     // Prints out: "month day(suffix) is in season"
errorstr:   .string "usage: a5b mm dd\n"     // Error message if format is entered wrong
jan:    .string "January"
feb:    .string "Febuary"
mar:    .string "March"
apr:    .string "April"
may:    .string "May"
jun:    .string "June"
jul:    .string "July"
aug:    .string "August"
sep:    .string "September"
oct:    .string "October"
nov:    .string "November"
dec:    .string "December"
st:     .string "st"
nd:     .string "nd"
rd:     .string "rd"
th:     .string "th"
win:    .string "Winter"
spr:    .string "Spring"
sum:    .string "Summer"
fall:   .string "Fall"

        .data
months: .dword  jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
suffix: .dword  st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st


	.text	
        .balign 4                                   	// Alligns text
        .global main                                	// Make visible to OS
main:   stp fp, lr, [sp, -16]!				// allocate memory	
        mov fp, sp

        mov argc, w0					// move argc c from w0
        mov argv, x1					// move argv from x1

	mov m_i, 1					// month index for argv
	mov d_i, 2					// day index for argv
	
        cmp argc, 3					// if argc != 3
        b.ne error					// ... error

        ldr x0, [argv, m_i, SXTW 3]			// arg1 string month from argv
        bl  atoi                                    	// convert string to int
        mov month, w0					// return integer month

        cmp     month, 12                           	// if month >12
        b.gt    error                               	// ... error
        cmp     month, 0                            	// if month <=  0
        b.le    error					// ... error


        ldr x0, [argv, d_i, SXTW  3]			// arg1 string day from argv
        bl  atoi                                	// convert string to int
        mov day, w0					// return integer day

        cmp     day, 31                           	// if day > 31
        b.gt    error                               	// ... error
        cmp     day, 0                            	// if day <= 0
        b.le    error					// ...error


Winterif:
        cmp month, 3					// if month is past march ... not winter
        b.gt Elif1

	cmp month, 3					// if month is jan or feb ... winter
        b.ne Winter

        cmp day, 20					// if day is greater than 20 and month is march ... spring
        b.gt Elif1
Winter:
        ldr x0, =output					//arg1 output string

        sub month, month, 1				//month - 1 for correct index

        adrp x26, months				//...
        add x26, x26, :lo12:months			//ag2 string for month from months
        ldr x1, [x26, month, SXTW 3]			//...

        mov w2, day					//arg3 day

        sub day, day, 1					//day - 1 for correct index	

	adrp x26, suffix				//...
        add x26, x26, :lo12:suffix			//arg4 string for suffix from suffix
        ldr x3, [x26, day, SXTW 3]			//...

        adrp x4, win					//...
        add x4, x4, :lo12:win				//arg5 winter string

        bl printf					//print

        b done						

Elif1:
        cmp month, 6					// if month is past june ... not spring
        b.gt Elif2

	cmp month, 6					// if month is april  or may ... spring
	b.ne Spring

        cmp day, 20					// if day is greater than 20 and month is june ... summer
        b.gt Elif2
Spring:
        ldr x0, =output					//arg1 output string

        sub month, month, 1				//month -1 for corrct index

        adrp x26, months				//...
        add x26, x26, :lo12:months			//arg2 string for month from months
        ldr x1, [x26, month, SXTW 3]			//...

        mov w2, day					//arg3 day

        sub day, day, 1					//day - 1 for correct index

        adrp x26, suffix				//...
        add x26, x26, :lo12:suffix			//arg4 string for suffix from suffix
        ldr x3, [x26, day, SXTW 3]			//...


        adrp x4, spr					//...
        add x4, x4, :lo12:spr				//arg5 spring string

        bl printf					//print

        b done
Elif2:
        cmp month, 9					// if month is past september ... not summer
        b.gt Elif3	

	 cmp month, 9					// if month is in july or august ... summer
        b.ne Summer

        cmp day, 20					// day is greater than 20 and month is september ...fall
        b.gt Elif3
Summer:
        ldr x0, =output					//arg1 output string

	sub month, month, 1				//month - 1 for correct index

        adrp x26, months				//...
        add x26, x26, :lo12:months			//arg2 motnh from months	
        ldr x1, [x26, month, SXTW 3]			//...

        mov w2, day					//arg3 day

        sub day, day, 1					//day - 1 for correct index

        adrp x26, suffix				//...
        add x26, x26, :lo12:suffix			//arg4 string for suffix from suffix
        ldr x3, [x26, day, SXTW 3]			//...

        adrp x4, sum					//...
        add x4, x4, :lo12:sum				//summer string

        bl printf					//print

        b done
Elif3:
        cmp month, 12					//if month is october or november ... fall
        b.ne Fall

        cmp day, 20					// if day is greater than 20 and month is december ... winter
        b.gt Winter
Fall:
        ldr x0, =output					//arg1 output string

        sub month, month, 1				//month - 1 for correct index

        adrp x26, months				//...
        add x26, x26, :lo12:months			//arg2 string for month from months
        ldr x1, [x26, month, SXTW 3]			//...

        mov w2, day					//arg3 day

        sub day, day, 1					//day - 1 for correct index

        adrp x26, suffix				//...
        add x26, x26, :lo12:suffix			//arg4 string for suffix from suffix
        ldr x3, [x26, day, SXTW 3]			//...
		
        adrp x4, fall					//...
        add x4, x4, :lo12:fall				//arg5 fall string

        bl printf					//print

        b done
error:
        ldr x0, =errorstr				//arg1 error string
        bl printf					//print
done:
        ldp fp, lr, [sp], 16				//Deallocate memory
        ret						//return

