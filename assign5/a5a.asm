//File:a5a.asm
//Author:David Oti-George
//Date:November 23, 2022
//Description:Contains Methods for a5aMain, incluidng enqueue(), dequeue(), queueFull(), queueEmpty() and display()  
define(fp, x29)
define(lr,x30)
define(value,w19)
define(neg1, w26)

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
enqueue:	stp fp, lr, [sp,-16]!								//Allocate memory
		mov fp, sp
		
		mov value, w0									//Move input value in w0 to register value

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
		add x20, x20, :lo12:queue							//queue[head] = value
		str value, [x20, w21, SXTW 2]							//

enqueue_end:
		ldp fp,lr, [sp], 16								//Deallocate memory
		ret										//return
//-------------------------------------------------------------------
//                      int Dequeue()
//-------------------------------------------------------------------
value_s = 16
value_size = 4
dalloc = -(16 + value_size) & -16
ddealloc = -dalloc
		.global dequeue									//make visible for separate compilation
dequeue:  	stp fp, lr, [sp, dalloc]!							//allocate memory 
		mov fp, sp
		
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
                add x20, x20, :lo12:queue							//value = queue[head]
                ldr value, [x20, w21, SXTW 2]							//...

		str value, [fp, value_s]							//store value to stack
				
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//...load tail
                ldr w22, [x20]									//...
			
		cmp w21, w22									// head == tail?
		b.ne	dequeue_else
dequeue_if:											//if(head == tail)
		mov neg1, -1									

		adrp x20, head									//...
                add x20, x20, :lo12:head							//head = -1
                str neg1, [x20]									//...

                adrp x20, tail									//...
                add x20, x20, :lo12:tail							//tail = -1
                str neg1, [x20]									//

		b 	beforeDequeueEnd							//return
dequeue_else:
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

                add w21, w21, 1									//head++
                and w21, w21, MODMASK								//head = head++ & MODMASK

                str w21, [x20]									//store head
beforeDequeueEnd:
		ldr x0, [fp, value_s]								//load value from stack to return 
dequeue_end:	

		ldp fp, lr, [sp], ddealloc							//Deallocate Memory
		ret										//return
	
//-------------------------------------------------------------------
//                      int queueFUll()
//-------------------------------------------------------------------
		.global queueFull								//make visible for seperate compilation
queueFull:	stp fp, lr, [sp, -16]!								//allocate memory
		mov fp, sp									

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
                ldp fp, lr, [sp], 16								//Deallocate Memory
                ret										//return
//-------------------------------------------------------------------
//                      int queueEmpty()
//-------------------------------------------------------------------
		.global queueEmpty								//make visible to seperate compilation
queueEmpty:	stp fp, lr, [sp,-16]!								//allocate memory
		mov fp, sp

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
		ldp fp, lr, [sp], 16								//Deallocate memory
                ret										//return


//-------------------------------------------------------------------
//                      void Display()
//-------------------------------------------------------------------
define(i, w23)
define(j, w24)
define(count, w25)
i_s = 16
j_s = 20
count_s = 24
element_size = 4
dpalloc = -(16 + (element_size * 3)) & -16
dpdealloc = -dpalloc
		.global display									//make visible for seperate compilation
display:	stp fp, lr, [sp,dpalloc]!							//Allocate memory
		mov fp, sp
		
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
		
		sub count, w22, w21								//count = tail - head 
		add count, count, 1								//count++

		str count, [fp, count_s]							//store count to stack
	
		cmp count, 0									//count <= 0
		b.gt display_next2								

display_if2:											//if (count <= 0)
		add count, count, QUEUESIZE							//count = count + QUEUESIZE
             	str count, [fp, count_s]							//store count to stack

display_next2:
		ldr x0, =content								//agr1 content string
		bl printf									//print
		
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...
		
		mov i, w21									//i = head
		str i, [fp, i_s]								//store i to stack

		mov j, 0									//j = 0
		str j, [fp, j_s]								//store j to stack
		
		ldr count, [fp, count_s]							//load count from stack

		b test										//loop test		
top:					
		ldr i, [fp, i_s]								//load i from stack

		adrp x20, queue									//...
                add x20, x20, :lo12:queue							//load queue[i]
                ldr w21, [x20, i, SXTW 2]							//...

		ldr x0, =arg_str								//arg1 arg_str string
		mov w1, w21									//arg2 queue[i]
		bl printf									//print
		
		adrp x20, head									//...
                add x20, x20, :lo12:head							//load head
                ldr w21, [x20]									//...

		cmp i, w21									//... i == head ?
		b.ne 	display_next3
display_if3:
		ldr x0, =queuehead								//arg1 queuehead string
		bl printf									//print
display_next3:
		adrp x20, tail									//...
                add x20, x20, :lo12:tail							//load tail
                ldr w21, [x20]									//...

		cmp i, w21									//... i == tail?
		b.ne display_next4								
display_if4:											//if (i == tail)
		ldr x0, =queuetail								//arg1 queuetail string
		bl printf									//print
display_next4:	
		ldr x0, =space									//arg1 space string
		bl printf									//print
		
		add i, i, 1									//i++
		and i, i, MODMASK								//i = i++
		str i, [fp, i_s]								//store i to the stack

		add j, j, 1									//j++
		str j, [fp, j_s] 								//store j to the stack
test:		
		ldr j, [fp, j_s]								//load j from the stack
		cmp j, count									//...
		b.lt  top									//continue loop if left j less than count
display_end:
		ldp fp, lr, [sp], dpdealloc							//Deallocate memory
		ret										//return
