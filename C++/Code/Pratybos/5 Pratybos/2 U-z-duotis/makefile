prog: main.o dvd.o mystack.o
	g++ main.o dvd.o mystack.o -o prog

dvd.o: dvd.cpp dvd.h
	g++ dvd.cpp -c

mystack.o: mystack.cpp mystack.h
	g++ mystack.cpp -c

main.o: main.cpp dvd.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
