
#include "fibonat.h"

int fibonat(bool flag)
{

	static int first = 0;
	static int second = 1;

	static int which = 1;

	// Reset?
	if(flag)
	{
		which = 1;
		first = 0;
		second = 1;
	}

	// First or second?
	switch(which)
	{
		case 1:
			which++;
			return first;
		case 2:
			which++;
			return second;
	}


	int third;

	// Doing hard math
	third = first + second;
	first = second;
	second = third;

	// Return updated value
	return second;

}
