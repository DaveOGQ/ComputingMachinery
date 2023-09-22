run:
	m4 a5a.asm > a5a.s
	gcc -c a5aMain.c 
	as a5a.s -o a5a.o
	gcc a5aMain.o a5a.o -o exec
	./exec
run2:
	m4 a5b.asm > a5b.s
	as a5b.s -o a5b

