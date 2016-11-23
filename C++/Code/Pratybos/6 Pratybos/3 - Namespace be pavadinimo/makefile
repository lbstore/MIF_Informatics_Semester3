prog: main.o main2.o main3.o 
	g++ main.o main2.o main3.o -o prog

main2.o: main2.cpp name.h
	g++ main2.cpp -c

main3.o: main3.cpp name.h
	g++ main3.cpp -c


main.o: main.cpp name.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
