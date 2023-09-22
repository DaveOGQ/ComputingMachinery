//File: assign4.asm
//Author: David Oti-George
//Date: November 3, 2022
//Description: Creates 2 cuboids implementing the cuboid struct and then gives them a default value in new cuboid, 
//if the the cuboids are the same same the first cuboid is moved and 
//the dimensions of the second cuboid is scaled up by a factor of 4

fp .req x29									//register equates for fp
lr .req x30									//register equates for lr
		
False  = 0									
True = 1

//struct point
point_x = 0									//int x offset for struct point  
point_y = 4
									//int y offset for struct point
//stuct dimension
dim_w = 0									//int width offset for struct dimension
dim_l = 4									//int length offset for struct dimension

//struct cuboid
cuboid_origin = 0 								//struct* point offset for struct cuboid
cuboid_base = 8  								//struct* dimension offset for struct cuboid
cuboid_height = 16 								//int height offset for struct cuboid
cuboid_volume = 20								//int volume offset for struct cuboid

initial_str:    .string "Initial cuboid values:\n"
changed_str:    .string "Changed cuboid values:\n"
first_str:      .string "first"
second_str:     .string "second"
origin_str:     .string "Cuboid %s origin = (%d, %d)\n"
base_str:       .string "\tBase width = %d Base length = %d\n"
height_str:     .string "\tHeight = %d\n"
volume_str:     .string "\tVolume =%d\n\n"

                .balign 4
                .global main
//----------------------------------------------------------------------------
//                      int newCuboid()
//----------------------------------------------------------------------------
newCuboid:	stp fp, lr, [sp, -16]!  					//save FP and LR to the stack
        	mov fp, sp     							//set FP to the stack address
		
				
        	str wzr, [x8, cuboid_origin + point_x]				//c.origin.x = 0
		str wzr, [x8, cuboid_origin + point_y]				//c.origin.y = 0

		mov w9, 2			
	
		str w9, [x8, cuboid_base + dim_w]				//c.base.width = 2
		str w9, [x8, cuboid_base + dim_l]				//c.base.length = 2

		mov w9, 3

		str w9, [x8, cuboid_height]					//c.height = 3

        	ldr w10, [x8, cuboid_base + dim_w]				//load c.base.width	
        	ldr w11, [x8, cuboid_base + dim_l]				//load c.base.length 
        	ldr w12, [x8, cuboid_height]					//load c.height
        	mul w13, w10, w11						//c.base.width x c.base.length
        	mul w12, w13, w12						//c.base.width x c.base.length x c.height
        	str w12, [x8, cuboid_volume]					//c.volume = c.base.width x c.base.length x c.height

        	ldp fp, lr, [sp], 16  						//Restore Stack
        	ret     							//retrn to Main()
//----------------------------------------------------------------------------
//                      int move()
//----------------------------------------------------------------------------
move:	stp fp, lr, [sp, -16]!  						//save FP and LR to the stack
        mov fp, sp     								//set FP to the stack address
	
	
	ldr w9, [x0, cuboid_origin + point_x]					//load origin.x
 	add w9, w9, w1								//origin.x += deltaX
	str w9, [x0, cuboid_origin + point_x]					//store origin x
        
	ldr w10, [x0, cuboid_origin + point_y]					//load origin.y
	add w10, w10, w2							//origin.y += deltaY
	str w10, [x0, cuboid_origin + point_y]					//store origin.y

       	ldp fp, lr, [sp], 16  							//Restore Stack
        ret     								//retrn to Main()


//----------------------------------------------------------------------------
//                      int scale()
//----------------------------------------------------------------------------
scale:	stp fp, lr, [sp, -16]! 							//save FP and LR to the stack
        mov fp, sp     								//set FP to the stack address

        ldr w9, [x0, cuboid_base + dim_w]					//load c.base.width
	mul w10, w9, w1								//c.base.width *= factor
	str w10, [x0, cuboid_base + dim_w]					//store c.base.width
	
	ldr w9, [x0, cuboid_base + dim_l]					//load c.base.length
        mul w10, w9, w1								//c.base.length *= factor
        str w10, [x0, cuboid_base + dim_l]					//store c.base.length
	
	ldr x9, [x0, cuboid_height]						//load c.height
        mul w10, w9, w1								//c.height *= factor
        str w10, [x0, cuboid_height]						//store c.height

	ldr w10, [x0, cuboid_base + dim_w]					//load c.base.width
	ldr w11, [x0, cuboid_base + dim_l]					//load c.base.length
	ldr w12, [x0, cuboid_height]						//load c.height
        mul w13, w10, w11							//c.volume = c.base.width x c.base.length
	mul w13, w13, w12							//c.volume = c.base.width x c.base.length x c.height
        str w13, [x0, cuboid_volume]						//store c.volume

        ldp fp, lr, [sp], 16  							//Restore Stack
        ret     								//return to Main()

