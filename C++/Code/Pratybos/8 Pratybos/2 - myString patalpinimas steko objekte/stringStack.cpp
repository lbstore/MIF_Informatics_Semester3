#include<iostream>
#include "stringStack.h"

using namespace std;

bool StringStack::push(const MyString* val)
{
	if (top < size) {
    		v[ top ] = val; 
    		top++; 
		return true;
	}
	else {
		cout << "StringStack::push : ERROR : Stekas yra pilnas" << endl;
		return false;
	}   
}

const MyString* StringStack::pop()
{
	if (top > 0) { 
    	top--;
   		return (v[top]);
	}
	else {
		cout << "StringStack::pop : ERROR : Stekas yra tuscias" << endl;
		return NULL;
	}
}


bool StringStack::full()
{
    return (top >= size);
}

bool StringStack::empty()
{
    return (top == 0);
}


StringStack::StringStack() 
{
    top = 0;
    cout << "StringStack konstruktorius" << endl;
}


StringStack::~StringStack(){
		cout << "StringStack destruktorius" << endl;
		if (top != 0) cout << "StringStack objektas buvo netuscias!" << endl;
}

