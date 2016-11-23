build: Main clean

Main: Main.o Worker.o Person.o
	g++ Main.o Worker.o Person.o -o Test

Main.o: Main/Main.cpp Stack/Stack.h Exception/Exception.h Worker/Worker.h
	g++ Main/Main.cpp Stack/Stack.h Exception/Exception.h Worker/Worker.h -c

Worker.o: Worker/Worker.cpp Worker/Worker.h Person/Person.h
	g++ Worker/Worker.cpp Worker/Worker.h Person/Person.h -c

Person.o: Person/Person.cpp Person/Person.h
	g++ Person/Person.cpp Person/Person.h -c
clean:
	rm -f */*.o */*.~ *.o *.~ */*.h.gch */*.h~ */*.cpp~ makefile~

run:
	./Test