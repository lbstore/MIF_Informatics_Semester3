#ifndef MYSTACK_H
#define MYSTACK_H

#include "dvd.h"

class DVDStack
{
	public:
		DVDStack();
		DVDStack(dvd **dvds);
		~DVDStack();

    	void push(dvd *val); // idedame dvd rodykles
		dvd* pop();			// isimame dvd rodykles
		bool full();
		void MyStackPrint();
		bool empty();

	private:
    		dvd *v[20]; // steko masyvas is dvd rodykliu
    		int top;

};

#endif


