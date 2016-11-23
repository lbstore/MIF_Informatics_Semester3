#include<iostream>
#include "myString.h"

using namespace std;

MyString::MyString(string val) : myString(val) 
{
 
}

void MyString::print() const
{
	cout << myString << endl;
}


