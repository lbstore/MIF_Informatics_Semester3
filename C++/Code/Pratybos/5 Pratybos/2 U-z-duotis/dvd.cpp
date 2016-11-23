#include <iostream>
#include "dvd.h"

using namespace std;


dvd::dvd(float prc, int rtime, string tit)
{
	// priskiriam reiksmes
	price = prc;
	runtime = rtime;
	title = tit;

	cout << "Sukurtas: " << title << endl;
}

dvd::~dvd()
{	
	cout << "Sunaikintas: " << title << endl;
}

void dvd::print()
{
	cout << "Pavadinimas: " << title << endl;
	cout << "Kaina: " << price << " lt" << endl;
	cout << "Trukme: " << runtime << " min" << endl;
}
