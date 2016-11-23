prog: stringStackTest.o stringStack.o myString.o
	g++ stringStackTest.o stringStack.o myString.o -o prog

myString.o: myString.cpp myString.h
	g++ myString.cpp -c

stringStack.o: stringStack.cpp stringStack.h
	g++ stringStack.cpp -c

stringStackTest.o: stringStackTest.cpp stringStack.h myString.h
	g++ stringStackTest.cpp -c

clean:
	rm -f *.o *~
