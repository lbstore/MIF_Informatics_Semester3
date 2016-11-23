#include <iostream>
#include "myclass.h"

using namespace std;

void MyClass::f(void)
{
    cout << "Funkcija be parametru" << endl;
}

void MyClass::f(int x)
{
    cout << "Funkcija su 1 parametru x: " << x << endl;
}

void MyClass::f(int x, int y)
{
    cout << "Funkcija su 2 parametrais x ir y: " << x << ", " << y << endl;
}

void MyClass::f(int x, int y, int z)
{
    cout << "Funkcija su 3 parametrais x, y ir z: " << x << ", " << y << ", " << z << endl;
}

void MyClass::d(int x, int y, int z, int o)
{
    cout << "Funkcija su 3 parametrais x, y ir z: " << x << ", " << y << ", " << z << endl;
}

