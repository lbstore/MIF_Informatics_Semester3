prog: main.o
	g++ main.o -o prog

NamespaceMath.h: NamespaceInt.h
NamespaceCalculation.h: NamespaceInt.h

main.o: main.cpp NamespaceCalculation.h NamespaceMath.h
	g++ main.cpp -c

clean:
	rm -f *.o *~
