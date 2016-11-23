
#ifndef MYSTRING_H
#define MYSTRING_H

#include <string>

class MyString
{
    private:
		const std::string myString;

    public:
		MyString(std::string val); 
		void print() const;
	

};
#endif

