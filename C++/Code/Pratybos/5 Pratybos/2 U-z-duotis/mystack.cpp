#include <iostream>
#include "mystack.h"

using namespace std;


DVDStack::DVDStack()
{	
	cout << "Stekas sukurtas" << endl;
    	top = 0;
}

DVDStack::DVDStack(dvd **dvds)
{
	top = 0;

	while(*dvds != 0)
	{
		push(*dvds);
		*dvds++;
	}
}

DVDStack::~DVDStack()
{	
	if(empty())
	{
		cout << "Tuscias stekas sunaikintas" << endl;
	}
	else
	{
		cout << "Stekas su " << top << " elementais, buvo sunaikintas" << endl;
	}
	
    	
}

// grazina 1 jei tuscias bei 0 jei ne tuscias
bool DVDStack::empty()
{
    return (top == 0);   
}

// ideda i steka dvd rodykle
void DVDStack::push(dvd *val)
{
	if(full())
	{
		cout << "Stekas pilnas ir ideti elemento negalima" << endl;
	}
	else
	{
		v[ top ] = val; 
		top++;    
	}
}

// isima dvd rodykle
dvd* DVDStack::pop()
{
	if(empty())
	{
		cout << "Stekas tuscias ir isimti nera ko" << endl;
	}
	else
	{
		top--;
		return (v[top]);
	}
}

bool DVDStack::full()
{
    return (top >= 20);
}

void DVDStack::MyStackPrint()
{
    int i;

    if (empty())
	{
       cout << "DVDStack is empty." << endl;
	}
    else
    {
       cout << "DVDStack contents: ";
       for (i=0; i<top; i++)
       {
          v[i]->print(); 
       }
       cout << endl;
    }
}
