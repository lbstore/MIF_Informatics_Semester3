#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(int argc, char* argv[])
{

	if(argc != 3)
	{
		cerr << "Per mazai arba per daug paramentru." << endl;
	}
	else
	{	

		char *file = argv[2];
		string find_word = argv[1];
		
		ifstream inp;
		int count = 0;
		string word;
	

       	inp.open(file);


		while(inp >> word)
		{
			if(word == find_word)
			{
				count++;
			}

		}

		cout << endl << "Zodis: " << find_word << "pasikartoja kartu: " << count << endl;
	}

}
