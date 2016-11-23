prog: main.o names.o
	g++ main.o names.o -o prog


names.o: names.cpp name1.h name2.h
	g++ names.cpp -c

main.o: main.cpp name1.h name2.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
