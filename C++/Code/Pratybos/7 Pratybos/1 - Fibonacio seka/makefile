prog: main.o fibonat.o
	g++ main.o fibonat.o -o prog

fibonat.o: fibonat.cpp fibonat.h
	g++ fibonat.cpp -c

main.o: main.cpp fibonat.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
