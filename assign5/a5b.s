




                             // Number of arguments
                             // Values of the argument
//


	 .text
output: .string "%s %d%s is in %s\n"                 // Prints out: "w19 w20, year"
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
win:	.string "Winter"
spr:	.string	"Spring"
sum:	.string "Summer"
fall:	.string "Fall"

	.data
months: .dword  jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
suffix: .dword  st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st

    	.balign 4                                       // Alligns text



    	.global main                                // Make visible to OS
main:	stp x29, x30, [sp, -16]!
	mov x29, sp

	mov w21, w0
	mov x22, x1
	
//	mov w23, 1
//	mov w24, 2
	
	cmp w21, 3
	b.ne error

	ldr w0, [x22, 8] 
	bl  atoi				// convert string to int
    	mov w19, w0
	
	cmp     w19, 12                           // if w19 >12
    	b.gt    error                               // ... error
    	cmp     w19, 0                            // if w19 < 0
    	b.le    error 
	

	ldr w0, [x22, 16]
        bl  atoi                                // convert string to int
        mov w20, w0

        cmp     w20, 31                           // if w19 >12
        b.gt    error                               // ... error
        cmp     w20, 0                            // if w19 < 0
        b.le    error


Winterif:
	cmp w19, 3
	b.gt Elif1

	cmp w20, 20
	b.gt Elif1
Winter:
	ldr x0, =output

        sub w19, w19, 1

        adrp x26, months
        add x26, x26, :lo12:months
        ldr w1, [x26, w19, SXTW 2]

        mov w2, w20

        sub w20, w20, 1

        adrp x26, suffix
        add x26, x26, :lo12:suffix
        ldr w3, [x26, w20, SXTW 2]

        adrp x4, win
        add x4, x4, :lo12:win

        bl printf

	b done

Elif2:
	cmp w19, 6
	b.gt SummerElif
	cmp w20, 20
	b.gt SummerElif
Spring:
	ldr x0, =output

        sub w19, w19, 1

        adrp x26, months
        add x26, x26, :lo12:months
        ldr w1, [x26, w19, SXTW 2]

        mov w2, w20

        sub w20, w20, 1

        adrp x26, suffix
        add x26, x26, :lo12:suffix
        ldr w3, [x26, w20, SXTW 2]


        adrp x4, spr
        add x4, x4, :lo12:spr

        bl printf

	b done
SummerElif:
	cmp w19, 9
        b.gt FallElif

        cmp w20, 20
        b.gt FallElif
Summer:
        ldr x0, =output

        sub w19, w19, 1

        adrp x26, months
        add x26, x26, :lo12:months
        ldr w1, [x26, w19, SXTW 2]

        mov w2, w20

        sub w20, w20, 1

        adrp x26, suffix
        add x26, x26, :lo12:suffix
        ldr w3, [x26, w20, SXTW 2]

        adrp x4, sum
        add x4, x4, :lo12:sum

        bl printf
	
	b done
FallElif:
	cmp w19, 12
        b.ne else
if:
	b Fall	

else:
        cmp w20, 20
        b.gt Winter
Fall:
	ldr x0, =output

        sub w19, w19, 1

        adrp x26, months
        add x26, x26, :lo12:months
        ldr w1, [x26, w19, SXTW 2]

        mov w2, w20

        sub w20, w20, 1

        adrp x26, suffix
        add x26, x26, :lo12:suffix
        ldr w3, [x26, w20, SXTW 2]

        adrp x4, fall
        add x4, x4, :lo12:fall

        bl printf

	b done

done:
	ldp x29, x30, [sp], 16
	ret

error:
	stp x29, x30, [sp, -16]
        ldr x0, =errorstr
        bl printf
	ldp x29, x30, [sp], 16
        ret
	
