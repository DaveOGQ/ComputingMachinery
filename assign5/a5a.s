//File:a5a.asm
//Author:David Oti-George
//Date:November 23, 2022
//Description:Contains Methods for a5aMain, incluidng enqueue(), dequeue(), queueFull(), queueEmpty() and display()  





QUEUESIZE = 8
MODMASK = 0x7
FALSE = 0
TRUE = 1

//Global variables
	.bss
	.global queue
queue:	.skip  4*QUEUESIZE

	.data
	.global head										//Make visible for seperate compilation
head: 	.word -1										//int head = -1

	.global tail										//Make visible for seperate compilation
tail:	.word -1										//int tail = -1

//
		.text
overflow:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"
underflow:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
empty:		.string "\nEmpty queue\n"
content:	.string "\nCurrent queue contents:\n"
queuehead:	.string " <-- head of queue"
queuetail:	.string	" <-- tail of queue"
space:		.string "\n"
arg_str:	.string " %d"
		.balign 4
//-------------------------------------------------------------------
//			void Enqueue()
//-------------------------------------------------------------------
		.global enqueue									//Make visible for seperate compilation
enqueue:	stp x29, x30, [sp,-16]!								//Allocate memory
		mov x29, sp
		
		mov w19, w0									//Move input w19 in w0 to register w19

		bl queueFull									//...
		cmp w0, TRUE									//...queueFull?
		b.ne enqueue_next								
enqueue_full:											//if queueFull()
		ldr x0, =overflow								//arg1 overflow string
		bl printf									//print
		b enqueue_end									//return
enqueue_next:											
		bl queueEmpty									//...
                cmp w0, TRUE									//...queueEmpty?
		b.ne enqueue_empty_else
enqueue_empty:											//if queueEmpty()
		adrp x20, head									//...
		add x20, x20, :lo12:head							//head = 0
		str wzr, [x20]									//...
		
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//tail = 0 
                str wzr, [x20]									//...
		
		b	enqueue_next2
enqueue_empty_else:										//else(not empty )
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
		ldr w21, [x20]									//...

		add w21, w21, 1									//tail++
		and w21, w21, MODMASK								//tail = tail++ & MODMASK
		
		str w21, [x20]									//store tail
enqueue_next2:	
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
                ldr w21, [x20]									//...
	
		adrp x20, queue									//...
		add x20, x20, :lo12:queue							//queue[head] = w19
		str w19, [x20, w21, SXTW 2]							//

enqueue_end:
		ldp x29,x30, [sp], 16								//Deallocate memory
		ret										//return
//-------------------------------------------------------------------
//                      int Dequeue()
//-------------------------------------------------------------------
value_s = 16
value_size = 4
dalloc = -(16 + value_size) & -16
ddealloc = -dalloc
		.global dequeue									//make visible for separate compilation
dequeue:  	stp x29, x30, [sp, dalloc]!							//allocate memory 
		mov x29, sp
		
		bl queueEmpty									//...
		cmp w0, TRUE									//...queueEmpty
		b.ne 	dequeue_next				
dequeue_empty:											//if queueEmpty()
		ldr x0, =underflow								//arg1 underflow string
		bl printf									//print
		mov w0, -1									//-1 to return
		b	dequeue_end								//return
dequeue_next:
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

                adrp x20, queue									//...
                add x20, x20, :lo12:queue							//w19 = queue[head]
                ldr w19, [x20, w21, SXTW 2]							//...

		str w19, [x29, value_s]							//store w19 to stack
				
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//...load tail
                ldr w22, [x20]									//...
			
		cmp w21, w22									// head == tail?
		b.ne	dequeue_else
dequeue_if:											//if(head == tail)
		mov w26, -1									

		adrp x20, head									//...
                add x20, x20, :lo12:head							//head = -1
                str w26, [x20]									//...

                adrp x20, tail									//...
                add x20, x20, :lo12:tail							//tail = -1
                str w26, [x20]									//

		b 	beforeDequeueEnd							//return
dequeue_else:
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

                add w21, w21, 1									//head++
                and w21, w21, MODMASK								//head = head++ & MODMASK

                str w21, [x20]									//store head
beforeDequeueEnd:
		ldr x0, [x29, value_s]								//load w19 from stack to return 
dequeue_end:	

		ldp x29, x30, [sp], ddealloc							//Deallocate Memory
		ret										//return
	
//-------------------------------------------------------------------
//                      int queueFUll()
//-------------------------------------------------------------------
		.global queueFull								//make visible for seperate compilation
