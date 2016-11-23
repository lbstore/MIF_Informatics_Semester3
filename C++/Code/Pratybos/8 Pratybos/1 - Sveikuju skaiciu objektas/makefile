prog: main.o int.o
	g++ main.o int.o -o prog

int.o: int.cpp int.h
	g++ int.cpp -c

main.o: main.cpp int.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
