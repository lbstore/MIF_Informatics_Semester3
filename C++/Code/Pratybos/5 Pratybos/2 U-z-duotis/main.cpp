/****************************************************************************/
/*   Sample C stack tester demonstrating the usage of mystack functions.    */
/*   Stack struct is declared and functions are prototyped in mystack.h.    */ 
/*   The ANSI C code for the functions is in mystack.c. A&B                 */
/*                                                                          */
/****************************************************************************/
#include<iostream>
#include "dvd.h"
#include "mystack.h"

using namespace std;

int main()
{

	// laikinam elementui
	dvd *TempDVD;

	// sukuriame du dvd dinamineje atmintyje
	dvd *dvd1 = new dvd(59.99, 124, "I Robot");
	dvd *dvd2 = new dvd(79.99, 14, "Saw");

	dvd* Array[] = {dvd1, dvd2, 0};

	// musu stekas
	DVDStack mystack(Array); 

	// isimam keturis elementus (tiksliau du, ir po to gaunam dvi klaidos zinutes, kad nera ko isimti daugiau)
	TempDVD = mystack.pop();
	TempDVD = mystack.pop();
	TempDVD = mystack.pop();
	TempDVD = mystack.pop();

	
	// atspauzdinam kas yra steke (tai yra, kad nieko nera)
	cout << endl;
	mystack.MyStackPrint();
	

	// istriname visus elementus is steko.
	while(!mystack.empty())
	{
		delete(mystack.pop());
	}

	// istrinam laikina isimta elementa
	delete TempDVD;
} 
