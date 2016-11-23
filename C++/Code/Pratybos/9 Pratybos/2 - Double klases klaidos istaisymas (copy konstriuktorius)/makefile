prog: main.o Double.o
	g++ main.o Double.o -o prog

Double.o: Double.cpp Double.h
	g++ Double.cpp -c

main.o: main.cpp Double.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
