
#include <iostream>
#include "name1.h"
#include "name2.h"

namespace AB = ABendoraitis;

void Call1(void)
{
	AB::HelloWorld();
	AB::Add(4, 5);
}

void Call2(void)
{
	using namespace AB; 

	ByeWorld();
	Sub(4, 5);
}


int main()
{
	Call1();
	Call2();
} 
