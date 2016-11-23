
#ifndef STRINGSTACK_H
#define STRINGSTACK_H

#include "myString.h"

class StringStack
{
    static const int size = 100;
    const MyString* v[size];
    int top;
    public:
    	bool push(const MyString* val);
	const MyString* pop();
	bool full();
	bool empty();
	StringStack(); 
	~StringStack();
};
#endif

