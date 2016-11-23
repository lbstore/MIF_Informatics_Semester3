#include <iostream>
#include <string>

using namespace std;

int main()
{
	const double PI = 3.1415926;
	int r;
	string msg = "Iveskite apskritimo spinduli.";
	string msg1 ("Spindulys 16 sistemoje: ");
	
	cout << msg << endl;

	cin >> r;

	cout << msg1 << hex << r << endl;	
	cout << "Apskritimo plotas: " << dec << PI*r*r << endl;

	cout << char(10);

}
