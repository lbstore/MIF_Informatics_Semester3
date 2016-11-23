
#include <iostream>

#include "name1.h"
#include "name2.h"


void ABendoraitis::HelloWorld(void)
{
	std::cout << "Hello World!" << std::endl;
}

void ABendoraitis::Add(int a, int b)
{
	std::cout << a << " + " << b << " = " << a+b << std::endl;
}

void ABendoraitis::ByeWorld(void)
{
	std::cout << "Bye World!" << std::endl;
}

void ABendoraitis::Sub(int a, int b)
{
	std::cout << a << " - " << b << " = " << a-b << std::endl;
}
