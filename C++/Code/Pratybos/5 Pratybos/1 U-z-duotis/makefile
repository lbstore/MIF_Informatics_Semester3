prog: main.o myclass.o
	g++ main.o myclass.o -o prog

myclass.o: myclass.cpp myclass.h
	g++ myclass.cpp -c

main.o: main.cpp myclass.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