//----------------------------------------------------------------------------
//                      int printCuboid()
//----------------------------------------------------------------------------
x24_s = 16									//offset for x24 in memory
x25_s = 24									//offset for x25 in memory
register_size = 8								//size of x24 and x25
pc_alloc = -(16 + register_size + register_size) & -16				//size of memory use for printCuboid()
pc_dealloc = -pc_alloc
printCuboid:	stp fp, lr, [sp, pc_alloc]! 					//save FP and LR to the stack
		mov fp, sp     							//set FP to the stack address
		
		str x24, [fp, x24_s]						//save x24
		str x25, [fp, x25_s]						//save x25
		
		mov x24, x0 							//move name string to x24 so it isnt overwritten 
		mov x25, x1 							//move cuboid c base address to x25 so it isnt overwritten
					
		ldr x0, =origin_str						//load origin_str
		mov x1, x24							//string argument
		ldr x2, [x25, cuboid_origin + point_x]				//load c.origin.y
		ldr x3, [x25, cuboid_origin + point_y]				//load c.origin.y
		bl printf

		ldr x0, =base_str						//load base_str
                ldr x1, [x25, cuboid_base + dim_w]				//load c.base.width
                ldr x2, [x25, cuboid_base + dim_l]				//load c.base.length
                bl printf

		ldr x0, =height_str						//load height_str
                ldr x1, [x25, cuboid_height]					//load c.height
		bl printf

		ldr x0, =volume_str						//load volume_str
                ldr x1, [x25, cuboid_volume]					//load c.volume
		bl printf

		ldr x24, [fp, x24_s]						//restore x24
                ldr x25, [fp, x25_s]						//restore x25
		
		ldp fp, lr, [sp], pc_dealloc					//Restore Stack
		ret     							//return to Main()
//----------------------------------------------------------------------------
//			int equalsize()
//----------------------------------------------------------------------------
result_s = 16									//offset for result	
result_size = 4									//size for result
e_s_alloc = -(16 + result_size) & -16						//memory required for equalSize()						
e_s_dealloc = -e_s_alloc		
equalSize:	stp fp, lr, [sp, e_s_alloc]! 					//save FP and LR to the stack
                mov fp, sp     							//set FP to the stack address
		
		mov x9, False							//result = False
		str x9, [fp, result_s]						//store result
		
		ldr x10, [x0, cuboid_base + dim_w]				//load c1.base.width
		ldr x11, [x1, cuboid_base + dim_w] 				//load c2.base.width
		
		cmp x10, x11							//c1.base.width == c2.base.width?
		b.ne endif							//skip to endif if not equal
if1:		
		ldr x12, [x0, cuboid_base + dim_l]				//load c1.base.length 				
                ldr x13, [x1, cuboid_base + dim_l]				//load c1.base.length
                
		cmp x12, x13							//c1.base.length == c2.base.length?
                b.ne endif							//skip to endif if not equal
if2:
                ldr x14, [x0, cuboid_height]					//load c1.height
                ldr x15, [x1, cuboid_height]					//load c2.height

                cmp x14, x15							//c1.height == c2.height?
                b.ne endif							//skip to endif if not equal
if3:
		mov x9, True							//result = True
                str x9, [fp, result_s]						//store result

endif:		
		ldr w0, [fp, result_s]						//load result in w register to return int result


		ldp fp, lr, [sp], e_s_dealloc  					//Restore Stack
                ret     							//return to Main()


first_size = 24									//first cuboid size
second_size = 24								//first cuboid size
first_s = 16									//first cuboid offset
second_s = 40									//second cuboid offset
alloc = -(16 + first_size + second_size) & -16					//block of memory required for both cuboids
dealloc = -alloc								
define(first_base_s, x19)
define(second_base_s, x20)
main:
		stp fp, lr, [sp, alloc]! 					//save FP and LR to the stack
		mov fp, sp							//set FP to the stack address
	
		add first_base_s, fp, first_s					//calculate base address of first cuboid
		add second_base_s, fp, second_s					//calculate base address of second cuboid

		mov x8, first_base_s						//pass base address of first into x8
		bl newCuboid							//branch to newCuboid()
gdb1:

		mov x8, second_base_s						//pass base address of second into x8
                bl newCuboid							//branch to newCuboid
gdb2:           		
		
		ldr x0, =initial_str						//load initial_r
		bl printf								

		ldr x0, =first_str						//load first_str
		mov x1, first_base_s						//pass in base address for first cuboid
		bl printCuboid							//branch to printCuboid()

		ldr x0, =second_str						//load second_str
                mov x1, second_base_s						//pass in base address for second cuboid
                bl printCuboid							//branch to printCuboid
		
		mov x0, first_base_s						//pass base address of first cuboid
		mov x1, second_base_s						//pass base address of second cuboid
		bl equalSize							//branch to eqaulSize()

		cmp w0, True							//result == True?
		b.ne endif1							//if not equal skip to endif
if:
		mov x0, first_base_s						//pass in base address for first cuboid
		mov w1, 3							//pass in 3 for deltaX
		mov w2, -6							//pass in -6 for deltaY
		bl move								//branch to move()
gdb3:
		mov x0, second_base_s						//pass in base adress for second
		mov w1, 4							//pass in  4 for factor
		bl scale							//branch to scale()
gdb4:

endif1:	
		ldr x0, =changed_str						//load changed str
		bl printf

		ldr x0, =first_str						//load first_str
                mov x1, first_base_s						//pass in base address for first cuboid
                bl printCuboid							//branch to printCuboid()

                ldr x0, =second_str						//load second_str
                mov x1, second_base_s						//pass in base address for second cuboid
                bl printCuboid							//branch to printCuboid()


		ldp fp, lr, [sp], dealloc					//Restore Stack
		ret								//retrn to OS
