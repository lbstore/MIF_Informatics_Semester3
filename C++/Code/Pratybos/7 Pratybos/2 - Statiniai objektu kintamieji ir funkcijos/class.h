#ifndef CLASS_H
#define CLASS_H

class MyClass 
{
	public:
		MyClass();
		~MyClass();
		static void PrintInfo();

	private:
		static int created; // sukurta
		static int destroyed; // sunaikinta
		static int left; // yra siuo metu (lik?)

};

#endif
