// From "Thinking in C++, 2nd Edition, Volume 1, Annotated Solutions Guide"
// by Chuck Allison, (c) 2001 MindView, Inc. all rights reserved
// Available at www.BruceEckel.com.
// modified by I.M. on 24/10/2008; 19/10/2009

#include <iostream>
#include "Double.h"


void f(Double d)
{
    d.print();
}


int main() {
    Double d(5);
    f(d);
    d.print();
}
