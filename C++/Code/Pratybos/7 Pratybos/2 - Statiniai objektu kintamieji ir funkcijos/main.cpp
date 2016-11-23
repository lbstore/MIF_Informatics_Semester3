
#include<iostream>
#include "class.h"

using namespace std;

int main()
{

	// Sukuriam tris klases
	MyClass *class1 = new MyClass;
	MyClass *class2 = new MyClass;
	MyClass *class3 = new MyClass;

	// Atspauzdinam informacija
	MyClass::PrintInfo();

	// Istrinam viena klase
	delete class1;

	// Atspauzdinam pasikeitusia informacija
	MyClass::PrintInfo();


} 
