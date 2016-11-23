
#include <iostream>
#include "class.h"

using namespace std;

// Inicilizuojame statinius kintamuosius
int MyClass::created = 0;
int MyClass::destroyed = 0;
int MyClass::left = 0;

// Konstruktorius
MyClass::MyClass()
{
	created++; // padidiname sukurtus objektu skaitliuka
	left++; // padidiname kiek objektu siuo metu yra sukurta (yra like)
}

// Destruktorius
MyClass::~MyClass()
{
	destroyed++; // padidiname sunaikintu objektu skaitliuka
	left--; // sumaziname kiek objektu siuo metu yra sukurta (yra like)
}

void MyClass::PrintInfo()
{
	// Tiesiog atspauzdinam informacija apie sukurtus, sunaikintus, esamus objektus
	cout << "Created: " << created << endl;
	cout << "Destroyed: " << destroyed << endl;
	cout << "Left: " << left << endl;
	cout << endl << endl;
}
