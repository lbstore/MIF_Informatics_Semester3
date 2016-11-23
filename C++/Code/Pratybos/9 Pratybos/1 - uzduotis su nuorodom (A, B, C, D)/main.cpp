
#include <iostream>

using namespace std;

// C)
int &change_val(int *p, int val)
{
	*p = val;
	return *p;
}

// D)
void func(int *&var)
{
	delete var;

	var = new int[1000];
}

int main() 
{
	// A) Klaida, nes nuorodos yra konstantos ir jas butina inicializuoti 	
	// int &A;
	
	// B)
	int C = 5, D = 7;
	int &B = C;

	B = D;

	cout << B << endl;
	cout << C << endl;

	// C)
	change_val(&B, 10);

	cout << B << endl;
	cout << C << endl;

    // D)	
	int * G = new int(500);
	int * & E = G;

	func(E);

	E[777] = 450;
	
	cout << "777: " << E[777] << endl;
	
}