queueFull:	stp x29, x30, [sp, -16]!								//allocate memory
		mov x29, sp									

		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
                ldr w21, [x20]									//...

		add w21, w21, 1									//tail++
		and w21, w21, MODMASK								//tail = tail++ & MODMASK	
		
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w22, [x20]									//...
		
		cmp w21, w22									//head == tail?
		b.ne 	queueFull_else
queueFull_if:											//if (head == tail)
		mov w0, TRUE									//...
		b	queueFull_end								//return TRUE
queueFull_else:											//else
		mov w0, FALSE									//return FALSE
queueFull_end:
                ldp x29, x30, [sp], 16								//Deallocate Memory
                ret										//return
//-------------------------------------------------------------------
//                      int queueEmpty()
//-------------------------------------------------------------------
		.global queueEmpty								//make visible to seperate compilation
queueEmpty:	stp x29, x30, [sp,-16]!								//allocate memory
		mov x29, sp

		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head 
                ldr w21, [x20]									//...

		cmp w21, -1									//head == -1?
		b.ne	queueEmpty_else
queueEmpty_if:											//if (head == -1)
		mov w0, TRUE									//...
                b 	queueEmpty_end								//return TRUE
queueEmpty_else:										//else
		mov w0, FALSE									//return FALSE
		
queueEmpty_end:
		ldp x29, x30, [sp], 16								//Deallocate memory
                ret										//return


//-------------------------------------------------------------------
//                      void Display()
//-------------------------------------------------------------------



i_s = 16
j_s = 20
count_s = 24
element_size = 4
dpalloc = -(16 + (element_size * 3)) & -16
dpdealloc = -dpalloc
		.global display									//make visible for seperate compilation
display:	stp x29, x30, [sp,dpalloc]!							//Allocate memory
		mov x29, sp
		
		bl queueEmpty									//...
		cmp w0, TRUE									//...queueEmpty?
		b.ne  display_next1
display_if1:											//if queueEmpty()
		ldr x0, =empty									//arg1 empty string
		bl printf									//print
		b  display_end
display_next1:											
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

                adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
                ldr w22, [x20]									//...
		
		sub w25, w22, w21								//w25 = tail - head 
		add w25, w25, 1								//w25++

		str w25, [x29, count_s]							//store w25 to stack
	
		cmp w25, 0									//w25 <= 0
		b.gt display_next2								

display_if2:											//if (w25 <= 0)
		add w25, w25, QUEUESIZE							//w25 = w25 + QUEUESIZE
             	str w25, [x29, count_s]							//store w25 to stack

display_next2:
		ldr x0, =content								//agr1 content string
		bl printf									//print
		
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...
		
		mov w23, w21									//w23 = head
		str w23, [x29, i_s]								//store w23 to stack

		mov w24, 0									//w24 = 0
		str w24, [x29, j_s]								//store w24 to stack
		
		ldr w25, [x29, count_s]							//load w25 from stack

		b test										//loop test		
top:					
		ldr w23, [x29, i_s]								//load w23 from stack

		adrp x20, queue									//...
                add x20, x20, :lo12:queue							//load queue[w23]
                ldr w21, [x20, w23, SXTW 2]							//...

		ldr x0, =arg_str								//arg1 arg_str string
		mov w1, w21									//arg2 queue[w23]
		bl printf									//print
		
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

		cmp w23, w21									//... w23 == head ?
		b.ne 	display_next3
display_if3:
		ldr x0, =queuehead								//arg1 queuehead string
		bl printf									//print
display_next3:
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
                ldr w21, [x20]									//...

		cmp w23, w21									//... w23 == tail?
		b.ne display_next4								
display_if4:											//if (w23 == tail)
		ldr x0, =queuetail								//arg1 queuetail string
		bl printf									//print
display_next4:	
		ldr x0, =space									//arg1 space string
		bl printf									//print
		
		add w23, w23, 1									//w23++
		and w23, w23, MODMASK								//w23 = w23++
		str w23, [x29, i_s]								//store w23 to the stack

		add w24, w24, 1									//w24++
		str w24, [x29, j_s] 								//store w24 to the stack
test:		
		ldr w24, [x29, j_s]								//load w24 from the stack
		cmp w24, w25									//...
		b.lt  top									//continue loop if left w24 less than w25
display_end:
		ldp x29, x30, [sp], dpdealloc							//Deallocate memory
		ret										//return
