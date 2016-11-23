
#include <iostream>
#include "Double.h"

using namespace std;


Double::Double(double x)
{		
		cout << "Constr 1" << endl;
		p = new double;
		*p = x;
}

Double::Double()
{
	cout << "Constr 2" << endl;
}

Double::~Double()
{
	cout << "Destruct" << endl;
	delete p;
	p = NULL;
}

// Copy konstruktorius
Double::Double(Double &d)
{
	cout << "Copy" << endl;

	// Isskiriame naujos vietos
	p = new double;
	// I ta vieta idedame senus duomenis
	*p = *d.p;
	
}
void Double::print() const
{
	cout << *p << endl;
}


void Double::set(double d) 
{
	*p = d;
}

double Double::get() 
{
	return *p;
}


