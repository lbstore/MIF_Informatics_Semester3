#include<iostream>
#include "int.h"

using namespace std;

Int::Int(int val) : size(val) 
{
    count = 0;
    v = new int *[size];
    cout << "Int konstruktorius" << endl;
}


Int::~Int()
{
	cout << "Int destruktorius" << endl;
		
	// Delete the level
	for(int x = 0; x < size; x++)
	{
		delete [] v[size];
	}

	delete [] v;
}

bool Int::insert(int* val)
{
	if (!full()) {
    		v[count] = val; 
   		 count++; 
		return true;
	}
	else {
		cout << "Masyvas yra pilnas" << endl;
		return false;
	}   
}

const int* Int::getNumber(int which) const
{
	if (count > 0) 
	{ 

   		return (v[which]);
	}
	else 
	{
		cout << "Masyvas yra tuscias" << endl;
	}
}

void Int::printAll() const
{
	for(int i = 0; i < count; i++)
	{
		cout << *(getNumber(i)) << endl;
	}
}


bool Int::full() const
{
    return (count >= size);
}
 
bool Int::empty() const
{
    return (count == 0);
}

