#ifndef DVD_H
#define DVD_H

#include <string>

using namespace std;

class dvd
{

	public:
		dvd(float prc, int rtime, string tit);
		~dvd();
		void print();

	private:
		float price;    // kaina
		int runtime;   // trukme
		string title; // pavadinimas

};

#endif
