#include <string>
#include <iostream>

#include "stringStack.h"
#include "myString.h"

using namespace std;

/*
string iceCream[] = {
  "pralines & cream",
  "fudge ripple",
  "jamocha almond fudge",
  "wild mountain blackberry",
  "raspberry sorbet",
  "lemon swirl",
  "rocky road",
  "deep chocolate fudge"
};

const int iCsz = 
  sizeof iceCream / sizeof *iceCream;
*/

int main() {
	// Sukuriam tris myString objektus
	MyString s1("Labas rytas");
	MyString s2("Laba diena");
	MyString s3("Labas vakaras");

	// Sukuriam steko objekt1
  	StringStack ss;

	// Idedam i ta stack tuos tris objektus
    ss.push(&s1);
	ss.push(&s2);
	ss.push(&s3);

	// Laikinas kintamasis laikyti duomenis
  	const MyString* cp;

	cp = ss.pop();

  	//while((cp = ss.pop()) != NULL)

   	cp->print();
} 
