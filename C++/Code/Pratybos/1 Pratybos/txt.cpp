#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
	ifstream inp;
	int count = 0;
	string word;
	

        inp.open("data.txt");


	while(inp >> word)
	{
		count++;
		cout << word << " ";

	}


	cout << endl << "Faile buvo zodziu: " << count << endl;

}
