prog: main.o class.o
	g++ main.o class.o -o prog

class.o: class.cpp class.h
	g++ class.cpp -c

main.o: main.cpp class.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
